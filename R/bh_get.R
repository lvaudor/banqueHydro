#' Get data from banquehydro
#' @description Collect data from banquehydro stating procedure type, station code and beginning/ending times
#' @export
#' @param procedure procedure à importer : au choix pour l'instant "QTVAR","QJM" (QTVAR par défaut)
#' @param station Code de la station
#' @param t1 Date de début d'événement au format string "JJ/MM/AAAA HH:MM:SS" si procedure=QTVAR ou au format "AAAA" si procedure=QJM
#' @param t2 Date de fin d'événement au format string "JJ/MM/AAAA HH:MM:SS"si procedure=QTVAR ou au format "AAAA" si procedure=QJM
#'
#' @return dataframe contenant le tableau produit sur la page de visualisation de la chronique de la banque hydro
#'
#' @examples
#' df_qtvar<-bh_get(procedure="QTVAR",
#'                  station="Y3204010",
#'                  t1= "16/03/2017 00:00",
#'                  t2= "17/03/2017 23:59")
#'
#'
#' df_qjm <- bh_get(procedure="QJM",
#'            station="Y3204010",
#'            t1= "2005",
#'            t2= "2006",
#'            sleep=2)
bh_get <- function (procedure = "QTVAR",
                    station,
                    t1,
                    t2,
                    sleep=10) {

  url="http://www.hydro.eaufrance.fr"
  url.procedure = paste(url,"presentation/procedure.php", sep = "/")
  # Formulaire de sélection des stations
  form0<- list(
    cmd = "filtrer",
    consulte = "rechercher",
    code_station = "",
    cours_d_eau = "",
    commune = "",
    departement = "",
    bassin_hydrographique = "",
    station_en_service = "1",
    station_hydrologique = "1",
    btnValider = "Visualiser"
  )
  form0[["station[]"]] = station

  url.selection = paste(url,"selection.php", sep = "/")

  res <- POST(
    url.selection,
    body = form0, encode = "form", verbose()
  )

  # Formulaire de sélection de la procedure
  form1 <- list(
    categorie = "rechercher",
    procedure = procedure
  )
  form1[["station[]"]] =  station

  res <- POST(
    url.procedure,
    body = form1, encode = "form", verbose()
  )


  if(procedure=="QTVAR"){
      # Extraction des chroniques (répétition des interrogations)
      t1 = as.POSIXct(t1, format = "%d/%m/%Y %H:%M", tz = "UTC")
      t2 = as.POSIXct(t2, format = "%d/%m/%Y %H:%M", tz = "UTC")
      t1Old = 0
      df = data.frame(NULL)

      while(t1 < t2 & t1 > t1Old) {
        t1Old = t1
        dfi = bh_get_qtvar(t1, t2)
        if(nrow(dfi) > 0) {
          df = rbind(df, dfi)
          t1 = tail(dfi,1)$Date + 60 # Last end time + 60 seconds
        }
      }
  }
  if(procedure=="QJM"){
    df=t1 : t2 %>%
      purrr::map_df(bh_get_qjm,sleep=sleep)
  }
  return (df)
}
