## Tap Dynamics ML

This project contains various scripts and tools for the machine learning portion of the Tap Dynamics project

Directory structure:

```
models       # code for machine learning models
data         # project data
├─ munging   # scripts for extracting and cleaning the data
└─ transform # scripts for data transforms, including adding/removing columns, etc...
summary      # code for summarizing the data, including histograms and qq plots
└─ plots     # directory with plot .pdfs
common       # shared code
```

We use `rake` to make it easy to organize and run the various scripts that make up the project. Our rake namespace is organized similarly to our directory namespace, with few differences.

```
$ rake --tasks
rake extract            # Run all extract tasks
rake extract:raw        # Extract the sqlite database into a tsv
rake extract:clean      # Clean the data, removing wrong attempts and useless variables
rake summarize          # Run all summarization scripts
rake summarize:general  # Text summary including quantiles other basic stats
rake summarize:hist     # Produce histograms of each feature
rake summarize:qqplot   # Produce QQ norm plots for each feature
rake transform:csv      # Generate a csv from current tsv file
rake transform:expand   # Expand the featureset by adding press to press and release to release latencies
```

A good way to get started is by running `rake transform:expand`, which will extract, clean, and expand your data. This gives you a tsv, but you can also run `rake extract:csv` if you need a csv. You should generate the data before running any summarization tasks.
