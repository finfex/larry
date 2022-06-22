web: bundle exec rails s
webpacker: ./bin/webpack-dev-server
sidekiq: bundle exec sidekiq -q default -q critical -q purgers -q direction_rates
telegram: rake telegram:bot:poller
rates_fetcher: RAILS_ROOT=. bundle exec ruby ./lib/daemon.rb rates_fetcher
