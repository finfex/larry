# frozen_string_literal: true

# Concert for authorizers gives acceptable and rejectable methods
#
module AuthorizerAcceptable
  extend ActiveSupport::Concern
  included do
    self.adjectives = %i[readable creatable updatable acceptable rejectable]
  end

  def acceptable_by?(user)
    user.superadmin? ||
      user.permission(resource, :accept) && resource.pending?
  end

  def rejectable_by?(user)
    user.superadmin? ||
      user.permission(resource, :reject) && resource.pending?
  end
end
