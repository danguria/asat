class CreateParticipate < ActiveRecord::Migration
  def change
    create_table :participates do |t|
      
      t.string  :user,     null: false, primary_key: true
      t.string  :contest,  null: false, primary_key: true
      t.integer :year,     null: false, primary_key: true
      t.string  :division, null: false, primary_key: true
      t.integer :round,    null: false, primary_key: true
    end
  end
end
