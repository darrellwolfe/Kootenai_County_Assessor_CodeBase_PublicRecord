install.packages("languageserver")
install.packages("rmarkdown")
install.packages("pandoc")

# installing/loading the package:
if(!require(installr)) {
  install.packages("installr"); 
  require(installr)
} #load / install+load installr


# using the package:
updateR()


# C:\Users\dwolfe\AppData\Local\Programs\R\R-4.4.1
# "r.rterm.windows": "C:\\Users\\dwolfe\\AppData\\Local\\Programs\\R\\R-4.4.1\\bin\\R.exe"



## Not run: 
library(rmarkdown)
if (pandoc_available())
  cat("pandoc", as.character(pandoc_version()), "is available!\n")
if (pandoc_available("1.12.3"))
  cat("required version of pandoc is available!\n")
## End(Not run)