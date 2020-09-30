#' Used from bh_get to get QJM data
#' @description This is used from bh_get to get QJM data for a whole year
#' @param year the year for which the data is collected
#' @param sleep how much time the system waits between two GET requests (in seconds)
#' @return QJM for year `year`
#'
#' @examples
#' df_ts<-bh_get_qjm(year="2018", sleep=1)
bh_get_qjm <- function (year,sleep)  {
  url="http://www.hydro.eaufrance.fr"
  url.procedure = paste(url,"presentation/procedure.php", sep = "/")
  print(year)
  Sys.sleep(sleep)
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
  pageToRead=content(res, "text", encoding = "ISO-8859-1", type="html")
  doc=xml2::read_html(pageToRead)

  get_data_month=function(table_month,Month){
    table_month %>%
      html_nodes("tr") %>%
      .[1] %>%
      html_nodes("table") %>%
      purrr::map_df(html_table) %>%
      mutate(Month=rep(Month,length(X1)),
             Day=X1,
             Qj=X2,
             Val=X3)
  }

   data_year=doc %>%
    html_nodes(".gauche3") %>%
    html_node("table") %>%
    .[3:14] %>%
    purrr::map2_df(1:12,get_data_month) %>%
    mutate(Year=rep(year,n())) %>%
    mutate(Date=lubridate::make_date(Year,Month,Day)) %>%
    select(Date,Qj,Val) %>%
    mutate(Val=case_when(Val==""~NA_character_,
                         Val!=""~Val))
  return(data_year)
}
