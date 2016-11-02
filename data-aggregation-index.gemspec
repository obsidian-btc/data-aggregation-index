# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'data_aggregation-index'
  s.version = '0.2.0.0'
  s.summary = 'Event store data aggregation index library'
  s.description = ' '

  s.authors = ['Obsidian Software, Inc']
  s.email = 'developers@obsidianexchange.com'
  s.homepage = 'https://github.com/obsidian-btc/data-aggregation-index'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'
  s.bindir = 'bin'

  s.add_runtime_dependency 'event_store-consumer', '>= 0.3.0.0.pre1'
  s.add_runtime_dependency 'event_store-consumer-error_handler'
  s.add_runtime_dependency 'event_store-entity_store'

  s.add_runtime_dependency 'data_aggregation-copy_message'
end
