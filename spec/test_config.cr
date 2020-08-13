# Dependent libs
require "clear"
require "action-controller"
require "action-controller/server"

# Set up testing env
require "../src/db/migrate/*"

# Connect to PG
Clear::SQL.init("postgresql://macbook:passgres@localhost:5432/crystal_to_do_test",
  connection_pool_size: 5)

# Run the Migration
Clear::Migration::Manager.instance.apply_all

# SQL Logger (not working)
# Clear.logger.level = ::Logger::DEBUG
