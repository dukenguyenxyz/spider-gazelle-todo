require "../models/task.cr"

class TasksController < Application
  base "/tasks"

  getter task : Task?

  def index
    results = [] of Task

    Task.query.select.each { |task| results << task }

    render json: results
  end

  # def show
  #   result = Task.query.find({id: params["id"]})

  #   render json: {result: result}
  # end

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

  # def destroy
  #   task = Task.query.where(id: params["id"])
  #   task.each { |task_unit| task_unit.delete }

  #   redirect_to TasksController.index
  # end
end
