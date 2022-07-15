module Daemons
  class Cleaner < Base
    @cleaner = 1.hour
    def process
      logger.info('Clean')
    rescue => err
      report_exception err
      logger.error err
    end
  end
end
