source 'https://rubygems.org'

gemspec

gem 'ntl-actor'

source "https://#{ENV.fetch 'OBSIDIAN_GEMFURY_SECRET'}@gem.fury.io/obsidian" do
  gem 'event_store-consumer-error_handler', '>= 0.3.0.0.pre1'
end

source 'https://gem.fury.io/obsidian' do
  gem 'data_aggregation-copy_message'
  gem 'fixtures-expect_message', '>= 0.2.0.0.pre1', group: :development
end

group :development do
  gem 'evt-process_host'
  gem 'pry'
  gem 'pry-doc'
  gem 'test_bench'
end
