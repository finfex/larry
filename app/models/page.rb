class Page < ApplicationRecord
  include Authority::Abilities

  validates :menu_title, presence: true, uniqueness: true
  validates :html_title, presence: true
  validates :path, presence: true, uniqueness: true, format: { with: /\A[a-z0-9-_]+\z/, message: 'Путь может содержать только латиницу, цифры, минус и подчеркивание' }
  validates :content, presence: true
end
