#' @param station station code
#' @return


get_to_station <- function (station) {
  url="http://www.hydro.eaufrance.fr"
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
  res <- httr::POST(
    url.selection,
    body = form0,
    encode = "form"#,
    #httr::verbose()
  )
  return(res)
}
