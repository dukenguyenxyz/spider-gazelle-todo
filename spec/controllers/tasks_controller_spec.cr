require "../spec_helper"

describe TasksController, focus: true do
  # Create testing data and clearing testing data
  task1 = Task.new
  task2 = Task.new

  # Generate testing data
  Spec.before_each do
    # Clear the table
    Task.query.each { |task_unit| task_unit.delete }

    task1.title = "Commute to work"
    task1.note = "Buy gimbap from Korean shop on the way"
    task1.save!

    task2.title = "Finish spider-gazelle to do app"
    task2.note = "Write specs before anything"
    task2.save!
  end

  # Clear testing data
  Spec.after_each do
    task1.delete
    task2.delete
  end

  # Test cases
  it "should return a list of tasks" do
    response = context_generator("GET", "index", "/")

    status_code(response).should eq(200) # Status 200
    data(response).as_a.size.should eq(2)
  end

  it "should find the task" do
    response = context_generator("GET", "show", "/todos/#{task1.id}", task1.id)

    status_code(response).should eq(200) # Status 200
    data(response).as_h["task"]["id"].should eq(task1.id)
  end

  it "should find destroy a task" do
    response1 = context_generator("DELETE", "destroy", "/todos/#{task1.id}", task1.id)

    status_code(response1).should eq(200) # Status 200
    data(response1).as_h["task"]["id"].should eq(task1.id)

    response2 = context_generator("GET", "index", "/")
    data(response2).as_a.size.should eq(1)
  end

  it "should destroy all tasks" do
    response1 = context_generator("DELETE", "destroy_all", "/todos")

    status_code(response1).should eq(200) # Status 200
    data(response1).as_h["message"].should eq("All items have been deleted")

    response2 = context_generator("GET", "index", "/")
    data(response2).as_a.size.should eq(0)
  end

  it "should create and update a task" do
    body1 = {title: "Finish Dostoyevsky's crime and punishment", note: "Read excerpts of notes from underground"}
    response1 = context_generator("POST", "create", "/", body: body1.to_json)
    status_code(response1).should eq(201) # Status: 201
    created = data(response1)["task"]
    created["title"].should eq(body1["title"])
    created["note"].should eq(body1["note"])

    body2 = {note: "read Nietzsche's zarathustra"}
    response2 = context_generator("PATCH", "update", "/todos/#{created["id"]}", resource_id: created["id"].to_s, body: body2.to_json)
    status_code(response2).should eq(200) # Status 200
    updated = data(response2)["task"]
    updated["note"].should eq(body2["note"])
  end

  it "should not find the task" do
    response1 = context_generator("GET", "show", "/todos/1233", 1233)
    status_code(response1).should eq(404) # Status 404
    data(response1).as_h["message"].should eq("Not Found")

    response2 = context_generator("DELETE", "destroy", "/todos/1233", 1233)
    status_code(response2).should eq(404) # Status 404
    data(response2).as_h["message"].should eq("Not Found")

    body2 = {note: "read Nietzsche's zarathustra"}
    response3 = context_generator("PATCH", "update", "/todos/1233", resource_id: "1233", body: body2.to_json)
    status_code(response3).should eq(404) # Status 404
    data(response3)["message"].should eq("Not Found")
  end
end
