# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module RouteConstraints
  # Contraint to user logged
  class UserRequiredConstraint
    def matches?(request)
      request.env['warden'].user(:user).present? || throw(:warden, scope: :user)
    end
  end

  # Contraint to admin-only resources
  class AdminRequiredConstraint
    def matches?(request)
      return true if request.env['warden'].user(:admin_user).present?

      request.session[:admin_user_redirect_back] = request.url
      throw(:warden, scope: :admin_user)
    end
  end

  # Contraint to public resources
  class PublicConstraint
    def matches?(request)
      request.subdomain.blank? || request.subdomain == 'public'
    end
  end
end
