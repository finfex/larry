# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class PageDecorator < ApplicationDecorator
  delegate_all

  def path
    h.public_page_path(object.path)
  end

  def actions
    h.link_to t('actions.edit'), h.edit_operator_page_url(object.id)
  end
end
