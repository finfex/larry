# Larry. Digital Assets Exchange Service

[![Build Status](https://travis-ci.com/finfex/larry.svg?branch=master)](https://travis-ci.com/finfex/larry)

## Specification

* All database primary keys are UUID's
* Предварительно рассчитанный курс

## Install for development

```
rbenv install
git submodule init
git submodule update
bundle
nvm install
yarn install
```

## Development

> rake db:create db:migrate db:seed

Update source, basic and public rates

> rake gera:update_rates

Then look into logs/gera_*.log for logs

Run services

> bundle exec foreman start

Run auto tests:

> bundle exec guard

## Update gera migration

> rm db/migrate/*.gera.*; rake gera:install:migrations  


# Deploy with capistrano

> bundle exec cap production deploy:check
> bundle exec cap production master_key:setup  
> bundle exec cap production config:set RAILS_ENV=production
> bundle exec cap production systemd:puma:setup systemd:sidekiq:setup 
> bundle exec cap production shell

> RAILS_ENV=production bundle exec rake db:seed
> RAILS_ENV=production bundle exec rake telegram:bot:set_webhook 


