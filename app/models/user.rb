class User < ApplicationRecord
  include Authority::UserAbilities
  authenticates_with_sorcery!

  def has_permission?(subject, method)
    # TODO use role [Danil]
    true
  end
end
