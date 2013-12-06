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
require 'digest'

Settings.use :commandline
Settings.define :in_file, flag: 'f', description: "SQlite3 database to transform", required: true
Settings.resolve!

ACCEL_DELIM = "ACCEL"

ENTER_VALS = [-1, 100]

COL_NAMES = ["name","pin","entered_pin",
             "latency_1","duration_1","pressure_1","size_1",
             "latency_2","duration_2","pressure_2","size_2",
             "latency_3","duration_3","pressure_3","size_3",
             "latency_4","duration_4","pressure_4","size_4",
             "latency_5","duration_5","pressure_5","size_5"]

def gen_pid file, person_id
  Digest::SHA256.base64digest("#{file}#{person_id}")[0..-2]  
end

files = Dir.glob(File.join(Settings.in_file, "*.db"))

files.each do |file|
  db = SQLite3::Database.new file
  db.execute("SELECT id, username, pin FROM people") do |person|
    db.execute("SELECT id FROM attempts WHERE person_id=#{person[0]}") do |attempt|
      #username and pin
      vector = [gen_pid(file,person[0]), person[2]];
      number = ""
      accelerometer = []
      db.execute("SELECT id, numberPressed, latency, duration, pressure, size FROM taps WHERE attempt_id=#{attempt[0]} ORDER BY tapNumber ASC") do |tap|
        # skip if its a double-enter weirdness TODO:WTF
        next if ENTER_VALS.include? tap[-1] && vector.length == COL_NAMES.length - 1
        #number entered
        number += tap[1].to_s unless ENTER_VALS.include? tap[1]
        #data points
        vector += tap[2..5]
        db.execute("SELECT x, y, z FROM accelerometer_data WHERE tap_id=#{tap[0]} ORDER BY readingNumber ASC") do |accel_data|
          accelerometer += accel_data 
        end
      end
      vector.insert(2,number)
      vector = vector + [ACCEL_DELIM] + accelerometer
      puts vector.join "\t"
    end
  end
end
