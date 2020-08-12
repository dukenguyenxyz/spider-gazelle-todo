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

  # def update
  #   # task = set_task  # In the future switch entirely to set_task
  #   task = Task.query.find({id: params["id"]})
  #   update_params = JSON.parse(request.body.as(IO)) # task.save

  #   if !task.nil?
  #     task.update(title: update_params["title"].to_s) if !update_params["title"].nil?
  #     task.update(note: update_params["note"].to_s) if !update_params["note"].nil?

  #     if task.save
  #       render json: {task: task}
  #       # redirect_to TasksController.show(task.id)
  #     end
  #   else
  #     render json: {error: "An error has occurred"}
  #   end
  # end

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
