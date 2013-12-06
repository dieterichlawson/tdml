#!/usr/bin/env ruby
# encoding: UTF-8

require 'configliere'
require 'awesome_print'
require 'set'

Settings.use :commandline
Settings.define :in_file, flag: 'f', description: "TSV file", required: true
Settings.resolve!

NAME_COL = 0
PIN_COL = 1

attempts_per_pin = {}
people_per_pin = {}
seen_header = false
File.open(Settings.in_file, "r") do |file_handle|
  file_handle.each_line do |line|
    if !seen_header
      seen_header = true
      next
    end
    cols = line.split("\t")
    person = cols[NAME_COL]
    pin = cols[PIN_COL]
    attempts_per_pin[pin] ||=0
    attempts_per_pin[pin] +=1
    people_per_pin[pin] ||= Set.new
    people_per_pin[pin].add person
  end
end
puts "***** Pin Stats *****"
puts "Number of pins: #{attempts_per_pin.size}"
puts "Attempts per pin:"
ap attempts_per_pin
puts "People per pin:"
people_per_pin.each do |pin, people|
  puts "#{pin}: #{people.size}"
end
puts "Specific people per pin:"
ap people_per_pin
