require "../spec_helper"

describe TasksController do
  task1 = Task.new
  task2 = Task.new
  Spec.before_each do
    Task.query.each { |task_unit| task_unit.delete }

    task1 = Task.new
    task1.title = "Commute to work"
    task1.note = "Buy gimbap from Korean shop on the way"
    task1.save!

    task2 = Task.new
    task2.title = "Finish spider-gazelle to do app"
    task2.note = "Write specs before anything"
    task2.save!
  end

  Spec.after_each do
    task1.delete
    task2.delete
  end

  pending "should return a list of tasks" do
    response = IO::Memory.new
    app = TasksController.new(context("GET", "/tasks", response_io: response))

    app.index
    data = response.to_s
    data = JSON.parse(data.split("\r\n").reject(&.empty?)[-1])
    data.as_a.size.should eq(2)
  end

  pending "should find the task" do
    response = IO::Memory.new
    context = context("GET", "/tasks/#{task1.id}", response_io: response)
    context.route_params = {"id" => task1.id.not_nil!.to_s}
    app = TasksController.new(context)

    app.show
    data = response.to_s
    data = JSON.parse(data.split("\r\n").reject(&.empty?)[-1])
    data.as_h["task"]["id"].should eq(task1.id)
  end

  pending "should find delete a task" do
    response = IO::Memory.new
    context = context("DELETE", "/tasks/#{task1.id}", response_io: response)
    context.route_params = {"id" => task1.id.not_nil!.to_s} # What does this mean?
    app = TasksController.new(context)

    app.delete
    data = response.to_s
    data = JSON.parse(data.split("\r\n").reject(&.empty?)[-1])
    data.as_h["message"].should eq("OK")

    response = IO::Memory.new
    app = TasksController.new(context("GET", "/tasks", response_io: response))

    app.index
    data = response.to_s
    data = JSON.parse(data.split("\r\n").reject(&.empty?)[-1])
    data.as_a.size.should eq(1)
  end

  it "should create and update a task", focus: true do
    # instantiate the controller
    body = IO::Memory.new
    body << %({"title":"Finish Dostoyevsky's crime and punishment","note":"Read excerpts of notes from underground"})
    body.rewind
    # body = %({"title":"Finish Dostoyevsky's crime and punishment","note":"Read excerpts of notes from underground"})

    response = IO::Memory.new
    context = context("POST", "/tasks", body: body, response_io: response)
    app = TasksController.new(context)
    app.create

    data = response.to_s.split("\r\n").reject(&.empty?)[-1]
    created = JSON.parse(data)
    created = created["task"]
    puts data
    created["title"].should eq("Finish Dostoyevsky's crime and punishment")
    created["note"].should eq("Read excerpts of notes from underground")

    # # instantiate the controller
    # body = IO::Memory.new
    # body << %({"note":"read Nietzsche's zarathustra"})
    # body.rewind
    # response = IO::Memory.new
    # context = context("PATCH", "/tasks/#{created["id"]}", body: body, response_io: response)
    # context.route_params = {"id" => created["id"].to_s}
    # app = TasksController.new(context)
    # app.update

    # updated = JSON.parse(response.to_s.split("\r\n").reject(&.empty?)[-1])
    # updated = updated["task"]

    # puts updated

    # # updated["note"].should eq("read Nietzsche's zarathustra")
  end
end
