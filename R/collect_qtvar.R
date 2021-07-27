#' collect_qtvar from webpage
#' @param res response page
#' @return QTVAR data corresponding to page
#' @importFrom rlang .data
collect_qtvar <- function (res)  {
  pageToRead=httr::content(res,
                           "text",
                           encoding = "ISO-8859-1",
                           type="html")
  doc=xml2::read_html(pageToRead)
  tables=doc %>%
    rvest::html_nodes("table")
  n=which(rvest::html_attr(tables,"summary")=="Débits à pas de temps variable")
  df=tables[n] %>%
    rvest::html_table() %>%
    magrittr::extract2(1) %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(Time=lubridate::dmy_hm(.data$Date),
           Q=.data$`Q (m3/s)`,
           V=.data$V,
           C=.data$C) %>%
    dplyr::select(.data$Time,.data$Q)
  return(df)
}
