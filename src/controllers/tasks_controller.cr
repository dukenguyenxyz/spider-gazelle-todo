require "action-controller"
require "json"
require "../models/task.cr"

class TasksController < Application
  base "/todos"

  getter task : Task { set_task }

  def index
    tasks = Task.query.select.to_a
    render text: tasks.to_json # Unable to conditionally return 404 if array is empty due to todobackend specification
  end

  def show
    render text: task.to_json
  end

  def create
    task = Task.new(JSON.parse(request.body.as(IO)))
    task.save!

    Clear::SQL.with_savepoint do
      # Production using headers key, testing using host key
      task.url = "http://#{request.headers.has_key?("host") ? request.headers["host"] : request.host}/todos/#{task.id}"
      task.save!
      Clear::SQL.rollback if !task.valid?
      Clear::SQL.with_savepoint do
        render :created, text: task.to_json
      end
    end
  end

  def update
    task # need to query for task and check for error before anything else, do not remove this line

    update_params = JSON.parse(request.body.as(IO)).as_h

    update_params.each do |key, value|
      task.title = value.to_s if key == "title"
      task.completed = value.as_bool if key == "completed"
      task.order = value.as_i if key == "order"
    end

    begin
      task.save
      render text: task.to_json
    rescue
      head :internal_server_error
    end
  end

  def destroy
    task.delete
    render text: task.to_json
  end

  delete "/", :destroy_all do
    Task.query.select.each { |task| task.delete }
    head :ok
  end

  options "/" do
    response.headers["Access-Control-Allow-Methods"] = "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH"
  end

  options "/:id" do
    response.headers["Access-Control-Allow-Methods"] = "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH"
  end

  private def set_task
    Task.find!(params["id"])
  end
end
