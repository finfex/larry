class VacuumWorker
  include Sidekiq::Worker

  def perform
    ActiveRecord::Base.descendants.each {|ar| ar.vacuum }
  end
end
