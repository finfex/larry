# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Operator
  class PagesController < ApplicationController
    include ArchivableActions
    authorize_actions_for Page

    def index
      render locals: { pages: Page.order(:path) }
    end

    def new
      render :new, locals: { page: Page.new }
    end

    def show
      redirect_to public_page_url(page.path)
    end

    def edit
      render :edit, locals: { page: page }
    end

    def update
      page.update! permitted_params
      redirect_to operator_pages_path, notice: 'Изменения приняты'
    rescue ActiveRecord::RecordInvalid
      render :edit, locals: { page: page }
    end

    def create
      page = Page.new permitted_params
      page.save!
      redirect_to operator_pages_path, notice: 'Страница система создана'
    rescue ActiveRecord::RecordInvalid
      render :new, locals: { page: page }
    end

    private

    def resource
      page
    end

    def success_redirect
      redirect_to operator_pages_path
    end

    def page
      @page ||= Page.find params[:id]
    end

    def permitted_params
      params.require(:page).permit!
    end
  end
end
