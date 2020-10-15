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
#'                    t2=2010)
bh_get_qjm <- function (station,t1,t2,verbose=TRUE)  {
  res=get_to_station(station) %>%
      get_to_procedure("QJM",station)
  seqyears=as.numeric(t1):as.numeric(t2)
  df=NULL
  for (i in 1:length(seqyears)){
    if(i>1){Sys.sleep(sleep)}
    if(verbose==TRUE){print(paste0("Collecting QJM data for year ",
                                  seqyears[i],"."))}
    res_tmp=get_to_qjm(res, year=seqyears[i])
    df_tmp=collect_qjm(res_tmp, year=seqyears[i]) %>%
     dplyr::mutate(station=rep(station,dplyr::n())) %>%
     dplyr::select(station,Date, dplyr::everything())
    df=df %>%
      bind_rows(df_tmp)
  }
  return(df)
}
