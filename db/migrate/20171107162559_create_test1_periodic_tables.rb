class CreateTest1PeriodicTables < ActiveRecord::Migration
  def change
    create_table :test1_periodic_tables do |t|

      t.timestamps null: false
    end
  end
end
