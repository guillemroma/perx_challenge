class CheckTop10TransactionsJob < ApplicationJob
  queue_as :default

  def perform(client)
    # Do something later
    service = CheckTop10Transactions.new(client)
    service.call
  end
end
