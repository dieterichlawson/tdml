#!/usr/bin/env ruby
# encoding: UTF-8

require 'configliere'
require 'descriptive_statistics'

Settings.use :commandline
Settings.define :in_file, flag: 'f', description: "tsv to transform", required: true
Settings.resolve!

IN_COL_NAMES = ["name","pin",
                "duration_1","size_1",
                "latency_2","duration_2","size_2",
                "latency_3","duration_3","size_3",
                "latency_4","duration_4","size_4",
                "latency_5","duration_5","size_5"]

OUT_COL_NAMES = IN_COL_NAMES + ["x_min", "x_max", "x_mean","x_variance","x_1st_quart","x_2nd_quart","x_3rd_quart",
                                "x_diff_min","x_diff_max","x_diff_mean","x_diff_variance",
                                "y_min", "y_max", "y_mean","y_variance","y_1st_quart","y_2nd_quart","y_3rd_quart",
                                "y_diff_min","y_diff_max","y_diff_mean","y_diff_variance",
                                "z_min", "z_max", "z_mean","z_variance","z_1st_quart","z_2nd_quart","z_3rd_quart",
                                "z_diff_min","z_diff_max","z_diff_mean","z_diff_variance"];

IN_NUM_COLS = IN_COL_NAMES.length

DELIM = "\t"
ACCEL_DELIM = "ACCEL"

def features_for_dim dim
  stats = [dim.min, dim.max, dim.mean, dim.variance, dim.percentile(25), dim.percentile(50), dim.percentile(75)]
  diff = dim.each_cons(2).map { |a,b| b-a }
  if dim.length == 1
    stats += [0.0, 0.0, 0.0, 0.0]
  else
    stats +=  [diff.min, diff.max, diff.mean, diff.variance] 
  end
  stats
end

File.open(Settings.in_file, "r") do |file_handle|
    seen_header = false
    file_handle.each_line do |line|
      if !seen_header
        puts OUT_COL_NAMES.join DELIM
        seen_header = true
        next
      end
      # split the data into main data and accelerometer data
      cols = line.split(DELIM)
      accel_ind = cols.index(ACCEL_DELIM)
      accel_data = cols[accel_ind+1..-1]
      main_data = cols[0..accel_ind-1]
      # convert to floats
      accel_data = accel_data.collect{|elem| elem.to_f}
      # extract x y and z data
      x = accel_data.select.each_with_index { |x, i| i % 3==0 }
      y = accel_data.select.each_with_index { |y, i| i % 3==1 }
      z = accel_data.select.each_with_index { |z, i| i % 3==2 }
      # compute features
      # output
      data = main_data + features_for_dim(x) + features_for_dim(y) + features_for_dim(z)
      puts data.join DELIM
    end
end
