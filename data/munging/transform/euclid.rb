#!/usr/bin/env ruby
# encoding: UTF-8
# This script expands the dataset by adding 
# press to press and release to release latencies
#
# It expects the "clean.rb" script to have been run
# (needs the columns to match IN_COL_NAMES)

require 'configliere'

Settings.use :commandline
Settings.define :in_file, flag: 'f', description: "tsv to transform", required: true
Settings.define :press_to_press, flag: 'p', description: "Add press to press time", type: :boolean, default: true
Settings.define :release_to_release, flag: 'r', description: "Add release to release time", type: :boolean, default: true

Settings.resolve!

# IN_COL_NAMES = ["name","pin"
#             "duration_1","size_1",
#             "latency_2","duration_2","size_2",
#             "latency_3","duration_3","size_3",
#             "latency_4","duration_4","size_4",
#             "latency_5","duration_5","size_5"]

NUM_TAPS = 5
DELIM = "\t"

def latency_for_tap cols, tap_num
  return 0.0 if tap_num == 1
  return Float(cols[4 + (tap_num-2)*3])
end

def duration_for_tap cols, tap_num
  return Float(cols[2 + (tap_num-1)*3])
end

File.open(Settings.in_file, "r") do |file_handle|
  seen_header = false
  file_handle.each_line do |line|
    line.chomp!
    cols = line.split(DELIM)
    if !seen_header
      (2..NUM_TAPS).each do |tnum|
        cols << "p_to_p_#{tnum-1}#{tnum}" if Settings.press_to_press
        cols << "r_to_r_#{tnum-1}#{tnum}" if Settings.release_to_release
      end
      seen_header = true
    else
      (2..NUM_TAPS).each do |tnum|
        cols << duration_for_tap(cols,tnum-1) + latency_for_tap(cols,tnum) if Settings.press_to_press
        cols << latency_for_tap(cols,tnum) + duration_for_tap(cols,tnum) if Settings.release_to_release
      end
    end
    puts cols.join DELIM
  end
end
