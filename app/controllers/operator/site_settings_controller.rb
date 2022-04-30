module Operator
  class SiteSettingsController < ApplicationController
    authorize_actions_for SiteSettings

    def index
    end

    def edit
      render locals: { ss: ss }
    end

    def update
      ss.update! value: params.require(:site_settings).permit(:value).fetch(:value)
      redirect_to operator_site_settings_path
    rescue ActiveRecord::RecordInvalid => e
      render locals: { ss: e }
    end

    private

    def ss
      @ss ||= SiteSettings.find params[:id]
    end
  end
end
