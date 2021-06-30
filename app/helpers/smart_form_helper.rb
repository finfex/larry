# frozen_string_literal: true

module SmartFormHelper
  SIMPLE_FORM_AS = {
    input: :string,
    checkbox: :boolean
  }.freeze

  DISABLED_COLUMNS = %i[currency_iso_code currency]

  def smart_input(form, column, params = {})
    as, collection, disabled = smart_get_as_input form.object, column
    as = SIMPLE_FORM_AS[as] || as
    form.input column, { as: as, collection: collection, include_blank: false, disabled: disabled }.merge(params)
  end

  def smart_best_in_place(scope, column, value, collection: nil)
    record = scope.last
    as, builded_collection, disabled = smart_get_as_input record, column
    collection ||= builded_collection
    best_in_place scope, column, as: as, value: value, collection: collection
  end

  def smart_get_as_input(record, column)
    record = record.object if record.is_a? Draper::Decorator
    record_class = record.class
    attribute_name = record_class.attribute_aliases[column.to_s] || column.to_s
    column_type = record_class.columns_hash[attribute_name]

    value = record.send column
    # best in place
    # [:input, :textarea, :select, :checkbox, :date]
    if %w[currency currency_iso_code].include?(attribute_name)
      as = :select
      collection = Currency.alive.pluck(:id).map { |v| [v, v] }
      collection = collection + [[value, value]] if value.present? && !collection.find { |c| c.first == value }
    elsif column_type.nil?
      # PaymentSystem#currency
      as = :input
    elsif column_type.type == :boolean
      as = :checkbox

      # enum
    elsif record_class.respond_to?(:enumerized_attributes) && record_class.enumerized_attributes[column].present? || # gem enumerize
          record_class.defined_enums[attribute_name].present? # rails enum rubocop:disable Layout/MultilineOperationIndentation

      as = :select
      collection = smart_get_collection(record_class, attribute_name, record)

      # belongs_to
    elsif record.class.uploaders.include? column.to_sym
      as = :file
    elsif record.class.attribute_types[column.to_s].is_a? ActiveRecord::Type::Text
      as = :text
    else
      as = :input
    end

    binding.pry if column.to_s == 'payment_system_id'

    disabled = false
    disabled = true if record.persisted? && DISABLED_COLUMNS.include?(column.to_sym)
    [as, collection, disabled]
  end

  def smart_get_collection(record_class, attribute_name, _record = nil)
    if record_class.respond_to?(:enumerized_attributes) && record_class.enumerized_attributes[attribute_name.to_sym].present? # gem enumerize
      [[t('.not_selected'), '']] + record_class.enumerized_attributes[attribute_name.to_sym].values.map { |v| [v, v] }
    elsif record_class.defined_enums[attribute_name.to_s].present? # рельсовый enum
      record_class.defined_enums[attribute_name].keys.map do |attribute_value|
        scope = "enums.#{record_class.name.underscore}.#{attribute_name}.#{attribute_value}"
        [(I18n.exists?(scope) ? I18n.t(scope) : attribute_value), attribute_value]
      end
    end
  end
end
