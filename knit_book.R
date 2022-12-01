library(bookdown)
library(bslib)
library(yaml)
library(fs)

render_book(output_format = "bookdown::bs4_book")



# render_book(output_format = "epub_book")
# 
# fs::file_move(
#   "docs/Introducao_R.epub",
#   new_path = "../Livro_R/Introducao_R.epub"
# )


# arquivos_epub <- read_yaml("_bookdown.yml")$rmd_files$epub
# 
# arquivo <- map(arquivos_epub, read_file) |>
#   unlist() |> 
#   str_c(collapse = "\n")
# 
# write_file(arquivo, "Introducao_R.Rmd")
# 
# knitr::knit("Introducao_R.Rmd")
# 
# 
# cmd <- '"C:/Program Files/RStudio/bin/quarto/bin/tools/pandoc" +RTS -K512m -RTS Introducao_R.knit.md --to epub3 --from markdown --output Introducao_R.epub --lua-filter "C:\\Users\\pedro\\AppData\\Local\\R\\win-library\\4.2\\bookdown\\rmarkdown\\lua\\custom-environment.lua" --metadata-file "C:\\Users\\pedro\\AppData\\Local\\Temp\\RtmpqW1WVD\\file2a5452922319" --number-sections --citeproc --mathml'
# 
# system(cmd)
