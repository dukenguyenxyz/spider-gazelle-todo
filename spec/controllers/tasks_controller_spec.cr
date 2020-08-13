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
    context_generator("GET", "index", "/tasks").as_a.size.should eq(2)
  end

  it "should find the task" do
    context_generator("GET", "show", "/tasks/#{task1.id}", task1.id).as_h["task"]["id"].should eq(task1.id)
  end

  it "should find destroy a task" do
    context_generator("DELETE", "destroy", "/tasks/#{task1.id}", task1.id).as_h["message"].should eq("OK")
    context_generator("GET", "index", "/tasks").as_a.size.should eq(1)
  end

  it "should create and update a task" do
    body1 = {title: "Finish Dostoyevsky's crime and punishment", note: "Read excerpts of notes from underground"}
    created = context_generator("POST", "create", "/tasks", body: body1.to_json)["task"]
    created["title"].should eq(body1["title"])
    created["note"].should eq(body1["note"])

    body2 = {note: "read Nietzsche's zarathustra"}
    updated = context_generator("PATCH", "update", "/tasks/#{created["id"]}", resource_id: created["id"].to_s, body: body2.to_json)["task"]
    updated["note"].should eq(body2["note"])
  end
end
