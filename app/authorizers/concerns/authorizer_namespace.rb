# frozen_string_literal: true

# Namespace support authorizer concern
#
module AuthorizerNamespace
  extend ActiveSupport::Concern
  included do
    self.adjectives = %i[readable]

    def self.default(adjective, user)
      raise "WTF? #{adjective}. Скорее всего не установлен authorize_actions_for в контроллере" unless adjective == :readable

      super
    end
  end
end
