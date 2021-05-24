class Warden::SessionSerializer
  def serialize(record)
    [record.class.name, record.id]
  end

  def deserialize(keys)
    klass, id = keys
    klass.constantize.find_by(id: id)
  end
end

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = lambda { |env| Authentication::SessionsController.action(:new).call(env) }
end

Warden::Strategies.add(:password) do
  def valid?
    params.fetch(scope).keys.sort ==  ["password", "email"].sort
  end

  def authenticate!
    person = scope_class.find_by(email: session_form_attrs.fetch(:email))
    if person.present? && person.authenticate(session_form_attrs.fetch(:password))
      # env['warden'].set_user person, scope: scope
      # request.session[:admin_user_redirect_back]
      success! person, 'You are welcome!'
      binding.pry
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
