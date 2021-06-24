# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Page < ApplicationRecord
  include Authority::Abilities

  scope :for_menu, -> { order(:menu_title) }

  validates :menu_title, presence: true, uniqueness: true
  validates :html_title, presence: true
  validates :path, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9-_]+\z/, message: 'Путь может содержать только латиницу, цифры, минус и подчеркивание' }
  validates :content, presence: true

  has_rich_text :content
end
