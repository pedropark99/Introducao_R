library(bookdown)
library(bslib)
library(fs)

render_book(output_format = "bookdown::bs4_book")



# render_book(output_format = "epub_book")
# 
# fs::file_move(
# fs::file_move(
#   "docs/Introducao_R.epub",
#   new_path = "../Livro_R/Introducao_R.epub"
# )
