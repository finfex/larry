# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module RouteConstraints
  # Contraint to user logged
  class UserRequiredConstraint
    def matches?(request)
      request.env['warden'].user(:user).present? || throw(:warden, scope: :default)
    end
  end

  # Contraint to admin-only resources
  class AdminRequiredConstraint
    def matches?(request)
      admin_user = request.env['warden'].user(:admin_user)
      return true if admin_user.present? && admin_user.alive?

      throw :warden, scope: :admin_user, redirect_url: request.url
    end
  end

  # Contraint to public resources
  class PublicConstraint
    def matches?(request)
      request.subdomain.blank? || request.subdomain == 'public'
    end
  end
end
