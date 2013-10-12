desc "Run all summarization scripts"
task :summarize => ["summarize:general","summarize:hist", "summarize:qqplot"]

namespace "summarize" do
  desc "Text summary including quantiles other basic stats"
  task :general do
    system 'summary/general.R' 
  end
  
  desc "Produce histograms of each feature"
  task :hist do
    system 'summary/hist.R' 
  end

  desc "Produce QQ norm plots for each feature"
  task :qqplot do
    system 'summary/qqplot.R' 
  end
end

desc "Run all extract tasks"
task :extract  => ["extract:tsv", "extract:csv"]

namespace "extract" do
  
  desc "Extract the sqlite database into a tsv"
  task :tsv do
    print "Extracting data from SQLite to tsv... "
    STDOUT.flush
    system 'data/munging/extract_sqlite.rb -d data/tapdynamics.db > data/taps.tsv'
    puts "Done!"
  end

  desc "Extract the sqlite database into a csv"
  task :csv do
    print "Extracting data from SQLite to tsv... "
    STDOUT.flush
    system 'data/munging/extract_sqlite.rb -c -d data/tapdynamics.db > data/taps.csv'
    puts "Done!"
  end
end
