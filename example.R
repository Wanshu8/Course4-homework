install.packages("shiny")
install.packages("readxl")
install.packages("DT")
install.packages("wordcloud2")
install.packages("stopwords")



library(readxl)

dfmv<-readxl::read_excel("movies.xlsx",1)

css_content <- "
#sidebar {
  background-color: purple;
  color: white;
}

#sidebar .form-group input, 
#sidebar .form-group select, 
#sidebar .form-group .slider {
  background-color: purple;
  color: white;
  border-color: white;
}

#sidebar .irs-bar,
#sidebar .irs-bar-edge,
#sidebar .irs-single,
#sidebar .irs-grid-pol,
#sidebar .irs-handle {
  background-color: white;
  border-color: white;
}

#sidebar .irs-handle:hover {
  background-color: #f0f0f0;
  border-color: #f0f0f0;
}

#sidebar .irs-from,
#sidebar .irs-to,
#sidebar .irs-single {
  color: purple;
}

#sidebar .irs-line,
#sidebar .irs-line-left,
#sidebar .irs-line-right {
  background-color: white;
  border-color: white;
}

#sidebar .form-group label {
  color: white;
}
"

# Write the CSS content to a file named "styles.css"
writeLines(css_content, "styles.css")



