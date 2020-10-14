#' Used from bh_get to get QTVAR data
#' @description This is used to get QTVAR data between two times.
#' @param station gauging station
#' @param t1 starting date formatted "\%j/\%M/\%Y \%h:\%m"
#' @param t2 Date de fin d'evenement au format "\%j/\%M/\%Y \%h:\%m"
#'
#' @return dataframe contenant le tableau produit sur la page de visualisation de la chronique de la banque hydro
#'
#' @examples
#' df_qtvar<-bh_get_qtvar("16/03/2017 00:00", "18/03/2017 23:59")
get_to_qtvar <- function (station,t1, t2)  {
  url="http://www.hydro.eaufrance.fr"
  url.procedure = paste(url,"presentation/procedure.php", sep = "/")
  t1 = as.POSIXct(t1, format = "%d/%m/%Y %H:%M", tz = "UTC")
  t2 = as.POSIXct(t2, format = "%d/%m/%Y %H:%M", tz = "UTC")
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

  res <- httr::POST(
    url.procedure,
    body = form2,
    encode = "form"#,
    #httr::verbose()
  )
  return(res)
}
