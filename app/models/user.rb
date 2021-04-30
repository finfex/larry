# frozen_string_literal: true

class User < ApplicationRecord
  include Authority::UserAbilities
  authenticates_with_sorcery!

  def permission?(_subject, _method)
    # TODO: use role [Danil]
    true
  end

  def superuser?
    true
  end
end
