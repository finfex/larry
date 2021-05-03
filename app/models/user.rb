# frozen_string_literal: true

class User < ApplicationRecord
  include Authority::UserAbilities
  authenticates_with_sorcery!

  def has_permission?(_subject, _method) # rubocop:disable  Naming/PredicateName
    # TODO: use role [Danil]
    true
  end

  def superadmin?
    true
  end
end
