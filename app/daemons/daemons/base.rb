# frozen_string_literal: true

module Daemons
  class Base
    class GetLockError < StandardError; end
    class << self; attr_accessor :sleep_time end

    attr_accessor :running
    attr_reader :logger

    def initialize
      @running = true
      @logger = Rails.logger.tagged self.class.name
    end

    def stop
      Rails.logger.info { { message: 'Stop worker', app_version: AppVersion.to_s, service: self.class.name } }
      @running = false
    end

    def run
      Rails.logger.info { { message: 'Start worker', app_version: AppVersion.to_s, service: self.class.name } }

      while running
        begin
          process
        rescue ScriptError => e
          raise e if is_db_connection_error?(e)

          report_exception(e, true, service: self.class.name)
        rescue StandardError => e
          report_exception(e, true, service: self.class.name)
          sleep 30
        end
        wait
      end
    end

    def process
      method_not_implemented
    end

    def wait
      Kernel.sleep self.class.sleep_time.to_i
    end
  end
end
