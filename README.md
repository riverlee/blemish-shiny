# Showing blemish region in the current NOM big 96 array

The belmish is detected by apt-genotype-axiom with parameter --dump-blemishes set to 'true'

## Usage

* First you upload the cel files list
* Then you upload the AxiomGT1.blemishmap.txt which is the output by apt-genotype-axiom
* After that, in the "Summary" tab, you will how many regions are blemished for each cel files
and you can select each cel file on the left to visualize the image before and after blemish in the "Details" tab.

## Start Shiny App

use 'bash run.sh' to start the shiny app with port 5001


## Technical details

* We use 'formattable' package to display the summary table. An alternative way is to use 'googleVis' package with 'gvisTable' function
* Heatmap is display using 'ggplot2' with 'geom_raster' function


## Need to improve

* Need an alternative way to display heatmaps as the current way(ggplot2) takes so so so long time
* It's nice to have 'sort' function in the current table display


 

