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
    task1.save!

    task2.title = "Finish spider-gazelle to do app"
    task2.save!
  end

  # Clear testing data
  Spec.after_each do
    task1.delete
    task2.delete
  end

  # Test cases
  with_server do
    it "should return a list of tasks" do
      # response = context_generator("GET", "index", "/todos")
      # status_code(response).should eq(200) # Status 200
      # data(response).as_a.size.should eq(2)

      response = curl("GET", "/todos")
      response.status_code.should eq(200)
      JSON.parse(response.body).as_a.size.should eq(2)
    end

    it "should find the task through id" do
      # response = context_generator("GET", "show", "/todos/#{task1.id}", task1.id)
      # status_code(response).should eq(200) # Status 200
      # data(response).as_h["id"].should eq(task1.id)

      response = curl("GET", "/todos/#{task1.id}")
      response.status_code.should eq(200)
      JSON.parse(response.body).as_h["id"].should eq(task1.id)
    end

    it "should find destroy a task" do
      # response1 = context_generator("DELETE", "destroy", "/todos/#{task1.id}", task1.id)
      # status_code(response1).should eq(200) # Status 200
      # data(response1).as_h["id"].should eq(task1.id)

      # response2 = context_generator("GET", "index", "/todos")
      # data(response2).as_a.size.should eq(1)

      response1 = curl("DELETE", "/todos/#{task1.id}")
      response1.status_code.should eq(200)
      JSON.parse(response1.body).as_h["id"].should eq(task1.id)

      response2 = curl("GET", "/todos")
      response2.status_code.should eq(200)
      JSON.parse(response2.body).as_a.size.should eq(1)
    end

    it "should destroy all tasks" do
      # response1 = context_generator("DELETE", "destroy_all", "/todos")
      # status_code(response1).should eq(200) # Status 200

      # response2 = context_generator("GET", "index", "/todos")
      # data(response2).as_a.size.should eq(0)

      response1 = curl("DELETE", "/todos")
      response1.status_code.should eq(200)

      response2 = curl("GET", "/todos")
      JSON.parse(response2.body).as_a.size.should eq(0)
    end

    it "should create and update a task" do
      body1 = {title: "Finish Dostoyevsky's crime and punishment", completed: true}
      # response1 = context_generator("POST", "create", "/todos", body: body1.to_json)
      # status_code(response1).should eq(201) # Status: 201
      # created = data(response1)

      response1 = curl("POST", "/todos", body: body1.to_json)
      response1.status_code.should eq(201)
      created = JSON.parse(response1.body).as_h

      created["title"].should eq(body1["title"])
      created["completed"].should eq(body1["completed"])

      body2 = {completed: false}
      # response2 = context_generator("PATCH", "update", "/todos/#{created["id"]}", resource_id: created["id"].to_s, body: body2.to_json)
      # status_code(response2).should eq(200) # Status 200
      # updated = data(response2)

      response2 = curl("PATCH", "/todos/#{created["id"]}", body: body2.to_json)
      response2.status_code.should eq(200)
      updated = JSON.parse(response2.body).as_h

      updated["completed"].should eq(body2["completed"])
    end

    it "should not find the task" do
      # response1 = context_generator("GET", "show", "/todos/1233", 1233)
      # status_code(response1).should eq(404) # Status 404

      # response2 = context_generator("DELETE", "destroy", "/todos/1233", 1233)
      # status_code(response2).should eq(404) # Status 404

      body2 = {note: "read Nietzsche's zarathustra"}
      # response3 = context_generator("PATCH", "update", "/todos/1233", resource_id: "1233", body: body2.to_json)
      # status_code(response3).should eq(404) # Status 404

      response1 = curl("GET", "/todos/1233")
      response1.status_code.should eq(404)

      response2 = curl("DELETE", "/todos/1233")
      response2.status_code.should eq(404)

      response3 = curl("PATCH", "/todos/1233", body: body2.to_json)
      response3.status_code.should eq(404)
    end
  end
end
