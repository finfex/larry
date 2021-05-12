# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class OpenbillRecord < ApplicationRecord
  self.abstract_class = true

  # def self.model_name
  # ActiveModel::Name.new(self, nil, name.gsub('Openbill', ''))
  # end
end
