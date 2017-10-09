class CreateAssess < ActiveRecord::Migration
  def change
    create_table :assesses do |t|
      t.string  :judge,      null: false, unique: true
      t.string  :contestant, null: false, unique: true
      t.string  :contest,    null: false, unique: true
      t.integer :year,       null: false, unique: true
      t.string  :division,   null: false, unique: true
      t.integer :round,      null: false, unique: true
      t.string  :question,   null: false, unique: true
      t.string  :score,      null: true
      
    end
  end
end
