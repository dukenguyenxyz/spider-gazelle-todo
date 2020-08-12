class Task
  include Clear::Model

  column id : Int32, primary: true, presence: false

  column title : String, column_name: "title"
  column note : String?, column_name: "note"

  self.table = "tasks"
end
