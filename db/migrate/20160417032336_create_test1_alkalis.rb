class CreateTest1Alkalis < ActiveRecord::Migration
  def change
    create_table :test1_alkalis do |t|

      t.timestamps null: false
    end
  end
end
