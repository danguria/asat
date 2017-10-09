class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      
      t.string     :question,     null: false, unique: true
      t.string     :qType,        null: false
    end
  end
end
