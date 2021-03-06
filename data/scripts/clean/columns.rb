#!/usr/bin/env ruby
# encoding: UTF-8

require 'configliere'
require 'pp'

Settings.use :commandline
Settings.define :in_file, flag: 'f', description: "tsv to transform", required: true
Settings.define :keep_pressure, flag: 'p', description: "Keep pressure data", type: :boolean, default: false
Settings.define :keep_latency_1, flag: 'p', description: "Keep first latency reading", type: :boolean, default: false
Settings.resolve!

IN_COL_NAMES = ["name","pin",
             "latency_1","duration_1","pressure_1","size_1",
             "latency_2","duration_2","pressure_2","size_2",
             "latency_3","duration_3","pressure_3","size_3",
             "latency_4","duration_4","pressure_4","size_4",
             "latency_5","duration_5","pressure_5","size_5"]

IN_NUM_COLS = IN_COL_NAMES.length

LATENCY_1_COL = 2 
PRESSURE_COLS = [4,8,12,16,20]

DELIM = "\t"
ACCEL_DELIM = "ACCEL"

cols_to_rem = []
cols_to_rem += PRESSURE_COLS unless Settings.keep_pressure
cols_to_rem << LATENCY_1_COL unless Settings.keep_latency_1
cols_to_rem = cols_to_rem.sort.reverse

File.open(Settings.in_file, "r") do |file_handle|
    seen_header = false
    file_handle.each_line do |line|
      cols = line.split(DELIM)
      
      length = cols.index ACCEL_DELIM
      if seen_header && length  != IN_NUM_COLS
        $stderr.puts "#{cols[0][0..7]} is weird (too many cols)"
        next
      end
      
      cols_to_rem.each do |col|
        cols.delete_at col
      end
      
      puts cols.join DELIM
      seen_header = true
    end
end
