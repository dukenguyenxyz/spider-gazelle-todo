require "spec"                                       # Spec Lib
require "./test_config.cr"                           # Testing config environment
require "../lib/action-controller/spec/curl_context" # Helper methods for testing controllers (curl, with_server, context)
require "../src/models/*"                            # Models
require "../src/controllers/*"                       # Controllers

# # Helpers

# Generate new context from params and return response
def context_generator(verb : String, action : String, path : String, resource_id : String? | Int32? = nil, body : String? = nil)
  # Prepare context params
  response = IO::Memory.new
  context = context(verb, path, body: body, response_io: response)
  context.route_params = {"id" => resource_id.to_s} if !resource_id.nil?

  # Instantiate new context
  app = TasksController.new(context)

  # Perform controller action
  case action
  when "index"   then app.index
  when "show"    then app.show
  when "destroy" then app.destroy
  when "create"  then app.create
  when "update"  then app.update
  end

  # Remove line breaks from JSON and nil values from response after split
  response.to_s.split("\r\n").reject(&.empty?)
end

# Return status code Int32 from response
def status_code(response)
  response[0].split(" ")[1].to_i
end

# Return response body from response
def data(response)
  JSON.parse(response[-1])
end
