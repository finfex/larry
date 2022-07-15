class VacuumWorker
  include Sidekiq::Worker

  sidekiq_options unique_across_workers: true, queue: 'default', lock: :until_and_while_executing

  def perform
    ActiveRecord::Base.descendants.each {|ar| ar.vacuum }
  end
end
