class Task
  include Clear::Model

  column id : Int32, primary: true, presence: false

  column title : String, column_name: "title"
  column completed : Bool?, column_name: "completed"
  column order : Int32?, column_name: "order"
  column url : String?, column_name: "url"

  self.table = "tasks"
end
