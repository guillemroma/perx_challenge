require 'rails_helper'
require 'json'
require 'support/factory_bot'
require 'pry'

describe 'Check Birthday Job', type: :job do
  include ActiveJob::TestHelper

  subject(:job) { CheckBirthdayJob.perform_later }

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'Check Birthday Job creates an instance of Check Birthday service' do
    allow(CheckBirthday).to receive(:new)

    CheckBirthdayJob.perform_now

    expect(CheckBirthday).to receive(:new)
  end
end
