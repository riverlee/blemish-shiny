### Read Cel file and plot 'heatmap' like figure ###
library(affyio)
library(ggplot2)
library(reshape2)
# cel.infile = "CFD_DxB832606_11ng_SV4_NOM058_F12.CEL"
# blemish.infile = "blemish.x.y.coordinate.txt"
# 
# blemish.xy = read.table(blemish.infile)
# colnames(blemish.xy) = c("X","Y")
# 
# ## http://www.affymetrix.com/support/developer/powertools/changelog/FAQ.html

## Given probeid calculate the X Y coordinate (1-based)
ProbeidToXY <-function(probeid, num_rows = 992, num_cols = 992){
  
  ## 1 -based 
  x = (probeid - 1) %% num_rows  + 1
  y = floor((probeid -1)/num_cols) + 1
  
  c(x,y)
}
load("xy.RData")

## Read raw intensity from a cel file
get.x.y.intensity.from.cel <-function(cel.infile,num_rows = 992, num_cols = 992){
  dat = read.celfile(filename = cel.infile)
  at = dat$INTENSITY[[1]]$MEAN   ##
  cg = dat$INTENSITY[[2]]$MEAN  
  
#  xy = t(sapply(1:length(at),ProbeidToXY))
  
  intensity = data.frame(X = xy[,1],Y = xy[,2],AT = at, CG = cg )
  intensity
}

my.heatmap<-function(intensity,blemish.xy,tl,show.blemish = TRUE){
  intensity2 = melt(data = intensity,id.vars = c("X","Y"),variable.name = "Channel",value.name = "Intensity")
  #ggplot(data = intensity,aes(x = X,y = Y,color = AT)) + geom_point(shape = 20)+xlim(1,992)+ylim(1,992)
  #ggplot(data = intensity,aes(x = X,y = Y)) + geom_tile(aes(fill=AT))+xlim(1,992)+ylim(1,992)
  p = ggplot(data = intensity2,aes(x = X,y = Y)) + geom_raster(aes(fill=Intensity)) + scale_y_reverse()  + 
    scale_fill_gradient(low = 'black',high = 'white')+facet_wrap(~Channel)+ggtitle(tl)

  if(show.blemish){
    p + geom_tile(data = blemish.xy,colour = 'red')
  }else{
    p
  }
}




