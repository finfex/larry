module AdminUserHelper
  def current_admin_user
    current_user(:admin_user)
  end
end
