stdh_cast_substring = function(x, to = "MULTILINESTRING") {
  ggg = st_geometry(x)
  
  if (!unique(st_geometry_type(ggg)) %in% c("POLYGON", "LINESTRING")) {
    stop("Input should be  LINESTRING or POLYGON")
  }
  for (k in 1:length(st_geometry(ggg))) {
    sub = ggg[k]
    geom = lapply(1:(length(st_coordinates(sub)[, 1]) - 1),
                  function(i)
                    rbind(
                      as.numeric(st_coordinates(sub)[i, 1:2]),
                      as.numeric(st_coordinates(sub)[i + 1, 1:2])
                    )) %>%
      st_multilinestring() %>%
      st_sfc()
    
    if (k == 1) {
      endgeom = geom
    }
    else {
      endgeom = rbind(endgeom, geom)
    }
  }
  endgeom = endgeom %>% st_sfc(crs = st_crs(x))
  if (class(x)[1] == "sf") {
    endgeom = st_set_geometry(x, endgeom)
  }
  
  if (to == "LINESTRING") {
    endgeom = endgeom %>% st_cast("LINESTRING")
  }
  return(endgeom)
}