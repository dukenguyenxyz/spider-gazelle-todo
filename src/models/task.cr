class Task
  include Clear::Model

  column id : Int32, primary: true, presence: false
  column title : String
  column completed : Bool?
  column order : Int32?
  column url : String?
end
