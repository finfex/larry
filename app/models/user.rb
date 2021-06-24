# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class User < ApplicationRecord
  has_secure_password
  include Authority::Abilities

  validates :email, presence: true, uniqueness: true

  has_one :partner

  after_create :create_partner
end
