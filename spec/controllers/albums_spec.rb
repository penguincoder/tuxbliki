require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe Albums, "index action" do
  before(:each) do
    dispatch_to(Albums, :index)
  end
end