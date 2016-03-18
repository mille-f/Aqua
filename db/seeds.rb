require "csv"

CSV.foreach('db/alkali.csv') do |row|
  Alkali.create(:ent => row[0], :att => row[1], :val => row[2])
end
