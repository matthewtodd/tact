require 'spec_helper'

describe 'tact' do
  let(:google) { Tact::Google.new }
  let(:things) { Tact::Things.new }

  subject do
    Tact::Application.new(google, things)
  end

  let(:task) { Tact::Task.new }

  it 'moves Google Tasks inbox into Things inbox' do
    google.inbox << task

    google.inbox.to_a.should == [task]
    things.inbox.to_a.should == []

    subject.run

    google.inbox.to_a.should == []
    things.inbox.to_a.should == [task]
  end
end
