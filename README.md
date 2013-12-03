## Tap Dynamics ML

This project contains various scripts and tools for the machine learning portion of the Tap Dynamics project

### Directory structure

```
data                # project data
├── scratch         # holds intermediate data configurations
├── gold            # holds final data, fit for use in classification
├── scripts         # scripts to munge the data
│   ├── extract     # scripts to extract data from raw form to reasonable baseline
│   └── transform   # scripts for more advanced data transforms like adding features
└── sql_databases   # contains the raw source data in SQL form
models              # code for machine learning models (mostly MATLAB)
├── analysis_tools  # scripts for model diagnostics like ablative analysis
├── euclidean       # a euclidean distance classifier from the literature
├── gda             # gaussian discriminant analysis classifier
├── rforest         # random forest classifier
├── softmax         # softmax regression classifier
└── util            # MATLAB utils (e.g. loading data)
summary             # R scripts for summarizing the data (histograms, qqplots, etc...)
└── plots           # plot .pdfs
```

### Rake Tasks
We use `rake` to make it easy to organize and run the various scripts that make up the project. Our rake namespace is organized similarly to our directory namespace, with a few differences.

```
$ rake --tasks
rake clean              # Remove all output files
rake extract            # Run all extract tasks
rake extract:clean      # Clean the data, removing wrong attempts and useless variables
rake extract:raw        # Extract the sqlite database into a tsv
rake transform:accel    # Compute and add the accelerometer features
rake transform:euclid   # Expand the featureset with the Euclidean Distance classifier features
rake summarize          # Run all summarization scripts
rake summarize:general  # Text summary including quantiles other basic stats
rake summarize:hist     # Produce histograms of each feature
rake summarize:pins     # Produce stats on data collected for specific pins
rake summarize:qqplot   # Produce QQ norm plots for each feature
```

A good way to get started is by running `rake transform:accel`, which will extract, clean, and add accelerometer features to your data, giving you a good baseline dataset for use with the classification algorithms. You should generate the data before running any summarization tasks.

### Dependencies

#### Ruby Gems
* Configliere: https://github.com/infochimps-labs/configliere (used in all Ruby scripts)
* Awesome Print: https://github.com/michaeldv/awesome_print (used for pin stats script)
* Descriptive Statistics: https://github.com/thirtysixthspan/descriptive_statistics (used for accelerometer data)

#### R Packages
* qualityTools: http://cran.r-project.org/web/packages/qualityTools/index.html (used for producing qqplots)
