#### import data from matlab ####

data = R.matlab::readMat("data/scenarioA_processed.mat")

t = data$t[1,]
sl = data$sl[1,]

dist_from_shore  = paste(data$y.positions[1,]/10, "km", sep = "") # distance from shore in km

h_mat = data$h.mat
colnames(h_mat) = dist_from_shore
wd_mat = data$wd.mat
colnames(wd_mat) = dist_from_shore

strat_col = list()
for (i in seq_along(dist_from_shore)){
  strat_col[[dist_from_shore[i]]] = list("bed_thickness_m" = data$facies.info[1,i][[1]][[1]][[2]][[1]][1,],
                                         "facies_code" = data$facies.info[1,i][[1]][[1]][[1]][[1]][1,])
}

scenarioA = list("t_myr" = t,
                 "sl_m" = sl,
                 "dist_from_shore" = dist_from_shore,
                 "h_m" = h_mat,
                 "wd_m" = wd_mat,
                 "strat_col" = strat_col)
save(scenarioA, file = "data/scenarioA.Rdata")


