module Authentication
  class ApplicationController < ::ApplicationController
    SCOPE_RESOURCES = { default: User, admin_user: AdminUser }.freeze
    helper_method :session_resource, :session_resoruce_class, :session_scope

    private

    def welcome_url
      if params.fetch(:scope) == 'admin_user'
        redirect_to operator_root_url
      else
        redirect_to public_root_url
      end
    end

    def session_scope
      session_resource.class.name.underscore
    end

    def session_resoruce_class
      SCOPE_RESOURCES[
        (request.env['warden.options'] || {}).fetch(:scope, :default).to_sym
      ] || raise('Unknown session_resource')
    end

    def session_resource
      session_resoruce_class.new
    end
  end
end
