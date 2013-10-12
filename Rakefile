desc "Run summarize.R to produce plots and useful summaries of the data"
task :summarize do
  system './summarize.R'
end

desc "Extract the sqlite database into a tsv"
task :extract do
  system 'munging/extract_sqlite.rb -d munging/tapdynamics.db > munging/taps.tsv'
end
