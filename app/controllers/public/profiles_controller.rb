module Public
  class ProfilesController < ApplicationController
    def show
      unauthenticated! unless authenticated?(:user)
    end
  end
end
