# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Base application command class
#
class ApplicationCommand
  def self.call(args)
    new.call(**args)
  end
end
