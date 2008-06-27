require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe News, "index action" do
  before(:each) do
    dispatch_to(News, :index)
  end
end