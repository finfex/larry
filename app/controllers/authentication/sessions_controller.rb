class Authentication::SessionsController < ApplicationController
  SCOPE_RESOURCES = { default: User, admin_user: AdminUser }
  helper_method :resource, :resource_class, :resource_name

  private

  def resource_name
    resource_class
  end

  def resource_class
    SCOPE_RESOURCES[
      request.env['warden.options'][:scope] || :default
    ] || raise("Unknown resource")
  end

  def resource
    resource_class.new
  end
end
