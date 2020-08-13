require "spec"

# Your application config
# If you have a testing environment, replace this with a test config file
require "./test_config.cr"

# Helper methods for testing controllers (curl, with_server, context)
require "../lib/action-controller/spec/curl_context"

require "../src/constants.cr"

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

  response.to_s.split("\r\n").reject(&.empty?)
end

def status_code(response)
  response[0].split(" ")[1].to_i
end

def data(response)
  JSON.parse(response[-1])
end
