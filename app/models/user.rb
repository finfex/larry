# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class User < ApplicationRecord
  has_secure_password
  include Authority::Abilities

  has_one :partner
end
