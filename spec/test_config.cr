require "clear"
require "action-controller"
require "action-controller/server"
require "kilt"

# Application code # Set up testing environment
require "../src/controllers/application.cr"
require "../src/controllers/*"
require "../src/models/*"
require "../src/db/migrate/*"

Clear::SQL.init("postgresql://macbook:passgres@localhost:5432/crystal_to_do_test",
  connection_pool_size: 5)

Clear::Migration::Manager.instance.apply_all

# Clear.logger.level = ::Logger::DEBUG
