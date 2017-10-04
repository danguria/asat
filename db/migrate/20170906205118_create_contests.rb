class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.string  :name, null: false, primary_key: true
      t.integer :year, null: false, primary_key: true
    end
  end
end
