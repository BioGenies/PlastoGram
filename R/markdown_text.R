markdown_citation <- function() {
  "
Sidorczuk K., Gagat P., Kała J., Nielsen H., Pietluch F., Mackiewicz P., Burdukiewicz M. (2022). 
Where do they come from, where do they go? Efficient prediction of protein subplastid localization 
and sequence origin with PlastoGram. XXXYYY, doi.
  "
}

markdown_contact <- function() {
  "
For general questions or problems, please email
[Katarzyna Sidorczuk](mailto:sidorczuk.katarzyna17@gmail.com) or
[Michal Burdukiewicz](mailto:michalburdukiewicz@gmail.com).
  "
}

markdown_acknowledgements <- function() {
  "
  This work
has been supported by the Foundation of Polish Science grant TEAM TECH CORE FACILITY/2016-2/2 to M.B, 
the National Science Centre grant [2018/31/N/NZ2/01338](https://projekty.ncn.gov.pl/index.php?projekt_id=429890) to K.S., 
the National Science Centre grant [2017/26/D/NZ8/00444](https://projekty.ncn.gov.pl/index.php?projekt_id=384760) to P.G.,
and the National Science Centre grant [2019/35/N/NZ8/03366](https://projekty.ncn.gov.pl/index.php?projekt_id=463135) to F.P.
  "
}

markdown_versions <- function() {
  "
  We provide two versions of PlastoGram trained and evaluated on slightly different subsets of data. Two versions of data sets differed in a strategy of division into train-test and independent sets. In the **holdout version**, the independent set was created by randomly selecting 15% of sequences from each class, whereas the rest was used in cross-validation and to train the final model. In the **partitioning version**, division into train-test and independent sets was carried out using homology partitioning ensuring that between these sets there are no sequences with identity percent higher than 40%. 
  
  - **PlastoGram H** - model trained on the holdout data set, had better performance in the independent test but homology between training and independent sequences was not accounted for.
  - **PlastoGram P** - model trained on the partitioning data set, had lower performance in the independent test but there were fewer test sequences and they were not homologous to those in the training set. 
  
  "

}