# banqueHydro

This package uses the banque hydro website to collect discharge data from gauging stations throughout France.
It uses scraping techniques to collect QJM and QTVAR data.

Install it through:

```{r}
remotes::install_github("lvaudor/banqueHydro")
```

The two main functions are:

- bh_get_qtvar() (measures of discharge at varying time intervals)
- bh_get_qjm() (mean daily discharge)

The can be used this way:

```{r}
df_qtvar <- bh_get_qtvar(station="V2942010",
                         t1="05/02/2007 15:00",
                         t2="08/04/2007 18:00")
```

```{r}
df_qjm <- bh_get_qjm(station="V2942010",
                     t1=2008,
                     t2=2009)
```

This can be quite a long process (a few minutes for each of the commands above) so make sure to save the resulting table!



