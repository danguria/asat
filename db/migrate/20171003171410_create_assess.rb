class CreateAssess < ActiveRecord::Migration
  def change
    create_table :assesses do |t|
      t.string  :judge,      null: false, primary_key: true
      t.string  :contestant, null: false, primary_key: true
      t.string  :contest,    null: false, primary_key: true
      t.integer :year,       null: false, primary_key: true
      t.string  :division,   null: false, primary_key: true
      t.integer :round,      null: false, primary_key: true
      t.string  :question,   null: false, primary_key: true
      t.string  :score,      null: true
      
    end
  end
end
