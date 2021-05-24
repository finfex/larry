class Authentication::SessionsController < ApplicationController
  SCOPE_RESOURCES = { default: User, admin_user: AdminUser }
  helper_method :session_resource, :session_resoruce_class, :session_scope

  def create
    authenticate! scope: params.fetch(:scope)
    binding.pry
    redirect_to request.session[:admin_user_redirect_back].presence || welcome_url
  end

  private

  def welcome_url
    if params.fetch(:scope) == 'admin_user'
      redirect_to operator_root_url
    else
      redirect_to root_url
    end
  end

  def session_scope
    session_resource.class.name.underscore
  end

  def session_resoruce_class
    SCOPE_RESOURCES[
      (request.env['warden.options'] || {}).fetch(:scope, :default)
    ] || raise("Unknown session_resource")
  end

  def session_resource
    session_resoruce_class.new
  end
end
