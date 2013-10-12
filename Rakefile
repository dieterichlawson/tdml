desc "Run summarize.R to produce plots and useful summaries of the data"
task :summarize do
  system 'summary/summarize.R'
end

desc "Extract the sqlite database into a tsv"
task :extract do
  print "Extracting data from SQLite to tsv... "
  STDOUT.flush
  system 'data/munging/extract_sqlite.rb -d data/tapdynamics.db > data/taps.tsv'
  puts "Done!"
end
