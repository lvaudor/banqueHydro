#' collect_qjm from webpage
#' @param res response page
#' @param year year
#' @return QJM data corresponding to year
#' @importFrom rlang .data
collect_qjm <- function (res,year)  {
  pageToRead=httr::content(res,
                           "text",
                           encoding = "ISO-8859-1",
                           type="html")
  doc=xml2::read_html(pageToRead)

  get_data_month=function(table_month,which_month){
    table_month %>%
      rvest::html_nodes("tr") %>%
      magrittr::extract(1) %>%
      rvest::html_nodes("table") %>%
      purrr::map_df(rvest::html_table) %>%
      dplyr::mutate(Month=rep(which_month,length(.data$X1)),
             Day=.data$X1,
             Qj=.data$X2,
             Val=.data$X3)
  }

   data_year=doc %>%
    rvest::html_nodes(".gauche3") %>%
    rvest::html_node("table") %>%
    magrittr::extract(3:14) %>%
    purrr::map2_df(.y=1:12,.f=get_data_month) %>%
    dplyr::mutate(Year=rep(year,dplyr::n())) %>%
    dplyr::mutate(Date=lubridate::make_date(.data$Year,.data$Month,.data$Day)) %>%
    dplyr::select(.data$Date,.data$Qj,.data$Val) %>%
    dplyr::mutate(Val=as.character(.data$Val))%>%
    dplyr::as_tibble()
  return(data_year)
}
