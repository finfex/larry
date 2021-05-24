class AdminUser < ApplicationRecord
  has_secure_password

  # TODO Move to table
  def superadmin?
    true
  end
end
