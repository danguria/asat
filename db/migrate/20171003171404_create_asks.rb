class CreateAsks < ActiveRecord::Migration
  def change
    create_table :asks do |t|
      t.string  :contest,  null: false, unique: true
      t.integer :year,     null: false, unique: true
      t.string  :division, null: false, unique: true
      t.integer :round,    null: false, unique: true 
      t.string  :question, null: false, unique: true
      
    end
  end
end
