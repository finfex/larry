# frozen_string_literal: true

# Other authorizers should subclass this one
class ApplicationAuthorizer < Authority::Authorizer
  include AuthorizerAdjectives

  class << self
    # @param [Symbol] adjective; example: `:creatable`
    # @param [Object] user - whatever represents the current user in your app
    # @return [Boolean]
    def default(adjective, user)
      require_allowed_adjective! adjective
      return false if user.nil?

      user.permission? resource_name, verb_from_adjective(adjective)
    end

    private

    def resource_name
      raise "Неизвестынй ресурс #{self}" if self == ::ApplicationAuthorizer

      name.gsub(/Authorizer$/, '')
    end
  end

  def default(adjective, user)
    self.class.require_allowed_adjective! adjective
    user.permission? resource, self.class.verb_from_adjective(adjective)
  end

  def updatable_by?(user, attributes_to_change: [])
    return true if user.is_super_admin?
    return false unless user.permission? resource, :update

    changed_attributes = resource.respond_to?(:changed_attributes) ? resource.changed_attributes.keys : []
    return true if changed_attributes.empty? && attributes_to_change.empty?

    attributes_to_change = (changed_attributes + Array(attributes_to_change).map(&:to_s)).uniq.compact

    !self.class.restricted_attributes_set.intersect? Set.new(attributes_to_change)
  end
end
