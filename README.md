## Tap Dynamics ML

This project contains various scripts and tools for the machine learning portion of the Tap Dynamics project

Directory structure:

```
models      # code for machine learning models
data        # project data
└─ munging  # scripts for munging and transforming the data
summary     # code for summarizing the data, including histograms and qq plots
└─ plots    # directory with plot .pdfs
common      # shared code
```

Rake tasks:

```
$ rake --tasks
rake extract            # Run all extract tasks
rake extract:tsv        # Extract the sqlite database into a tsv
rake extract:clean      # Clean the data, removing wrong attempts and useless variables
rake extract:expand     # Expand the featureset by adding press to press and release to release latencies
rake extract:csv        # Generate a csv from tsv file
rake summarize          # Run all summarization scripts
rake summarize:general  # Text summary including quantiles other basic stats
rake summarize:hist     # Produce histograms of each feature
rake summarize:qqplot   # Produce QQ norm plots for each feature
```

Running `rake extract:expand` will extract, clean, and expand your data. You can also run `rake extract:csv` if you need a csv. You should generate the data before running any summarization tasks.
