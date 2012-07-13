When /^I generate a new Rails app$/ do
  @aruba_io_wait_seconds = 10
  app_name = "foobar"
  # install rails with as few things as possible, for speed!
  run_simple "bundle exec rails new #{app_name} --skip-git --skip-active-record --skip-sprockets --skip-javascript --skip-test-unit --old-style-hash"
  cd app_name
end

When /^I add http_accept_language to my Gemfile$/ do
  # Specifiy a path so cucumber will use the unreleased version of the gem
  path = File.expand_path('../../../', __FILE__)
  append_to_file "Gemfile", "gem 'http_accept_language', :path => '#{path}'"
end
