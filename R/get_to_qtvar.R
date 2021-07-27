#' get_to_qtvar from webpage
#' @description This function is used by bh_get_qtvar() to get page of results for QTVAR
#' @param res page
#' @param t1 starting time formatted as "\%j/\%M/\%Y \%h:\%m"
#' @param t2 ending time formatted as "\%j/\%M/\%Y \%h:\%m"
#' @return page with dataframe of qtvar for station between t1 and t2 as visualized on banquehydro
get_to_qtvar <- function (res,t1, t2)  {
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
