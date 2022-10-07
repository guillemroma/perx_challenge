require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe CheckQuarterlySpentJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job_later) { described_class.perform_later }

  it 'Queues the job' do
    expect { job_later }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it "Calls Check Quarterly Spent service" do
    allow(CheckQuarterlySpent).to receive(:new).and_return(CheckQuarterlySpent.new)
    expect_any_instance_of(CheckQuarterlySpent).to receive(:call)

    described_class.perform_now
  end
end
