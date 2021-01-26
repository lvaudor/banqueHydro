#' Get QTVAR data for a station between two times t1 and t2
#' @export
#' @description This is used to get QTVAR data between two times.
#' @param station station code
#' @param t1 starting time formatted as "\%d/\%M/\%Y \%h:\%m"
#' @param t2 ending time formatted as "\%d/\%M/\%Y \%h:\%m"
#' @param verbose whether to progressively print what data is being collected. Defaults to TRUE.
#' @param sleep time to wait between two successive GET requests. Defaults to 30 seconds.
#' @return tibble with QTVAR data
#' @examples
#' df_qtvar<-bh_get_qtvar(station="V2942010",
#'                        t1="05/02/2007 15:00",
#'                        t2="08/04/2009 18:00")
bh_get_qtvar <- function (station,t1,t2, verbose=TRUE, sleep=30)  {
  t1=lubridate::dmy_hm(t1)
  t2=lubridate::dmy_hm(t2)
  diffyears=as.numeric(difftime(t2,t1,units="days")/365.25)
  seqdates=c(seq(t1,t2, by = '1 year'),t2) %>%
    banqueHydro:::format_time_for_qtvar() %>%
    unique()
  tibdates=tibble::tibble(t1=seqdates,
                          t2=dplyr::lead(seqdates,1)) %>%
    na.omit()
  df=NULL
  for (i in 1:nrow(tibdates)){
    Sys.sleep(10)
    t1_tmp=tibdates$t1[i]
    t2_tmp=tibdates$t2[i]
    if(verbose==TRUE){print(paste0("Collecting QTVAR data between times t1=",
                                  t1_tmp," and t2=",t2_tmp,"."))}

    res_tmp=banqueHydro:::get_to_station(station=station)

    Sys.sleep(10)
    res_tmp=res_tmp %>%
      banqueHydro:::get_to_procedure(procedure="QTVAR",station=station)

    Sys.sleep(10)
    res_tmp=res_tmp %>%
      banqueHydro:::get_to_qtvar(t1=t1_tmp,t2=t2_tmp)

    Sys.sleep(10)
    df_tmp=banqueHydro:::collect_qtvar(res_tmp) %>%
      dplyr::mutate(station=rep(station,dplyr::n())) %>%
      dplyr::select(station,Time, dplyr::everything())
    df=df %>%
      dplyr::bind_rows(df_tmp)
  }
  df=unique(df)
  return(df)
}
