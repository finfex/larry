module Authentication
  class ApplicationController < ::ApplicationController
    SCOPE_RESOURCES = { user: User, admin_user: AdminUser }.freeze
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
      scope = (request.env['warden.options'] || {}).fetch(:scope, :user).to_sym
      SCOPE_RESOURCES[
        scope
      ] || raise("Unknown session_resource scope (#{scope})")
    end

    def session_resource
      session_resoruce_class.new
    end
  end
end
