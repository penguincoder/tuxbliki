require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Permissions, "index action" do
  before(:each) do
    dispatch_to(Permissions, :index)
  end
end