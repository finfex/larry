# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Operator
  class PagesController < ApplicationController
    authorize_actions_for Page

    def index
      render locals: { pages: Page.order(:path) }
    end

    def new
      render :new, locals: { page: Page.new }
    end

    def show
      page = Page.find params[:id]
      redirect_to public_page_url(page.path)
    end

    def edit
      page = Page.find params[:id]
      render :edit, locals: { page: page }
    end

    def update
      page = Page.find params[:id]
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

    def permitted_params
      params.require(:page).permit!
    end
  end
end
