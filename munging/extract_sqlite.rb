#!/usr/bin/env ruby
# encoding: UTF-8

# Schema:
# CREATE TABLE `people` (`username` VARCHAR , `id` INTEGER PRIMARY KEY AUTOINCREMENT , `pin` INTEGER );
# CREATE TABLE `attempts` (`person_id` BIGINT , `id` INTEGER PRIMARY KEY AUTOINCREMENT , `mode` INTEGER );
# CREATE TABLE `taps` (`attempt_id` BIGINT , `tapNumber` INTEGER , `id` INTEGER PRIMARY KEY AUTOINCREMENT , 
#                      `latency` BIGINT , `duration` BIGINT , `pressure` DOUBLE PRECISION , 
#                      `size` DOUBLE PRECISION , `numberPressed` INTEGER );

require 'configliere'
require 'sqlite3'

Settings.use :commandline
Settings.define :db_file, flag: 'd', description: "SQlite3 database to transform", required: true
Settings.define :include_wrong, flag: 'w', description: "Include wrong attempts (off by default)", type: :boolean, default: false
Settings.define :csv, flag: 'c', description: "Output a .csv file instead of a .tsv file", type: :boolean, default: false
Settings.resolve!

COL_NAMES = ["name","pin","entered_pin",
             "latency_1","duration_1","pressure_1","size_1",
             "latency_2","duration_2","pressure_2","size_2",
             "latency_3","duration_3","pressure_3","size_3",
             "latency_4","duration_4","pressure_4","size_4",
             "latency_5","duration_5","pressure_5","size_5"]

puts COL_NAMES.join "\t"

db = SQLite3::Database.new Settings.db_file
db.execute("SELECT * FROM people") do |person|
  db.execute("SELECT * FROM attempts WHERE person_id=#{person[1]}") do |attempt|
    #username and pin
    vector = [person[0],person[2]]
    number = ""
    db.execute("SELECT * FROM taps WHERE attempt_id=#{attempt[1]} ORDER BY tapNumber DESC") do |tap|
      #number entered
      number += tap[-1].to_s
      #data points
      vector += tap[3..6]
    end
    next unless number[0..-3].to_i == person[2] || Settings.include_wrong
    vector.insert(2,number)
    if Settings.csv
      puts vector.join ","
    else
      puts vector.join "\t"
    end
  end
end

