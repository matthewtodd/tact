require 'spec_helper'

require 'support/fake_google_api'
require 'support/fake_things_app'

describe 'tact' do
  subject do
    Tact::Application.new(google, things)
  end

  let(:google) { Tact::Google.new(api) }
  let(:things) { Tact::Things.new(app) }
  let(:api)    { FakeGoogleApi.new }
  let(:app)    { FakeThingsApp.new }

  before do
    api.setup 'Inbox' => ['Buy things']
  end

  it 'moves Google Tasks inbox into Things inbox' do
    google.inbox.to_a.should == ['Buy things']
    things.inbox.to_a.should == []

    subject.run

    google.inbox.to_a.should == []
    things.inbox.to_a.should == ['Buy things']
  end
end
