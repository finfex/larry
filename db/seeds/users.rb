# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

AdminUser.create_with(password: 'password').find_or_create_by!(email: 'admin@localhost')
User.create_with(password: 'password').find_or_create_by!(email: 'user@localhost')
