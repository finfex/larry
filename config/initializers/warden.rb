class Warden::SessionSerializer
  def serialize(record)
    binding.pry
    [record.class.name, record.id]
  end

  def deserialize(keys)
    binding.pry
    klass, id = keys
    klass.find_by(id: id)
  end
end

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :password
  manager.failure_app = lambda { |env| Authentication::SessionsController.action(:new).call(env) }
end

Warden::Strategies.add(:password) do
  def valid?
    params['email'] && params['password']
  end

  def authenticate!
    binding.pry
    user = User.find_by_email(params['email'])
    if user && user.authenticate(params['password'])
      success! user
    else
      fail "Invalid email or password"
    end
  end
end
