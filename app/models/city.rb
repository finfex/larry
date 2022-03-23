class City < ApplicationRecord
  has_many :orders

  scope :available, -> { all}
  scope :ordered, -> { order :name }

  def to_s
    name
  end
end
