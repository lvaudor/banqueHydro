#' Format time to be formatted as banqueHydro expects for QTVAR ("%d/%m/%Y %H:%M")
#' @param mytime time
#' @return time in format "%d/%m/%Y %H:%M"
#' @export
format_time_for_qtvar=function(mytime){
  mytime %>%
    round("mins") %>%
    format("%d/%m/%Y %H:%M")
}
