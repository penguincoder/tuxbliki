require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

describe PhotoTags, "index action" do
  before(:each) do
    dispatch_to(PhotoTags, :index)
  end
end