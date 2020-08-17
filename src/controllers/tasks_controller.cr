require "action-controller"
require "json"
require "../models/task.cr"

class TasksController < Application
  base "/todos"

  # before_action :set_task, except: [:index, :create]

  getter task : Task?

  def index
    tasks = Task.query.select.to_a

    render json: tasks
  end

  def show
    task = set_task
    if !task.nil?
      render json: {task: task}
    end
  end

  def create
    task = Task.new(JSON.parse(request.body.as(IO)))

    task.save
    if task.save
      render :created, json: {task: task}
    else
      render :internal_server_error, json: {error: "An error has occurred"}
    end
  end

  def update
    task = set_task
    if !task.nil?
      update_params = JSON.parse(request.body.as(IO)).as_h

      update_params.each do |key, value|
        task.title = value.to_s if key == "title"
        task.note = value.to_s if key == "note"
      end

      task.save
      if task.save
        render json: {task: task}
      else
        render :internal_server_error, json: {error: "An error has occurred"}
      end
    end
  end

  def destroy
    task = set_task
    if !task.nil?
      task.delete

      render json: {task: task}
      redirect_to TasksController.index
    end
  end

  delete "/", :destroy_all do
    Task.query.select.each { |task| task.delete }

    render json: {message: "All items have been deleted"}
    redirect_to TasksController.index
  end

  private def set_task
    task = Task.query.find({id: params["id"]})

    if task.nil?
      render :not_found, json: {message: "Not Found"} # Raise 404 if nil
      redirect_to TasksController.index
    end

    task
  end
end
