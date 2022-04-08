options(DT.options = list(dom = "Brtip",
                          buttons = c("copy", "csv", "excel", "print"),
                          pageLength = 50
))

my_DT <- function(x, ...)
  datatable(x, ..., escape = FALSE, extensions = c("Buttons", "FixedColumns"), filter = "top", rownames = FALSE,
            style = "bootstrap")

# options = list(dom = 't', scrollX = TRUE, scrollCollapse = TRUE,
#                scrollY = "700px", paging = FALSE, fixedColumns = list(leftColumns = 1)))