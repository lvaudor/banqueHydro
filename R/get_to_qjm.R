#' get_to_qjm webpage
#' @description This function is used by bh_get_qjm() to get page of results for QJM
#' @param res page
#' @param year year for which data should be collected
#' @return page with dataframe of QJM for specified year as visualised on banquehydro

get_to_qjm=function(res,year){
    url="http://www.hydro.eaufrance.fr"
    url.procedure = paste(url,"presentation/procedure.php", sep = "/")
    # Formulaire de sélection de la date
    form2 <- list(
      procedure="QJM",
      debut_an=year,
      fin_an=year,
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
