#' Formats time as "\%d/\%m/\%Y \%H:\%M"
#' @param mytime time to be formatted
#' @return formatted time
#' @export
format_time_for_qtvar=function(mytime){
  mytime %>%
    round("mins") %>%
    format("%d/%m/%Y %H:%M")
}
