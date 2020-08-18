require "action-controller"
require "json"
require "../models/task.cr"

class TasksController < Application
  base "/todos"

  # before_action :set_task, except: [:index, :create]

  getter task : Task?

  def index
    tasks = Task.query.select.to_a

    render text: tasks.to_json

    # Unable to conditionally return 404 if array is empty due to todobackend specification
  end

  def show
    task = set_task
    if !task.nil?
      render text: task.to_json
    end
  end

  def create
    task = Task.new(JSON.parse(request.body.as(IO)))
    task.save

    # Production using headers key, testing using host key
    task.url = "http://#{request.headers.has_key?("host") ? request.headers["host"] : request.host}/todos/#{task.id}"
    task.save

    if task.save
      render :created, text: task.to_json
    else
      render :internal_server_error, text: ({} of String => String).to_json
    end
  end

  def update
    task = set_task
    if !task.nil?
      update_params = JSON.parse(request.body.as(IO)).as_h

      update_params.each do |key, value|
        task.title = value.to_s if key == "title"
        task.completed = value.as_bool if key == "completed"
        task.order = value.as_i if key == "order"
      end

      task.save
      if task.save
        render text: task.to_json
      else
        render :internal_server_error, text: ({} of String => String).to_json
      end
    end
  end

  def destroy
    task = set_task
    if !task.nil?
      task.delete

      render text: task.to_json
      redirect_to TasksController.index
    end
  end

  delete "/", :destroy_all do
    Task.query.select.each { |task| task.delete }

    render text: ({} of String => String).to_json
    redirect_to TasksController.index
  end

  options "/", :option_task do
    response.headers["Access-Control-Allow-Methods"] = "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH"
  end

  options "/:id", :option_task_id do
    response.headers["Access-Control-Allow-Methods"] = "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH"
  end

  private def set_task
    task = Task.query.find({id: params["id"]})

    if task.nil?
      render :not_found, text: ({} of String => String).to_json # Raise 404 if nil
      redirect_to TasksController.index
    end

    task
  end
end
