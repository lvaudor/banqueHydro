#' get QTVAR data for a station between two times t1 and t2
#' @export
#' @description This is used to get QTVAR data between two times.
#' @param station station code
#' @param t1 Date de début d'evenement au format "j/M/Y h:m"
#' @param t2 Date de fin d'evenement au format "j/M/Y h:m"
#' @examples
#' df_qtvar<-bh_get_qtvar(station="V2942010",
#'                        t1="05/02/2015 15:00",
#'                        t2="06/02/2015 18:00")
bh_get_qtvar <- function (station,t1,t2)  {
  get_to_station(station)
  get_to_procedure("QTVAR",station)
  res=get_to_qtvar(station,t1,t2)
  df=collect_qtvar(res) %>%
    dplyr::mutate(station=rep(station,dplyr::n())) %>%
    dplyr::select(station,Time, everything())
  return(df)
}
