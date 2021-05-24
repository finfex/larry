class User < ApplicationRecord
  has_secure_password
  include Authority::Abilities
  include Authority::Abilities
end
