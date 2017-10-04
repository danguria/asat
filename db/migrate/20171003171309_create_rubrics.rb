class CreateRubrics < ActiveRecord::Migration
  def change
    create_table :rubrics do |t|
      
      t.string     :question,     null: false, primary_key: true
      t.string     :qType,        null: false
    end
  end
end
