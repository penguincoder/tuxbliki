require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Invitations, "index action" do
  before(:each) do
    dispatch_to(Invitations, :index)
  end
end