# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module ArchivableActions
  extend ActiveSupport::Concern

  included do
    helper_method :resource_scope_type, :base_scope, :current_scope, :resource
  end

  def archive
    authorize_action_for(resource)

    resource.archive!
    archivable_success_redirect
  end

  def destroy
    archive
  end

  def restore
    resource.restore!
    archivable_success_redirect
  end

  private

  def base_scope
    raise NotImplemented
  end

  def resource_scope_type
    case params[:scope].to_s
    when 'archive'
      :archive
    when 'all'
      :all
    else
      :alive
    end
  end

  def current_scope
    case resource_scope_type
    when :archive
      base_scope.archive
    when :all
      base_scope
    when :alive
      base_scope.alive
    else
      raise "Unknown resource_scope_type: #{resource_scope_type}"
    end
  end

  def archivable_success_redirect
    success_redirect
  end
end
