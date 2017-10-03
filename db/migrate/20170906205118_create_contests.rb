class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string :contest_name, null: false
      t.integer :year
    end
  end
end
