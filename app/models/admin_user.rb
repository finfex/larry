# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AdminUser < ApplicationRecord
  has_secure_password
  include Authority::UserAbilities
  include Authority::Abilities
  include Archivable
  strip_attributes

  validates :email, presence: true, email: true

  ROLES = %w[superadmin operator]

  validates :role, presence: true, inclusion: { in: ROLES }

  def is_super_admin?
    role == 'superadmin'
  end

  def name
    email
  end

  def to_s
    name
  end

  # rubocop:disable Naming/PredicateName
  def has_permission?(_subject, _method)
    is_super_admin?
    # role.present? && role.has_any_permission?(subject, method, self)
  end
  # rubocop:enable Naming/PredicateName
end
