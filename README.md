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


## Update gera migration

> rm db/migrate/*.gera.*; rake gera:install:migrations  
