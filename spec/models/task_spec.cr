require "../spec_helper"

# Task model spec
describe Task, focus: true do
  it "should create a task (from JSON), save and delete it" do
    task = Task.new(JSON.parse(%({"title":"Wash the dishes"})))

    begin
      task.save!
    rescue e
      puts task.errors
      raise e
    end

    results = Task.query.where(title: task.title).to_a

    results[0].title.should eq("Wash the dishes")

    task.delete
  end
end
