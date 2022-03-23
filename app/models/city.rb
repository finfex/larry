class City < ApplicationRecord
  has_many :orders

  def to_s
    name
  end
end
