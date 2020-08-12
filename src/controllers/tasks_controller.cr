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

  # def create
  #   task = Task.new

  #   # From params
  #   task.title = params["title"]
  #   task.note = params["note"]

  #   # From JSON

  #   task.save

  #   if task.save
  #     render json: task
  #   else
  #     render json: {error: "An error has occurred"}
  #   end
  # end

  # def update
  #   task = Task.query.where(id: params["id"])

  #   # From params
  #   task.each { |task_unit| task_unit.update(title: params["title"], note: params[
  #     "note",
  #   ]) }

  #   # From JSON

  #   task.save

  #   if task.save
  #     render json: task
  #     # redirect_to TasksController.show(task.id)
  #   else
  #     render json: {error: "An error has occurred"}
  #   end
  # end

  def delete
    # task = set_task
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
