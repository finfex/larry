# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Authentication
  class ApplicationController < ::ApplicationController
    SCOPE_RESOURCES = { default: User, admin_user: AdminUser }.freeze
    helper_method :session_resource, :session_resoruce_class, :session_scope
    helper_method :redirect_url

    private

    def redirect_url
      return if request.original_url.include?('/session')

      (request.env['warden.options'] || {})
        .fetch(:redirect_url, params[:redirect_url].presence || request.url)
    end

    def welcome_url
      params.fetch(:scope) == 'admin_user' ?  operator_root_url : public_root_url
    end

    def session_scope
      SCOPE_RESOURCES.invert.fetch session_resource.class
    end

    def session_resoruce_class
      scope = (request.env['warden.options'] || {}).fetch(:scope, :default).to_sym
      SCOPE_RESOURCES[
        scope
      ] || raise("Unknown session_resource scope (#{scope})")
    end

    def session_resource
      session_resoruce_class.new
    end
  end
end
