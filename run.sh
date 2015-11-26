
bundle exec sidekiq -d
rails runner 'EatBotWorker.perform_async'
