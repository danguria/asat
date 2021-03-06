class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      
      t.string     :contest,  null: false, unique: true
      t.integer    :year,     null: false, unique: true
      
      t.string     :division, null: false, unique: true
      t.integer    :round,    null: false, unique: true
      t.string     :done,     null: false
    end
    
  end
end
