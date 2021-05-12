# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Adjectives concern for Authorizer
#
# TODO: Move to Authority gem
#
module AuthorizerAdjectives
  extend ActiveSupport::Concern

  DEFAULT_ADJECTIVES = %i[readable creatable updatable deletable].freeze

  # Map to convert adjective -> verbs
  # {:creatable=>:create, :readable=>:read, :updatable=>:update, :deletable=>:destroy, :acceptable=>:accept, :rejectable=>:reject}
  #
  VERBS = Authority.abilities.invert.symbolize_keys

  included do
    class_attribute :restricted_attributes # Attributes resitrected to change by NOT admin
    class_attribute :adjectives
  end

  # Class methods
  module ClassMethods
    def restricted_attributes_set
      Set.new(Array(restricted_attributes).map(&:to_s)).freeze
    end

    def allowed_adjectives
      Set.new adjectives || DEFAULT_ADJECTIVES
    end

    def allowed_adjective?(adjective)
      allowed_adjectives.include? adjective.to_sym
    end

    def require_allowed_adjective!(adjective)
      return true if allowed_adjective? adjective

      raise "Adjective (#{adjective}) is not allowed for this authorizer (#{self}). Allowed set: #{allowed_adjectives.to_a.join(', ')}"
    end

    def verb_from_adjective(adjective)
      VERBS[adjective] || raise("Unknown adjective (#{adjective})")
    end
  end
end
