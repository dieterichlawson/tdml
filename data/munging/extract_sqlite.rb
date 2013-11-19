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
Settings.resolve!

ENTER_VALS = [-1, 100]
COL_NAMES = ["name","pin","entered_pin",
             "latency_1","duration_1","pressure_1","size_1",
             "latency_2","duration_2","pressure_2","size_2",
             "latency_3","duration_3","pressure_3","size_3",
             "latency_4","duration_4","pressure_4","size_4",
             "latency_5","duration_5","pressure_5","size_5"]

puts COL_NAMES.join "\t"

db = SQLite3::Database.new Settings.db_file
db.execute("SELECT id, username, pin FROM people") do |person|
  db.execute("SELECT id FROM attempts WHERE person_id=#{person[0]}") do |attempt|
    #username and pin
    vector = person[1..2]
    number = ""
    db.execute("SELECT latency, duration, pressure, size, tapNumber, numberPressed FROM taps WHERE attempt_id=#{attempt[0]} ORDER BY tapNumber ASC") do |tap|
      # skip if its a double-enter weirdness TODO:WTF
      next if ENTER_VALS.include? tap[-1] && vector.length == COL_NAMES.length - 1
      #number entered
      number += tap[-1].to_s unless ENTER_VALS.include? tap[-1]
      #data points
      vector += tap[0..3]
    end
    vector.insert(2,number)
    puts vector.join "\t"
  end
end

