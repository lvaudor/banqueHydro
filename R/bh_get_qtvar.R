#' Used from bh_get to get QTVAR data
#' @description This is used to get QTVAR data between two times.
#' @param t1 Date de début d'événement au format "%j/%M/%Y %h:%m"
#' @param t2 Date de fin d'événement au format "%j/%M/%Y %h:%m"
#'
#' @return dataframe contenant le tableau produit sur la page de visualisation de la chronique de la banque hydro
#'
#' @examples
#' df_qtvar<-bh_get_qtvar("16/03/2017 00:00", "05/04/2017 23:59")
bh_get_qtvar <- function (t1, t2)  {
  url="http://www.hydro.eaufrance.fr"
  url.procedure = paste(url,"presentation/procedure.php", sep = "/")
  # Formulaire de sélection de la date
  form2 <- list(
    procedure = "QTVAR",
    affichage = 2,
    echelle = 1,
    date1 = format(t1, "%d/%m/%Y"),
    heure1 = format(t1, "%H:%M"),
    date2 = format(t2, "%d/%m/%Y"),
    heure2 = format(t2, "%H:%M"),
    precision = "00",
    btnValider = "Valider"
  )

  res <- POST(
    url.procedure,
    body = form2,
    encode = "form",
    verbose()
  )

  #Check if no data
  pageToRead=content(res, "text", encoding = "iso-8859-1")
  #Ici on regarde sur la page si un message d'erreur est affiché :
  urlLines=0
  urlLines = c(urlLines,grep("Pas\\sde\\sdonnées\\sdisponibles", pageToRead))
  urlLines = c(urlLines,grep("Aucune\\sdonnée\\sdisponible", pageToRead))
  #message("urlLines=",urlLines)

  df = data.frame(NULL)
  if (sum(urlLines)==0){
    # On récupère le dataframe du 3ème tableau de la page
    df = readHTMLTable(
      content(res, type="text/plain", encoding="cp1252"),
      stringsAsFactors = FALSE,
      which = 3
    )
    df[,"Date"] = as.POSIXct(df[,"Date"], format = "%d/%m/%Y %H:%M", tz = "UTC")
  }
  df=df %>%
    dplyr::mutate(Q=`Q (m3/s)`) %>%
    dplyr::mutate(Q=as.numeric(Q)) %>%
    dplyr::mutate(Date=lubridate::ymd_hms(Date))
    dplyr::select(Date,Q,V,C) %>%
    dplyr::as_tibble()
  return(df)
}
