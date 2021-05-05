class AdminUser < ApplicationRecord
  include Authority::UserAbilities
  authenticates_with_sorcery!
  def has_permission?(_subject, _method) # rubocop:disable  Naming/PredicateName
    raise 'this is not AdminUser'
  end
end
