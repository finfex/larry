# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Public
  class ProfilesController < ApplicationController
    def show
      unauthenticated! unless authenticated?
    end
  end
end
