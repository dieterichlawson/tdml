#!/usr/bin/env ruby
# encoding: UTF-8

require 'configliere'
require 'pp'

Settings.use :commandline
Settings.define :in_file, flag: 'f', description: "tsv to transform", required: true
Settings.define :keep_wrong, flag: 'w', description: "Keep wrong attempts", type: :boolean, default: false
Settings.define :keep_pressure, flag: 'p', description: "Keep pressure data", type: :boolean, default: false
Settings.define :keep_latency_1, flag: 'p', description: "Keep first latency reading", type: :boolean, default: false
Settings.resolve!

IN_COL_NAMES = ["name","pin","entered_pin",
             "latency_1","duration_1","pressure_1","size_1",
             "latency_2","duration_2","pressure_2","size_2",
             "latency_3","duration_3","pressure_3","size_3",
             "latency_4","duration_4","pressure_4","size_4",
             "latency_5","duration_5","pressure_5","size_5"]
IN_NUM_COLS = IN_COL_NAMES.length

PIN_LENGTH = 4
PIN = 1
ENTERED_PIN = 2
PRESSURE_COLS = [5,9,13,17,21]
LATENCY_1_COL = 3
DELIM = "\t"
ACCEL_DELIM = "ACCEL"

cols_to_rem = []
cols_to_rem += PRESSURE_COLS unless Settings.keep_pressure
cols_to_rem += [LATENCY_1_COL] unless Settings.keep_latency_1
cols_to_rem += [ENTERED_PIN] unless Settings.keep_wrong
cols_to_rem = cols_to_rem.sort.reverse

File.open(Settings.in_file, "r") do |file_handle|
    seen_header = false
    file_handle.each_line do |line|
      cols = line.split(DELIM)
      if seen_header && !Settings.keep_wrong && cols[PIN] != cols[ENTERED_PIN][0..PIN_LENGTH-1] 
        $stderr.puts "#{cols[0]} entered their pin wrong... tossing"
        next
      end
     
      length = cols.index ACCEL_DELIM
      if seen_header && length  != IN_NUM_COLS
        $stderr.puts "#{cols[0]} is weird (too many cols)"
        next
      end
      
      cols_to_rem.each do |col|
        cols.delete_at col
      end
      puts cols.join DELIM
      seen_header = true
    end
end
