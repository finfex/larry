# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AdminUser < ApplicationRecord
  has_secure_password
  include Authority::UserAbilities
  include Authority::Abilities

  def name
    email
  end

  def has_permission?(_subject, _method)
    true
    # role.present? && role.has_any_permission?(subject, method, self)
  end

  # TODO: Move to table
  def superadmin?
    true
  end
end
