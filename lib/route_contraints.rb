# frozen_string_literal: true

module RouteConstraints
  class AdminRequiredConstraint
    def matches?(request)
      request.env['warden'].user(:admin_user).present? || throw(:warden, scope: :admin_user)
    end
  end

  class PublicConstraint
    def matches?(request)
      request.subdomain.blank? || request.subdomain == 'public'
    end
  end
end
