#!/usr/bin/env ruby
## encoding: UTF-8

require 'configliere'
require 'pp'

Settings.use :commandline
Settings.define :in_file, flag: 'f', description: "tsv to transform", required: true
Settings.define :keep_wrong, flag: 'w', description: "Keep wrong attempts", type: :boolean, default: false
Settings.define :enrollments_thresh, flag: 't', description: "The minimum number of enrollments a person can have before being thrown out", type: Integer, default: 20
Settings.resolve!

PIN_LENGTH = 4
PIN_COL = 1
ENTERED_PIN_COL = 2
DELIM = "\t"

name = ""
held_lines = []
File.open(Settings.in_file, "r") do |file_handle|
  seen_header = false
  file_handle.each_line do |line|
    cols = line.split(DELIM)
    # handle the header
    if !seen_header
      cols.delete_at ENTERED_PIN_COL
      puts cols.join DELIM
      seen_header = true
      next
    end
    # output the columns if there are enough of them
    if cols[0] != name
      if held_lines.length >= Settings.enrollments_thresh 
        held_lines.each { |h_line| puts h_line } 
      else
        $stderr.puts "#{name[0..7]} only had #{held_lines.length} valid attempts. tossing"
      end
      name = cols[0]
      held_lines = []
    end
    # check that they entered their pin correctly
    if !Settings.keep_wrong && cols[PIN_COL] != cols[ENTERED_PIN_COL] 
      $stderr.puts "#{cols[0][0..7]} entered their pin wrong: #{cols[PIN_COL]},#{cols[ENTERED_PIN_COL]}... tossing"
      next
    end
    
    cols.delete_at ENTERED_PIN_COL
    held_lines << cols.join(DELIM)
  end
end
# print the last one
if held_lines.length >= Settings.enrollments_thresh
  held_lines.each do |line|
    puts line
  end
end
