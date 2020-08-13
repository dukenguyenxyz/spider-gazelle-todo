require "../spec_helper"

# Task model spec
describe Task, focus: true do
  it "should create a task (from JSON), save and delete it" do
    task = Task.new(JSON.parse(%({"title":"Wash the dishes","note":"Clean the cups without detergent"})))

    begin
      task.save!
    rescue e
      puts task.errors
      raise e
    end

    results = Task.query.where(title: task.title).to_a

    results[0].title.should eq("Wash the dishes")
    results[0].note.to_json.should eq(%("Clean the cups without detergent"))

    task.delete
  end
end
