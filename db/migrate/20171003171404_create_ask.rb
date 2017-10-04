class CreateAsk < ActiveRecord::Migration
  def change
    create_table :asks do |t|
      t.string  :contest,  null: false, primary_key: true
      t.integer :year,     null: false, primary_key: true
      t.string  :division, null: false, primary_key: true
      t.integer :round,    null: false, primary_key: true 
      t.string  :question, null: false, primary_key: true
      
    end
  end
end
