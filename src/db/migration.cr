require "../constants.cr"
require "./migrate/*"
require "clear"

Clear::SQL.init("postgresql://macbook:passgres@localhost:5432/crystal_to_do",
  connection_pool_size: 5)

Clear::Migration::Manager.instance.apply_all

# Clear.logger.level = ::Logger::DEBUG
