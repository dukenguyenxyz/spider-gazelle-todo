require "spec"

# Your application config
# If you have a testing environment, replace this with a test config file
require "../src/config"

# Helper methods for testing controllers (curl, with_server, context)
require "../lib/action-controller/spec/curl_context"

require "../src/constants.cr"
require "../src/db/migration.cr"

# Helpers
require "../src/models/task.cr"

def context_generator(verb : String, action : String, path : String, resource_id : String? | Int32? = nil, body : String? = nil)
  response = IO::Memory.new
  context = context(verb, path, body: body, response_io: response)

  context.route_params = {"id" => resource_id.to_s} if !resource_id.nil?

  app = TasksController.new(context)

  case action
  when "index"   then app.index
  when "show"    then app.show
  when "destroy" then app.destroy
  when "create"  then app.create
  when "update"  then app.update
  end

  data = response.to_s
  JSON.parse(data.split("\r\n").reject(&.empty?)[-1])
end
