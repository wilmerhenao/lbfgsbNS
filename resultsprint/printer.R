install.packages('ggplot2')
library(ggplot2)
install.packages('rJava')
install.packages('lattice')
library(lattice)
install.packages('latticeExtra')
library(latticeExtra)
install.packages('reshape')
library(reshape)

install.packages('rgl')
library(rgl)


install.packages('xlsx')
library(xlsx)

a <- read.csv("typicalDescent.csv")
plot(tail(a[, c(1,3)], 27), main = "Convergence for Modified Rosenbrock Function", col = "blue", type = "h")
?plot

mnpn <- read.csv("../outputBreak/outputmnp.csv", sep="\t")
names(mnpn)
mnpn <- mnpn[, c("m", "p", "Niter")]
my.mnpn <- cast(mnpn, m ~ p)

nr.of.iters <- as.matrix(my.mnpn)

cloud(nr.of.iters, panel.3d.cloud = panel.3dbars, xbase = 0.4, ybase = 0.4,
      zlim = c(0, max(nr.of.iters)),
      scales = list(arrows = FALSE, just = "right"), xlab = NULL, ylab = NULL,
      col.facet = level.colors(nr.of.iters, at = do.breaks(range(nr.of.iters), 20),
          col.regions = heat.colors, colors = TRUE),
      #colorkey = list(col = terrain.colors, at = do.breaks(range(nr.of.iters), 20)),
      screen = list(z = 40, x = -60), main = 'Number of Iterations changing p and m')

