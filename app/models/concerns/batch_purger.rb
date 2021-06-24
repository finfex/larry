# frozen_string_literal: true

#  Позволяет удалять записи пакетами, гибко обрабатывая не удаляемые записи
#  (на которых есть используемые foreign key)
#
#
# Как это работает?
#
# Записи удаляются пакетами по 100_000 записей. Если при удалени возникнет исключение,
# то пакет разбивается на две равные части и они удаляются по-очереди. Так до тех пор,
# пока не удаляются все возможные записи на которых нет ссылок.
#
# Подключение:
#
# class ApplicationRecord < ActiveRecord::Base
#  extend BatchPurger
#
# Использование:
#
# > Order.where('created_at < ?', 12.days.ago).batch_purge
#
# TODO Вынести в отдельный gem
#
module BatchPurger
  require 'ruby-progressbar'

  # На боевом сервере 100 тыс записей удаляется примерно за 10 секунд
  DEFAULT_BATCH_SIZE = Rails.env.production? ? 100_000 : 10_000

  def batch_purge(batch_size: DEFAULT_BATCH_SIZE, min_value: nil, max_value: nil, column: :id, logger: nil)
    min_value ||= minimum(column)
    max_value ||= maximum(column)

    return unless max_value

    raise "max_value (#{max_value}) должен быть >= min_value (#{min_value})" unless max_value >= min_value

    cur_value = min_value

    total = ((max_value - min_value).to_f / batch_size).ceil

    message = "Remove #{table_name} by #{batch_size} records (#{total} times, from #{min_value} to #{max_value})"

    if logger.present?
      logger.info message
    else
      pb = ProgressBar.create total: total, title: message unless logger
    end

    count = 1
    loop do
      if logger.present?
        logger.info "#{table_name}: #{min_value} / #{cur_value} / #{max_value} (#{count}/#{total})"
      else
        pb.increment
      end
      next_value = cur_value + batch_size
      next_value = max_value if next_value > max_value

      begin
        where("#{column} >= ? and #{column} <= ?", cur_value, next_value).delete_all
      rescue ActiveRecord::StatementInvalid => err
        logger.error err if logger.present?
        if next_value > cur_value
          medium_value = cur_value + (next_value - cur_value) / 2
          batch_purge min_value: cur_value, max_value: medium_value
          batch_purge min_value: medium_value + 1, max_value: next_value if medium_value < next_value
        end
      end

      count += 1
      cur_value = next_value
      break if cur_value >= max_value
    end
    logger.info 'Done' if logger.present?
  end
end
