class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string  :name, null: false, unique: true
      t.integer :year, null: false
    end
  end
end
