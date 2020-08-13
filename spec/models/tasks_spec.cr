require "../spec_helper"

describe Task do
  pending "should save and delete bookings" do
    task = Task.new
    task.title = "Do the laundry"
    task.note = "Separate clothes by material and colour"

    begin
      task.save!
    rescue e
      puts task.errors
      raise e
    end

    results = [] of Task

    # Let's find this task
    query = Task.query.where(title: task.title)
    query.each { |task_unit| results << task_unit }

    (results[0].title == task.title).should eq(true)

    task.delete
  end

  # it "should instantiate a task using JSON" do
  #   task = Task.from_json(%({"title":"Wash the dishes","note":"Clean the cups without detergent"}))
  #   task.title.should eq("Wash the dishes")
  #   task.note.to_json.should eq(%("Clean the cups without detergent"))
  # end
end
