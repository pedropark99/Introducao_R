library(stringr)
isbn <- "978-65-00-57872-0"
editora <- "[s.n.]"
edicao <- "4"
ano_atual <- "2022"
publi_link <- "https://pedro-faria.netlify.app/pt/publication/book/introducao_linguagem_r/"


autor <- "Pedro Duarte Faria"
titulo <- "Introdução à Linguagem R"
subtitulo <- "seus fundamentos e sua prática"
edicao_w <- sprintf("%s°", edicao)
edicao_por_extenso <- c(
  "4" = "quarta", "5" = "quinta",
  "6" = "sexta", "7" = "sétima",
  "8" = "oitava", "9" = "nona"
)


edicao_por_extenso <- edicao_por_extenso[edicao] |>
  unname() |> 
  str_to_title()

wd <- fs::path_file(fs::path_dir(getwd()))
output_format <- if (wd == 'Livro_R') 'latex' else 'html'