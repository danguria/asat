class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      
      t.string     :contest,  null: false, primary_key: true
      t.integer    :year,     null: false, primary_key: true
      
      t.string     :division, null: false, primary_key: true
      t.integer    :round,    null: false, primary_key: true
      t.string     :done,     null: false
    end
    
  end
end
