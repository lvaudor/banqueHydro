# banqueHydro

This package uses the banque hydro website to collect **historic discharge data** from **gauging stations throughout France**.

The website providing the data and documentation is [http://www.hydro.eaufrance.fr/](http://www.hydro.eaufrance.fr/).

Although there is an [API to collect real-time discharge data](https://hubeau.eaufrance.fr/page/api-hydrometrie), the historic data is only downloadable for now as unconviently-formatted .csv files, and for registered users only. 

The `banqueHydro` package aims at providing this historic discharge data in a more convenient, API-like way, although it relies on web-scraping techniques. Please be aware that web-scraping is a resource-consuming process and that one should refrain from submitting very demanding or unnecessary/redundant queries. 

Install it through:

```{r}
remotes::install_github("lvaudor/banqueHydro")
```

Documentation

You can access the documentation regarding package riverbed on [this site](http://perso.ens-lyon.fr/lise.vaudor/Rpackages/banqueHydro/)


