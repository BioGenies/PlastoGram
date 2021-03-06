
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="./inst/PlastoGram/PlastoGram_logo.png" style="height: 200px;"/>

## Installation

### Installing HMMER

PlastoGram uses HMMER software to predict thylakoid lumen proteins
imported via Sec and Tat pathways with HMM profiles. You can install
HMMER using the following instructions (adapted from [HMMER
documentation](http://hmmer.org/documentation.html)):

  - installing with system packager

<!-- end list -->

``` 
  % brew install hmmer               # OS/X, HomeBrew
  % port install hmmer               # OS/X, MacPorts
  % apt install hmmer                # Linux (Ubuntu, Debian...)
  % dnf install hmmer                # Linux (Fedora)
  % yum install hmmer                # Linux (older Fedora)
  % conda install -c bioconda hmmer  # Anaconda
```

  - compiling from source

<!-- end list -->

``` 
  % wget http://eddylab.org/software/hmmer/hmmer.tar.gz 
  % tar zxf hmmer.tar.gz
  % cd hmmer-3.3.2
  % ./configure --prefix /your/install/path
  % make
  % make check
  % make install
  % (cd easel; make install)
```

For more information about HMMER please visit [HMMER
website](http://hmmer.org/).

### Installing PlastoGram

You can install the latest development version of the package:

``` r
if(!require("devtools")) install.packages("devtools")
devtools::install_github("https://github.com/BioGenies/PlastoGram/")
```

## PlastoGram model

PlastoGram is a robust ensemble model for detailed and accurate
prediction of subplastid localization and origin of analysed protein.
PlastoGram classifies protein as nuclear- or plastid-encoded and
predicts its most probable localization considering envelope, stroma,
thylakoid membrane or thylakoid lumen. For the latter, also the import
pathway (Sec or Tat) is predicted. We provide an additional function to
differentiate nuclear-encoded inner and outer membrane proteins.

PlastoGram consists of eight lower-level models trained to tackle a
specific labeling problem and a higher-level random forest model, which
uses results from of lower-level models to provide the prediction of a
protein localization and origin. The lower-level models used in the
PlastoGram with their areas of competence are listed below:

  - Nuclear\_model - recognizes nuclear-encoded proteins
  - Membrane\_model - identifies membrane proteins
  - N\_E\_vs\_N\_TM\_model - differentiates between nuclear-encoded
    envelope proteins and nuclear-encoded thylakoid membrane proteins.
    Prediction values over 0.5 indicate envelope, whereas lower
    thylakoid membrane
  - Plastid\_membrane\_model - distinguishes plastid-encoded proteins
    targeted to plastid inner and thylakoid membrane. Prediction values
    higher than 0.5 indicate inner membrane, whereas lower thylakoid
    membrane
  - N\_E\_vs\_N\_S\_model - differentiates nuclear-encoded proteins
    targeted to envelope from nuclear-encoded stromal proteins.
    Prediction values over 0.5 indicate envelope, whereas lower stroma
  - Nuclear\_membrane\_model - distinguishes nuclear-encoded membrane
    proteins from all others
  - Sec\_model - identifies proteins targeted to the thylakoid lumen via
    Sec pathway
  - Tat\_model - recognizes proteins targeted to the thylakoid lumen via
    Tat pathway

## Predicting subplastid localization

Suppopse you wish to predict localization of proteins which sequences
are stored in sequence\_file.fa located in the working directory.

``` r
# load the package
library(PlastoGram)

# read in sequences
sequences <- read_txt("sequence_file.fa")

# run predictions
predictions <- predict(PlastoGram_model, sequences)

# inspect results
# see predictions of origin and localization:
predictions[["Final_results"]]

# save predictions of origin and localization to a csv file named 'PlastoGram_predictions.csv'
write.csv(predictions[["Final_results"]], "PlastoGram_predictions.csv")

# get summary with number of proteins identified in each class
library(dplyr)
predictions[["Final_results"]] %>% 
  group_by(Localization) %>% 
  summarise(count = n())

# see predictions from lower-level models
predictions[["Lower_level_preds"]]

# see higher-level model predictions
predictions[["Higher_level_preds"]]

# see predictions of detailed localization for N_E proteins (OM or IM)
predictions[["OM_IM_preds"]]
```

## Citation (coming soon)

Sidorczuk K., Gagat P., Ka??a J., Nielsen H., Pietluch F., Mackiewicz P.,
Burdukiewicz M. (2022). Where do they come from, where do they go?
Efficient prediction of protein subplastid localization and sequence
origin with PlastoGram. XXXYYY, doi.

## Contact

For general questions or problems, please email [Katarzyna
Sidorczuk](mailto:sidorczuk.katarzyna17@gmail.com) or [Michal
Burdukiewicz](mailto:michalburdukiewicz@gmail.com).

## Acknowledgements

PlastoGram is supported by the grant no. [2018/31/N/NZ2/01338 (National
Science
Center)](https://projekty.ncn.gov.pl/index.php?projekt_id=429890) to
Katarzyna Sidorczuk.
