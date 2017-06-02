library(shiny)
library(dplyr)
library(googleVis)
library(ggplot2)
library(readr)
library(formattable)
### https://www.youtube.com/watch?v=HPZSunrSo5M
options(shiny.maxRequestSize=100*1024^2)  ## upload max file 100M
source("heatmap.R")
source("multiplot.R")
max_plots =  2

shinyServer(function(input,output){
  data <- reactive({
    cel.infile = input$cel.infile
    blemish.infile = input$blemish.infile
    
    if(is.null(cel.infile) || is.null(blemish.infile)){return()}
    
    ## Read the cel file list 
    cel.files = scan(cel.infile$datapath,what="",skip=1)
    

    ## Read blemish table 
    #blemish.dat = read.table(blemish.infile$datapath,sep = "\t",header = T)
    blemish.dat = read_delim(blemish.infile$datapath,delim="\t")
    list(cel.files = cel.files,blemish.dat=blemish.dat)
  })

  var<-reactive({
        a = data()$cel.files
        names(a) = basename(a)
        a
    })
 
 ## selectInput
 output$vcel<-renderUI({
    if(is.null(data())){return()}
    selectInput("selectedCel","Select a cel file to see the blemish",choices=var())
 })
 
 ## Summary tab
 output$summary_notrun<-renderGvis({
    if(is.null(data())){return()}
    
    dd = data()
    blemish.dat=dd$blemish.dat
    cel.files = dd$cel

    ## For each cel file, get how many probes are in the blemish region        
    d = group_by(blemish.dat,cel_idx) %>% summarize(n=n())
    d$celfile=basename(cel.files[ d$cel_idx+1])
    d$`blemish_pct(%)` = sprintf("%.2f",d$n/(992*992)*100)
    d2 = select(d,cel_idx,celfile,blemish_probes=n,`blemish_pct(%)`)
    gvisTable(d2)
 })
 output$summary<-renderFormattable({
    if(is.null(data())){return()}
    
    dd = data()
    blemish.dat=dd$blemish.dat
    cel.files = dd$cel

    ## For each cel file, get how many probes are in the blemish region        
    d = group_by(blemish.dat,cel_idx) %>% summarize(n=n())
    d$celfile=basename(cel.files[ d$cel_idx+1])
    d$`blemish_pct(%)` = sprintf("%.2f",d$n/(992*992)*100)
    d2 = select(d,cel_idx,celfile,blemish_probes=n,`blemish_pct(%)`)
    #gvisTable(d2)
    formattable(d2,list(
                     area(col=c(`blemish_pct(%)`))~normalize_bar("pink",0.2),
                     #area(col=c(blemish_probes))~normalize_bar("green",0.2)   
                     blemish_probes = color_tile("white","orange")
                      ))
 })

## Output seleted figures ### 
  output$fig<-renderPlot({
    if(is.null(data())){return()}

    dd = data()
    blemish.dat=dd$blemish.dat
    cel.files = dd$cel
    
    selectedCel = input$selectedCel 
    cat(selectedCel,"\n")
    i = match(selectedCel,cel.files)
    intensity = get.x.y.intensity.from.cel(cel.infile = cel.files[i])
    blemish.xy = filter(blemish.dat,cel_idx==i-1)%>%select(X=x,Y=y)
    p1=my.heatmap(intensity = intensity,blemish.xy = blemish.xy,tl = paste0(basename(cel.files[i]),"- Not showing blemish"),show.blemish=FALSE) 
    p2=my.heatmap(intensity = intensity,blemish.xy = blemish.xy,tl = paste0(basename(cel.files[i]),"- Showing blemish in Red")) 
    multiplot(p1,p2)

 })
})
