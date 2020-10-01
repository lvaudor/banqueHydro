#' get QJM data for a station between two times t1 and t2
#' @description This is used to get QJM data between two years t1 and t2.
#' @param station station code
#' @param t1 Beginning year
#' @param t2 Ending year
#'
#'
#' @examples
#' df_qjm<-bh_get_qjm(station="V2942010",
#'                    t1=2008,
#'                    t2=2010)
bh_get_qjm <- function (station,t1,t2)  {
  get_to_station(station)
  get_to_procedure("QJM",station)
  df=as.numeric(t1):as.numeric(t2) %>%
     purrr::map(get_to_qjm) %>%
     purrr::map2_df(as.numeric(t1):as.numeric(t2),.f=collect_qjm)

}
