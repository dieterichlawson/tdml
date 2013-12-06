DATA_PATH = "data"
DATA_CATEGORIES = ["scratch", "gold"]
SCRIPT_PATH = "#{DATA_PATH}/scripts"

# information on task input and output
$paths = {
  extract: { 
    raw: {
      path: "scratch",
      in_file: "sql_databases", 
      out: "taps_raw.tsv",
    }, 
    clean: {
      path: "scratch",
      in_ns: :extract,
      in_task: :raw,
      out:  "taps_clean.tsv",
    },
  },
  transform: {
    euclid: {
      path: "gold",
      in_ns: :extract,
      in_task: :clean,
      out:  "taps_euclid.csv",
    },
    accel: {
      path: "gold",
      in_ns: :extract,
      in_task: :clean,
      out: "taps_accel.tsv",
    },
  },
}

# task helper fns
def script_path ns, task
  [SCRIPT_PATH,  ns.to_s,  task.to_s].join("/") + ".rb"
end

def in_path ns, task
  if $paths[ns][task].has_key? :in_file
    return "#{DATA_PATH}/#{$paths[ns][task][:in_file]}"
  else
    return out_path($paths[ns][task][:in_ns], $paths[ns][task][:in_task])
  end
end

def out_path ns, task
  "#{DATA_PATH}/#{$paths[ns][task][:path]}/#{$paths[ns][task][:out]}"
end

def task_cmd ns, task
  "#{script_path(ns,task)} --in_file=#{in_path(ns,task)} > #{out_path(ns,task)}"
end

def checkfile file, message
  exists = false
  if File.exist? file
    exists = true
    puts message
  end
  exists
end

def progress message, &blk
  puts "#{message}... "
  blk.call
  puts "Done"
end

def run_task ns, task, msg
  progress msg do
    next if checkfile(out_path(ns,task), "#{out_path(ns,task)} already exists. Skipping...")
    system(task_cmd(ns,task))
  end
end

# CLEAN UP OUTPUT TASK

desc "Remove all output files"
task :clean do
  progress "Removing all output files" do
    $paths.each do |ns, tasks|
      tasks.each do |task, info|
        system "rm #{out_path(ns,task)}" if File.exist? out_path(ns, task)
      end
    end
  end
end

# EXTRACT DATA TASKS

desc "Run all extract tasks"
task :extract  => ["extract:clean"]
namespace "extract" do
  
  desc "Extract the sqlite database into a tsv"
  task :raw do
    run_task(:extract, :raw, "Extracting data from SQLite to raw tsv")
  end

  desc "Clean the data, removing wrong attempts and useless variables"
  task :clean => :raw do
    run_task(:extract, :clean, "Cleaning raw tsv")
  end
end

# TRANSFORM DATA TASKS
desc "Run all transform tasks"
task :transform => ["transform:euclid","transform:accel"]

namespace "transform" do
  desc "Expand the featureset with the Euclidean Distance classifier features"
  task :euclid => ["extract:clean"] do
    progress "Expanding featureset with euclidean classifier features" do
      ns = :transform
      task = :euclid
      in_file = in_path(ns,task)
      out_file = out_path(ns,task)
      out_tsv = out_file.gsub(/csv/,"tsv")
      out_tsv.gsub!(/gold/,"scratch")
      system "#{script_path(ns,task)} --in_file=#{in_file} > #{out_tsv}"
      system "sed 's/	/,/g' #{out_tsv} > #{out_file}"
      system "rm #{out_tsv}"
    end
  end

  desc "Compute and add the accelerometer features"
  task :accel=> ["extract:clean"] do
    run_task(:transform, :accel, "Adding accelerometer features")
  end
end

# SUMMARIZATION TASKS

desc "Run all summarization scripts"
task :summarize => ["extract:accel", "summarize:general","summarize:hist", "summarize:qqplot"]

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

  desc "Produce stats on data collected for specific pins"
  task :pins => ["extract:clean"] do
    puts `summary/pin_stats.rb --in_file=#{out_path(:extract,:clean)}`
  end    
end
