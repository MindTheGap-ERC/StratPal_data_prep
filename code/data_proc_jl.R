height_data = read.csv("data/platform_adm.csv")
wd_data = read.csv("data/platform_wd.csv")

t = height_data$time..Myr.

period1 = 1
period2 = 0.112
amplitude1 = 20
amplitude2 = 2

sl = amplitude1 * cos(2* pi * t / period1) + amplitude2 * cos(2 * pi * t / period2)

dist_from_shore = paste0(seq(2, 12, by = 2), "km")

h = matrix(NA,
           nrow = length(t),
           ncol = length(dist_from_shore),
           dimnames = list("t" = NULL,
                           "dist" = dist_from_shore))

wd = matrix(NA,
            nrow = length(t),
            ncol = length(dist_from_shore),
            dimnames = list("t" = NULL,
                            "dist" = dist_from_shore))

for (i in seq_along(dist_from_shore)){
  height_name = paste0("adm_", i, "..m.")
  wd_name = paste0("wd_", i, "..m.")
  h[,dist_from_shore[i]] = height_data[,height_name] 
  wd[, dist_from_shore[i]] = pmax(wd_data[,wd_name], 0)
}

scenarioA = list("t_myr" = t,
                 "sl_m" = sl,
                 "dist_from_shore" = dist_from_shore,
                 "h_m" = h,
                 "wd_m" = wd)

save(scenarioA, file = "data/scenarioA.rda")