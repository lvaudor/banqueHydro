#' Get QJM data for a station between two times t1 and t2
#' @description This is used to get QJM data between two years t1 and t2.
#' @export
#' @param station station code
#' @param t1 Beginning year
#' @param t2 Ending year
#' @param verbose whether to progressively print what data is being collected. Defaults to TRUE.
#' @param sleep time to wait between two successive GET requests. Defaults to 30 seconds.
#' @return tibble with QJM data
#' @examples
#' df_qjm<-bh_get_qjm(station="V2942010",
#'                    t1=2008,
#'                    t2=2009)
bh_get_qjm <- function (station,t1,t2,verbose=TRUE, sleep=10)  {
  seqyears=as.numeric(t1):as.numeric(t2)
  df=NULL
  for (i in 1:length(seqyears)){
    if(verbose==TRUE){print(paste0("Collecting QJM data for year ",
                                  seqyears[i],"."))}
    res_tmp=get_to_station(station)

    Sys.sleep(sleep)
    res_tmp=res_tmp %>%
      get_to_procedure("QJM",station)

    Sys.sleep(sleep)
    res_tmp=res_tmp %>%
      get_to_qjm(year=seqyears[i])

    Sys.sleep(sleep)
    df_tmp=res_tmp %>%
      collect_qjm(year=seqyears[i]) %>%
      dplyr::mutate(station=rep(station,dplyr::n())) %>%
      dplyr::select(station,.data$Date, dplyr::everything())
    df=df %>%
      dplyr::bind_rows(df_tmp)
  }
  df=unique(df)
  return(df)
}
