class OrderAuthorizer < ApplicationAuthorizer
  class << self
    # @param [Symbol] adjective; example: `:creatable`
    # @param [Object] user - whatever represents the current user in your app
    # @return [Boolean]
    def default(adjective, user)
      true
    end
  end
end
