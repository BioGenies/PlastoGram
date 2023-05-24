markdown_citation <- function() {
  "
Sidorczuk K., Gagat P., Kała J., Nielsen H., Pietluch F., Mackiewicz P., Burdukiewicz M. Prediction of 
protein subplastid localization and origin with PlastoGram. 
Sci Rep 13, 8365 (2023). https://doi.org/10.1038/s41598-023-35296-0
  "
}

markdown_contact <- function() {
  "
For general questions or problems, please email
[Katarzyna Sidorczuk](mailto:sidorczuk.katarzyna17&#64;gmail.com) or
[Michal Burdukiewicz](mailto:michalburdukiewicz&#64;gmail.com).
  "
}

markdown_acknowledgements <- function() {
  "
  This work has been supported by the National Science Centre grant [2018/31/N/NZ2/01338](https://projekty.ncn.gov.pl/index.php?projekt_id=429890) to K.S., 
the National Science Centre grant [2017/26/D/NZ8/00444](https://projekty.ncn.gov.pl/index.php?projekt_id=384760) to P.G.,
and the National Science Centre grant [2019/35/N/NZ8/03366](https://projekty.ncn.gov.pl/index.php?projekt_id=463135) to F.P. 
M. B. was supported by the Maria Zambrano grant funded by the European Union-NextGenerationEU.
  "
}

markdown_versions <- function() {
  "
  We provide two versions of PlastoGram trained and evaluated on slightly different subsets of data. Two versions of data sets differed in a strategy of division into train-test and independent sets. In the **holdout version**, the independent set was created by randomly selecting 15% of sequences from each class, whereas the rest was used in cross-validation and to train the final model. In the **partitioning version**, division into train-test and independent sets was carried out using homology partitioning ensuring that between these sets there are no sequences with identity percent higher than 40&#37;. 
  
  - **PlastoGram H** - model trained on the holdout data set, had better performance in the independent test but homology between training and independent sequences was not accounted for.
  - **PlastoGram P** - model trained on the partitioning data set, had lower performance in the independent test but there were fewer test sequences and they were not homologous to those in the training set. 
  
  "

}