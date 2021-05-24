# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Warden
  class SessionSerializer
    def serialize(record)
      [record.class.name, record.id]
    end

    def deserialize(keys)
      klass, id = keys
      klass.constantize.find_by(id: id)
    end
  end
end

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = ->(env) { Authentication::SessionsController.action(:new).call(env) }
end

Warden::Strategies.add(:password) do
  def valid?
    params.fetch(scope).keys.sort == %w[password email].sort
  end

  def authenticate!
    person = scope_class.find_by(email: session_form_attrs.fetch(:email))
    if person.present? && person.authenticate(session_form_attrs.fetch(:password))
      success! person, 'You are welcome!'
    else
      fail! 'Wring credentials'
    end
  end

  def scope_class
    params.fetch(:scope).classify.constantize
  end

  def session_form_attrs
    params.fetch scope
  end
end
