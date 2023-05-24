
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="./inst/PlastoGram/PlastoGram_logo.png" style="height: 200px;"/>

## Web server

The Shiny web server is available under the address:
<https://biogenies.info/PlastoGram>.

## Installation

### Installing HMMER

PlastoGram uses HMMER software to predict thylakoid lumen proteins
imported via Sec and Tat pathways with HMM profiles. You can install
HMMER using the following instructions (adapted from [HMMER
documentation](http://hmmer.org/documentation.html)):

-   installing with system packager

<!-- -->

      % brew install hmmer               # OS/X, HomeBrew
      % port install hmmer               # OS/X, MacPorts
      % apt install hmmer                # Linux (Ubuntu, Debian...)
      % dnf install hmmer                # Linux (Fedora)
      % yum install hmmer                # Linux (older Fedora)
      % conda install -c bioconda hmmer  # Anaconda

-   compiling from source

<!-- -->

      % wget http://eddylab.org/software/hmmer/hmmer.tar.gz 
      % tar zxf hmmer.tar.gz
      % cd hmmer-3.3.2
      % ./configure --prefix /your/install/path
      % make
      % make check
      % make install
      % (cd easel; make install)

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

-   Nuclear_model - recognizes nuclear-encoded proteins
-   Membrane_model - identifies membrane proteins
-   N_E\_vs_N\_TM_model - differentiates between nuclear-encoded
    envelope proteins and nuclear-encoded thylakoid membrane proteins.
    Prediction values over 0.5 indicate envelope, whereas lower
    thylakoid membrane
-   Plastid_membrane_model - distinguishes plastid-encoded proteins
    targeted to plastid inner and thylakoid membrane. Prediction values
    higher than 0.5 indicate inner membrane, whereas lower thylakoid
    membrane
-   N_E\_vs_N\_S_model - differentiates nuclear-encoded proteins
    targeted to envelope from nuclear-encoded stromal proteins.
    Prediction values over 0.5 indicate envelope, whereas lower stroma
-   Nuclear_membrane_model - distinguishes nuclear-encoded membrane
    proteins from all others
-   Sec_model - identifies proteins targeted to the thylakoid lumen via
    Sec pathway
-   Tat_model - recognizes proteins targeted to the thylakoid lumen via
    Tat pathway

## Versions of the model

We provide two versions of PlastoGram trained and evaluated on slightly
different subsets of data. Two versions of data sets differed in a
strategy of division into train-test and independent sets. In the
**holdout version**, the independent set was created by randomly
selecting 15% of sequences from each class, whereas the rest was used in
cross-validation and to train the final model. In the **partitioning
version**, division into train-test and independent sets was carried out
using homology partitioning ensuring that between these sets there are
no sequences with identity percent higher than 40%.

-   **PlastoGram H** - model trained on the holdout data set, had better
    performance in the independent test but homology between training
    and independent sequences was not accounted for.
-   **PlastoGram P** - model trained on the partitioning data set, had
    lower performance in the independent test but there were fewer test
    sequences and they were not homologous to those in the training set.

## Predicting subplastid localization

Suppopse you wish to predict localization of proteins which sequences
are stored in sequence_file.fa located in the working directory using
the holdout version of PlastoGram model.

``` r
# load the package
library(PlastoGram)

# read in sequences
sequences <- read_txt("sequence_file.fa")

# run predictions
predictions <- predict(PlastoGram_H, sequences)

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

## Citation

Sidorczuk K., Gagat P., Kała J., Nielsen H., Pietluch F., Mackiewicz P.,
Burdukiewicz M. Prediction of protein subplastid localization and origin
with PlastoGram. Sci Rep 13, 8365 (2023).
<https://doi.org/10.1038/s41598-023-35296-0>

## Code availability

Code necessary to reproduce the whole analysis described in the article
and leading to the final PlastoGram algorithm is available at
<https://github.com/BioGenies/PlastoGram-analysis>.

## Contact

For general questions or problems, please email [Katarzyna
Sidorczuk](mailto:sidorczuk.katarzyna17@gmail.com) or [Michal
Burdukiewicz](mailto:michalburdukiewicz@gmail.com).

## Acknowledgements

This work has been supported by the National Science Centre grant
[2018/31/N/NZ2/01338](https://projekty.ncn.gov.pl/index.php?projekt_id=429890)
to K.S., the National Science Centre grant
[2017/26/D/NZ8/00444](https://projekty.ncn.gov.pl/index.php?projekt_id=384760)
to P.G., and the National Science Centre grant
[2019/35/N/NZ8/03366](https://projekty.ncn.gov.pl/index.php?projekt_id=463135)
to F.P. M. B. was supported by the Maria Zambrano grant funded by the
European Union-NextGenerationEU.
