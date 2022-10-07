require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe UpdateUserPointsJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job_later) { described_class.perform_later }

  before(:each) do
    @client = FactoryBot.create(:user_client)
  end

  it 'Queues the job' do
    expect { job_later }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it "Calls Update User Points service" do
    allow(UpdateUserPoints).to receive(:new).and_return(UpdateUserPoints.new(@client.id))
    expect_any_instance_of(UpdateUserPoints).to receive(:call)

    described_class.perform_now(@client.id)
  end
end
