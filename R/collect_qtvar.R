#' collect QTVAR data from response page
#' @param res response page
collect_qtvar <- function (res)  {
  pageToRead=content(res, "text", encoding = "ISO-8859-1", type="html")
  doc=xml2::read_html(pageToRead)
  tables=doc %>%
    rvest::html_nodes("table")
  n=which(rvest::html_attr(tables,"summary")=="Débits à pas de temps variable")
  df=tables[n] %>%
    rvest::html_table() %>%
    .[[1]] %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(Date=lubridate::dmy_hm(Date),
           Q=`Q (m3/s)`,
           V=V,
           C=C) %>%
    dplyr::select(Date,Q,V,C)
}
