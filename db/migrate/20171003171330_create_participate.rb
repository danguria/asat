class CreateParticipate < ActiveRecord::Migration
  def change
    create_table :participates do |t|
      
      t.string  :user,     null: false, unique: true
      t.string  :contest,  null: false, unique: true
      t.integer :year,     null: false, unique: true
      t.string  :division, null: false, unique: true
      t.integer :round,    null: false, unique: true
    end
  end
end
