#' @param procedure procedure à importer : au choix pour l'instant "QTVAR","QJM" (QTVAR par défaut)
#' @param station station code
#' @return


get_to_procedure=function(procedure,station){
    url="http://www.hydro.eaufrance.fr"
    url.procedure = paste(url,"presentation/procedure.php", sep = "/")
    form1 <- list(
      categorie = "rechercher",
      procedure = procedure
    )
    form1[["station[]"]] =  station
    res <- POST(
      url.procedure,
      body = form1, encode = "form", verbose()
    )
return(res)
}
