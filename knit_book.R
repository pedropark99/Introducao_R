library(bookdown)
library(bslib)
library(fs)

render_book(output_format = "bookdown::bs4_book")


arquivos <- dir_ls("_book/")
nomes <- path_file(arquivos)

dir_create("docs")


fs::file_move(
  path = arquivos,
  new_path = paste0("docs/", nomes)
)


dir_delete("_book/")