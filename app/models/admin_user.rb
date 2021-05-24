class AdminUser < ApplicationRecord
  has_secure_password
  include Authority::UserAbilities
  include Authority::Abilities

  def name
    email
  end

  def has_permission?(subject, method)
    true
    # role.present? && role.has_any_permission?(subject, method, self)
  end
  # TODO Move to table
  def superadmin?
    true
  end
end
