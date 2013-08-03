# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :suite do
    DatabaseCleaner[:active_record].strategy = :transaction
  end

  config.before :each do
    DatabaseCleaner[:active_record].start
  end

  config.after :each do
    DatabaseCleaner[:active_record].clean
  end

  config.around :each, time_freeze: ->(value){ value.is_a?(Date) || value.is_a?(Time) } do |example|
    Timecop.freeze(example.metadata[:time_freeze]){ example.run }
  end
end
