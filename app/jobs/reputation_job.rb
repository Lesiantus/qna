class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    ExternalServices::Reputation.calculate(object)
  end
end
