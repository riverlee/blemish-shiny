library(shiny)
options(shiny.maxRequestSize=100*1024^2) 
shinyUI(
  fluidPage(
    titlePanel(div("Blemish Summary for NOM (big 96 format)", img(src="logo.png"))),
    sidebarLayout(
      sidebarPanel(
          helpText("This is a file lists the cel files on your server when you run",
                   code('apt-genotype-axiom'),
                   ".The first row is the header."),
          fileInput("cel.infile","Upload the CEL file list"),
          tags$hr(),

          helpText("This is the output file after you run ",
                    code("apt-genotype-axiom"),
                    "with parameter ",
                    code("--dump-blemishes"),"setting to",
                    code("true"), ".The output filename is ",
                    code("AxiomGT1.blemishmap.txt")),
          fileInput("blemish.infile","Upload the blemish file (AxiomGT1.blemishmap.txt)"),


          ## This ui is
          uiOutput("vcel"), ##vcel is comming from renderUI in server.R

          p("=========================================="),
          helpText(strong("Below shows how to set the parameter and how does the output file",
                         code("AxiomGT1.blemishmap.txt"),"looks like:")),
          tags$img(src="ex.png",width="540",heigh="317")
        ),
      mainPanel( 
          tabsetPanel(
              tabPanel("Summary",tableOutput("summary")),
              #tabPanel("Details",uiOutput("plots"))
              tabPanel("Details",plotOutput("fig",height=800,width=800))
            )
        )
      ),
    hr(),
    div(class="footer",p("Developed with Shiny by Jiang Li"),align='center')
    )
  )
