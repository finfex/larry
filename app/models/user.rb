# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class User < ApplicationRecord
  include Authority::UserAbilities
  authenticates_with_sorcery!

  def has_permission?(_subject, _method) # rubocop:disable  Naming/PredicateName
    raise 'this is not AdminUser'
  end

  def superadmin?
    raise 'this is not AdminUser'
  end
end
