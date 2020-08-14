# Dependent libs
require "clear"
require "simple_retry"

require "action-controller"
require "action-controller/server"

# Set up testing env
require "../src/db/migrate/*"
require "../src/constants.cr"

SimpleRetry.try_to(max_attempts: 10, retry_on: DB::ConnectionRefused) do
  # Connect to PG
  Clear::SQL.init(App::POSTGRES_URI_TEST,
    connection_pool_size: 5)
end

# Run the Migration
Clear::Migration::Manager.instance.apply_all

# SQL Logger (not working)
# Clear.logger.level = ::Logger::DEBUG
