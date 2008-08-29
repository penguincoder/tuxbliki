require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Feeds, "index action" do
  before(:each) do
    dispatch_to(Feeds, :index)
  end
end