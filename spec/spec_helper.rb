# -*- encoding : utf-8 -*-
require 'coveralls'
Coveralls.wear!

require 'mysql2'
require 'active_record'
require 'active_support/all'
require 'mindpin-feeds'

require 'config/db_init'
require 'generators/templates/migration'

require 'migrations'
require 'models'

require 'database_cleaner'
RSpec.configure do |config|
  config.order = "random"

  # database_cleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:all) do
    MigrationHelper.up
  end

  config.after(:all) do
    MigrationHelper.down
  end
end
