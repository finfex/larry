module Public
  class ProfilesController < ApplicationController
    def show
      raise Unauthenticated unless authenticated?(:user)
    end
  end
end
