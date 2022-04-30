class DestroyWorker
  include Sidekiq::Worker

  def perform
    Rails.application.load_tasks
    Rake::Task['db:seed:replant'].invoke
  end
end
