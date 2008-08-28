use Merb::Rack::Static, Merb.dir_for(:public)
run Merb::Rack::Application.new
