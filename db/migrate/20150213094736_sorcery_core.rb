class SorceryCore < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,           null: false, primary_key: true
      t.string :name,            null: false
      t.string :role,            null: false
      t.string :bare_password,   null: false
      t.string :crypted_password
      t.string :salt

      t.timestamps
    end

    #add_index :email, unique: true
  end
end