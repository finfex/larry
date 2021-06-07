# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operator
  module ApplicationHelper
    def archive_button(resource)
      if resource.archived?
        link_to t('.restore'), url_for([:restore, :operator, resource]), method: :put, class: 'btn btn-sm btn-light'
      else
        link_to t('.archive'), url_for([:archive, :operator, resource]), method: :put, class: 'btn btn-sm btn-light'
      end
    end
  end
end
