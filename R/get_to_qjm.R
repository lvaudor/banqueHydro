#'#' @description This is used to get QTVAR data between two times.
#' @param year

get_to_qjm=function(year){
    url="http://www.hydro.eaufrance.fr"
    url.procedure = paste(url,"presentation/procedure.php", sep = "/")
    # Formulaire de sélection de la date
    form2 <- list(
      procedure="QJM",
      debut_an=year,
      fin_an=year,
      btnValider = "Valider"
    )
    res <- POST(
      url.procedure,
      body = form2,
      encode = "form",
      verbose()
    )
    return(res)
}