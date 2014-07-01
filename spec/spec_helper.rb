# -*- encoding : utf-8 -*-
require "bundler"
Bundler.setup(:default)
require 'mongoid'
ENV['RACK_ENV'] = 'test'
Mongoid.load!(File.expand_path("../mongoid.yml",__FILE__))
require 'mindpin-feeds'
require 'database_cleaner'
require 'models'
Bundler.require(:test)

RSpec.configure do |config|

  config.before :each do
    DatabaseCleaner[:mongoid].strategy = :truncation
    DatabaseCleaner[:mongoid].start
  end

  config.after :each do
    DatabaseCleaner[:mongoid].clean
  end
end
