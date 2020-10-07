#' collect QTVAR data from response page, for a given year
#' @param res response page
#' @param year year
collect_qjm <- function (res,year)  {
  pageToRead=httr::content(res,
                           "text",
                           encoding = "ISO-8859-1",
                           type="html")
  doc=xml2::read_html(pageToRead)

  get_data_month=function(table_month,which_month){
    table_month %>%
      rvest::html_nodes("tr") %>%
      .[1] %>%
      rvest::html_nodes("table") %>%
      purrr::map_df(html_table) %>%
      dplyr::mutate(Month=rep(which_month,length(X1)),
             Day=X1,
             Qj=X2,
             Val=X3)
  }

   data_year=doc %>%
    html_nodes(".gauche3") %>%
    html_node("table") %>%
    .[3:14] %>%
    purrr::map2_df(.y=1:12,.f=get_data_month) %>%
    dplyr::mutate(Year=rep(year,n())) %>%
    dplyr::mutate(Date=lubridate::make_date(Year,Month,Day)) %>%
    dplyr::select(Date,Qj,Val) %>%
    dplyr::mutate(Val=as.character(Val))%>%
    dplyr::as_tibble()
  return(data_year)
}
