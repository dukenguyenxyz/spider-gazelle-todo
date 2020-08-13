require "../spec_helper"

describe TasksController, focus: true do
  # Create testing data and clearing testing data

  task1 = Task.new
  task2 = Task.new

  Spec.before_each do
    Task.query.each { |task_unit| task_unit.delete }

    task1.title = "Commute to work"
    task1.note = "Buy gimbap from Korean shop on the way"
    task1.save!

    task2.title = "Finish spider-gazelle to do app"
    task2.note = "Write specs before anything"
    task2.save!
  end

  Spec.after_each do
    task1.delete
    task2.delete
  end

  it "should return a list of tasks" do
    # response = IO::Memory.new
    # app = TasksController.new(context("GET", "/tasks", response_io: response))
    # app.index
    context_generator("GET", "index", "/tasks").as_a.size.should eq(2)

    # get_data(response).as_a.size.should eq(2)
  end

  it "should find the task" do
    # response = IO::Memory.new
    # context = context("GET", "/tasks/#{task1.id}", response_io: response)
    # context.route_params = {"id" => task1.id.not_nil!.to_s}
    # app = TasksController.new(context)
    # app.show

    context_generator("GET", "show", "/tasks/#{task1.id}", task1.id).as_h["task"]["id"].should eq(task1.id)

    # get_data(response).as_h["task"]["id"].should eq(task1.id)
  end

  it "should find destroy a task" do
    # response = IO::Memory.new
    # context = context("DELETE", "/tasks/#{task1.id}", response_io: response)
    # context.route_params = {"id" => task1.id.not_nil!.to_s} # What does this mean?
    # app = TasksController.new(context)
    # app.destroy

    context_generator("DELETE", "destroy", "/tasks/#{task1.id}", task1.id).as_h["message"].should eq("OK")

    # get_data(response).as_h["message"].should eq("OK")

    # response = IO::Memory.new
    # app = TasksController.new(context("GET", "/tasks", response_io: response))
    # app.index

    context_generator("GET", "index", "/tasks").as_a.size.should eq(1)

    # get_data(response).as_a.size.should eq(1)
  end

  it "should create and update a task" do
    # response = IO::Memory.new

    # # instantiate the controller
    # # body = IO::Memory.new
    # # body << %({"title":"Finish Dostoyevsky's crime and punishment","note":"Read excerpts of notes from underground"})
    # # body.rewind
    body = %({"title":"Finish Dostoyevsky's crime and punishment","note":"Read excerpts of notes from underground"})

    # context = context("POST", "/tasks", body: body, response_io: response)
    # app = TasksController.new(context)
    # app.create

    created = context_generator("POST", "create", "/tasks", body: body)["task"]

    # created = get_data(response)["task"]
    created["title"].should eq("Finish Dostoyevsky's crime and punishment")
    created["note"].should eq("Read excerpts of notes from underground")

    # response = IO::Memory.new

    # # instantiate the controller
    # # body = IO::Memory.new
    # # body << %({"note":"read Nietzsche's zarathustra"})
    # # body.rewind
    body = %({"note":"read Nietzsche's zarathustra"})

    # context = context("PATCH", "/tasks/#{created["id"]}", body: body, response_io: response)
    # context.route_params = {"id" => created["id"].to_s}
    # app = TasksController.new(context)
    # app.update

    updated = context_generator("PATCH", "update", "/tasks/#{created["id"]}", resource_id: created["id"].to_s, body: body)["task"]

    # updated = get_data(response)["task"]
    updated["note"].should eq("read Nietzsche's zarathustra")
  end
end
