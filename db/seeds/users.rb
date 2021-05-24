AdminUser.create_with(password: 'password').find_or_create_by!(email: 'admin@localhost')
User.create_with(password: 'password').find_or_create_by!(email: 'user@localhost')
