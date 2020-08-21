require "action-controller"
require "json"
require "../models/task.cr"

class TasksController < Application
  base "/todos"

  # before_action :set_task, except: [:index, :create]

  # getter task : Task? { set_task }

  def index
    tasks = Task.query.select.to_a
    render text: tasks.to_json # Unable to conditionally return 404 if array is empty due to todobackend specification
  end

  def show
    task : Task? = set_task
    render text: task.to_json if !task.nil?
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
  rescue exception # Bug here
    # puts exception
    # if typeof(exception) == Clear::Model::Error
    head :bad_request
    # else
    #   head :internal_server_error
    # end
  end

  def update
    task : Task? = set_task
    if !task.nil?
      update_params = JSON.parse(request.body.as(IO)).as_h

      update_params.each do |key, value|
        task.title = value.to_s if key == "title"
        task.completed = value.as_bool if key == "completed"
        task.order = value.as_i if key == "order"
      end

      begin
        task.save
        render text: task.to_json
      rescue exception
        head :internal_server_error
      end
    end
  end

  def destroy
    task : Task? = set_task
    if !task.nil?
      task.delete

      render text: task.to_json
    end
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
    Task.query.find!({id: params["id"]})
  rescue
    head :not_found
  end
end
