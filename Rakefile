desc "Run all summarization scripts"
task :summarize => ["transform:expand", "summarize:general","summarize:hist", "summarize:qqplot"]

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
task :extract  => ["extract:clean"]
namespace "extract" do
  
  desc "Extract the sqlite database into a tsv"
  task :raw do
    progress "Extracting data from SQLite to raw tsv" do 
      system 'data/munging/extract_sqlite.rb -d data/tapdynamics.db > data/taps.tsv'
    end
  end

  desc "Clean the data, removing wrong attempts and useless variables"
  task :clean => :raw do
    progress "Cleaning raw tsv" do
      system 'data/munging/clean.rb --in_file=data/taps.tsv > data/.tmptaps.tsv'
      system 'mv data/.tmptaps.tsv data/taps.tsv'
    end
  end
end

namespace "transform" do
  desc "Expand the featureset by adding press to press and release to release latencies"
  task :expand => ["extract:clean"] do
    progress "Expanding featureset" do
      system 'data/transform/expand.rb --in_file=data/taps.tsv > data/.tmptaps.tsv'
      system 'mv data/.tmptaps.tsv data/taps.tsv'
    end
  end

  desc "Generate a csv from current tsv file."
  task :csv do
    progress "Transforming data from tsv to csv" do
      system "sed 's/	/,/g' data/taps.tsv > data/taps.csv"
    end
  end
end


def progress message, &blk
  print "#{message}... "
  STDOUT.flush
  blk.call
  puts "Done"
end
