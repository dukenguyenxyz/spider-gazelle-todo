require "clear"

class CreateTable
  include Clear::Migration

  def change(direction)
    direction.up do
      # execute("CREATE TABLE my_models...")
      create_table(:tasks) do |t|
        t.column :title, :string, index: true
        t.column :note, :string
      end
    end

    direction.down do
      execute("DROP TABLE tasks")
    end
  end
end
