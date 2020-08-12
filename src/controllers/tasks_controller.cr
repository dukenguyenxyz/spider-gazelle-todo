require "json"
require "../models/task.cr"

class TasksController < Application
  base "/tasks"

  getter task : Task?

  def index
    tasks = [] of Task
    Task.query.select.each { |task| tasks << task }

    render json: tasks
  end

  def show
    # task = set_task
    task = Task.query.find({id: params["id"]})

    render(status: 404, json: {error: "Not Found"}) if task.nil?

    render json: {task: task}
  end

  def create
    task = Task.new(JSON.parse(request.body.as(IO)))

    task.save

    if task.save
      render json: {task: task}
    else
      render json: {error: "An error has occurred"}
    end
  end

  def update
    # task = set_task  # In the future switch entirely to set_task
    task = Task.query.find({id: params["id"]})
    update_params = JSON.parse(request.body.as(IO)).as_h # task.save

    if !task.nil?
      update_params.each do |key, value|
        task.title = value.to_s if key == "title"
        task.note = value.to_s if key == "note"
      end

      task.save
      if task.save
        render json: {task: update_params}
        # redirect_to TasksController.show(task.id)
      end
    else
      render json: {error: "An error has occurred"}
    end
  end

  def delete
    # task = set_task  # In the future switch entirely to set_task
    task = Task.query.find({id: params["id"]})

    task.delete if !task.nil?

    render status: 200, json: {message: "OK"}

    redirect_to TasksController.index
  end

  # def set_task
  #   @task = Task.query.find({id: params["id"]})

  #   # Raise 404 if nil
  #   if @task.nil?
  #     render(status: 404, json: {error: "Not Found"})
  #   end
  # end
end
