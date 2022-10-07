require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe YearlyRefreshJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job_later) { described_class.perform_later }

  it 'Queues the job' do
    expect { job_later }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it "Calls Yearly Refresh service" do
    allow(YearlyRefresh).to receive(:new).and_return(YearlyRefresh.new)
    expect_any_instance_of(YearlyRefresh).to receive(:call)

    described_class.perform_now
  end
end
