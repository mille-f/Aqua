class CreateAlkalis < ActiveRecord::Migration
  def change
    create_table :alkalis do |t|
      t.string :ent
      t.string :att
      t.string :val

      t.timestamps null: false
    end
  end
end
