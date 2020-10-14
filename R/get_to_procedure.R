#' get_to_procdure
#' @param procedure procedure: import either "QTVAR" or "QJM"
#' @param station gauging station code
#' @return page corresponding to procedure and station


get_to_procedure=function(procedure,station){
    url="http://www.hydro.eaufrance.fr"
    url.procedure = paste(url,"presentation/procedure.php", sep = "/")
    form1 <- list(
      categorie = "rechercher",
      procedure = procedure
    )
    form1[["station[]"]] =  station
    res <- httr::POST(
      url.procedure,
      body = form1,
      encode = "form"#,
      #httr::verbose()
    )
return(res)
}
