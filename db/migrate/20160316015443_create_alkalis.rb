class CreateAlkalis < ActiveRecord::Migration
  def change
    create_table :alkalis do |t|

      t.timestamps null: false
    end
  end
end
