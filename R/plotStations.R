#' Plot k-nearest stations
#'
#' This function will plot each city's reference point, along with the
#' k-nearest stations to that point.
#'
#' @param city.list City of list of Cities. The format should be as follows: "City, State", or "City, Country"
#' @param station.list Full list of ISD stations included in the package
#' @param k The number of stations to return
#' @return This will produce single, or multple plots for each city
#' @export


plotStations <- function(city.list, station.list, k)
{
  kns <- kNStations(city.list, station.list, k)
  nc <- length(city.list)
  plots <- list()
  for (i in 1:nc)
  {
    map <- suppressMessages(get_map(location = city.list[i], zoom = 10))
    p1 <- suppressMessages(ggmap(map) +
                             geom_point(aes(x = LON, y = LAT),
                                        data = kns[kns$city==city.list[i],],
                                        colour="red", size=7, alpha=.5) +
                             geom_text(aes(x = LON, y = LAT, label=rank),
                                       data = kns[kns$city==city.list[i],]) +
                             geom_point(aes(x = lon, y = lat),
                                        data = geocode(city.list[i]),
                                        colour="black", size=7, alpha=.5))
    plots[[i]] <- p1
  }
  if (nc == 1) plot(p1) else multiplot(plotlist = plots, cols = round(sqrt(nc)))
}