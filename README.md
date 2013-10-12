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
rake extract    # Extract the sqlite database into a tsv
rake summarize  # Run summarize.R to produce plots and useful summaries of the data
```
