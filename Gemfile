source 'https://rubygems.org'

gemspec

gem 'ntl-actor'

source 'https://gem.fury.io/eventide' do
  gem 'event_store-consumer'
  gem 'event_store-messaging', '>= 0.7.0.0.pre1'
  gem 'event_store-entity_projection', '>= 0.4.0.0.pre2'
  gem 'event_store-entity_store', '>= 0.4.0.0.pre1'
end

source "https://#{ENV.fetch 'OBSIDIAN_GEMFURY_SECRET'}@gem.fury.io/obsidian" do
  gem 'event_store-consumer-error_handler'
end

source 'https://gem.fury.io/obsidian' do
  gem 'data_aggregation-copy_message'
  gem 'fixtures-expect_message'
end

group :development do
  gem 'evt-process_host'
  gem 'pry'
  gem 'pry-doc'
  gem 'test_bench'
end
