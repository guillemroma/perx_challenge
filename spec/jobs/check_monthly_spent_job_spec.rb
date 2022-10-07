require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe CheckMonthlySpentJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job_later) { described_class.perform_later }

  it 'Queues the job' do
    expect { job_later }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it "Calls Check Monthly Spent service" do
    allow(CheckMonthlySpent).to receive(:new).and_return(CheckMonthlySpent.new)
    expect_any_instance_of(CheckMonthlySpent).to receive(:call)

    described_class.perform_now
  end
end
