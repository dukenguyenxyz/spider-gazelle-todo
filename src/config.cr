# Application dependencies
require "action-controller"
require "clear"
require "./constants"
require "simple_retry"

# Application code
require "./controllers/application"
require "./controllers/*"
require "./models/*"
require "./db/migrate/*"

# Server required after application controllers
require "action-controller/server"

SimpleRetry.try_to(max_attempts: 10, retry_on: DB::ConnectionRefused) do
  # Connect to PG
  Clear::SQL.init(App::POSTGRES_URI_DEV,
    connection_pool_size: 5)
end

# Run migration
Clear::Migration::Manager.instance.apply_all

# SQL Logger
# Clear.logger.level = ::Logger::DEBUG

# Configure logging (backend defined in constants.cr)
if App.running_in_production?
  log_level = Log::Severity::Info
  ::Log.setup "*", :warning, App::LOG_BACKEND
else
  log_level = Log::Severity::Debug
  ::Log.setup "*", :info, App::LOG_BACKEND
end
Log.builder.bind "action-controller.*", log_level, App::LOG_BACKEND
Log.builder.bind "#{App::NAME}.*", log_level, App::LOG_BACKEND

# Filter out sensitive params that shouldn't be logged
filter_params = ["password", "bearer_token"]
keeps_headers = ["X-Request-ID"]

# Add handlers that should run before your application
ActionController::Server.before(
  ActionController::ErrorHandler.new(App.running_in_production?, keeps_headers),
  ActionController::LogHandler.new(filter_params),
  HTTP::CompressHandler.new
)

# Optional support for serving of static assests
if File.directory?(App::STATIC_FILE_PATH)
  # Optionally add additional mime types
  ::MIME.register(".yaml", "text/yaml")

  # Check for files if no paths matched in your application
  ActionController::Server.before(
    ::HTTP::StaticFileHandler.new(App::STATIC_FILE_PATH, directory_listing: false)
  )
end

# Configure session cookies
# NOTE:: Change these from defaults
ActionController::Session.configure do |settings|
  settings.key = App::COOKIE_SESSION_KEY
  settings.secret = App::COOKIE_SESSION_SECRET
  # HTTPS only:
  settings.secure = App.running_in_production?
end
