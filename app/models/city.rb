# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class City < ApplicationRecord
  has_many :orders

  scope :available, -> { all }
  scope :ordered, -> { order :name }

  def to_s
    name
  end
end
