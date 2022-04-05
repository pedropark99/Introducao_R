pckgs <- c("yaml", "tidyverse", "magrittr", "fs", "glue", "knitr", "bookdown", "rmarkdown")

load_packages <- function (...) {
  for (i in c(...)) {
    library(i, character.only = TRUE)
  }
}

load_packages(pckgs)


arquivos_rmds <- list.files(
  "C:/Users/Pedro/Documents/Projeto curso R/Livro_R/Capítulos/",
  pattern = "*.Rmd", 
  full.names = TRUE
)



exerc_rmds <- list.files(
  "C:/Users/Pedro/Documents/Projeto curso R/Livro_R/Exercícios/",
  pattern = "*.Rmd", 
  full.names = TRUE
)


exerc_rmds <- str_subset(exerc_rmds, "(.*)/exec_cap([0-9]+)[.]Rmd")


resp_rmd <- "C:/Users/Pedro/Documents/Projeto curso R/Livro_R/Exercícios/respostas_complete.md"


read_rmds <- function(path){
  text <- read_file(path)
  return(str_split(text, "\n") %>% unlist())
}





### Descobrindo linhas de código e/ou verbatim

identify_chunk_code <- function(text){
  
  pattern_start <- "^[\t ]*```[{](.+)[}]|^\\\\begin[{]"
  pattern_end <- "^[\t ]*```( *)$|^\\\\end[{]"
  
  starts <- stringr::str_which(text, pattern_start)
  
  if (length(starts) == 0) {
    cli::cli_alert_info("Not a single chunk start was found.")
    return(integer())
  }
  starts <- sort(starts)
  
  ends <- stringr::str_which(text, pattern_end)
  ends <- sort(ends)
  
  true_ends <- vector("integer", length = length(starts))
  for (i in seq_along(starts)) {
    possibilities <- ends[ends > starts[i]]
    true_ends[i] <- possibilities[1]
  }
  
  dif <- true_ends - starts
  chunk_lines <- sequence.default(dif + 1L, from = starts, by = 1L)
  
  return(chunk_lines)
}


# lines <- identify_chunk_code(read_rmds(arquivos_rmds[3]))
# writeLines(read_rmds(arquivos_rmds[3])[lines])



### Corrigindo citações

fix_citations <- function(text){
  arquivo <- text
  linhas_para_ignorar <- identify_chunk_code(arquivo)
  linhas_para_pesquisar <- seq_along(arquivo)
  linhas_para_pesquisar <- linhas_para_pesquisar[
    ! (linhas_para_pesquisar %in% linhas_para_ignorar)
  ]
  
  arquivo[linhas_para_pesquisar] <- str_replace_all(
    arquivo[linhas_para_pesquisar],
    "\\\\cite\\{([a-zA-Z0-9_]+)\\}",
    "[@\\1]"
  )
  
  arquivo[linhas_para_pesquisar] <- str_replace_all(
    arquivo[linhas_para_pesquisar],
    "\\\\citeonline\\{([a-zA-Z0-9_]+)\\}",
    "@\\1"
  )
  
  arquivo[linhas_para_pesquisar] <- str_replace_all(
    arquivo[linhas_para_pesquisar],
    "\\\\cite\\[([p. ]+)([0-9]+)\\]\\{([a-zA-Z0-9_]+)\\}",
    "[@\\3, p \\2]"
  )
  
  arquivo[linhas_para_pesquisar] <- str_replace_all(
    arquivo[linhas_para_pesquisar],
    "\\\\citeonline\\[([p. ]+)([0-9]+)\\]\\{([a-zA-Z0-9_]+)\\}",
    "@\\3 [, p \\2]"
  )
  
  arquivo[linhas_para_pesquisar] <- str_replace(
    arquivo[linhas_para_pesquisar],
    "\\\\bibliography\\{([a-zA-Z]+)\\}",
    "# Referências {-}"
  )
  
  return(arquivo)
}



#arquivo <- fix_citations(arquivo)




### Primeiro realizar as transformações para os casos de \cite{},
### em seguida, realizar para os casos de \citeonline{},
### Complica demais fazer os dois ao mesmo tempo




replace_mult_citations <- function(text, regex_backref, regex_inside){
  
  ids <- str_which(text, regex_backref)
  linhas_com_mult_cit <- str_subset(text, regex_backref)
  chaves <- str_extract_all(text[ids], regex_backref)
  
  chaves <- map(
    chaves,
    function(x){
      x |>
        str_replace_all(",", ";") |>
        str_replace_all("([a-zA-Z0-9_]+)", "@\\1") |>
        (\(y) str_c("[", y, "]", sep = ""))()
    }
  )
  
  
  linhas_com_mult_cit <- str_replace_all(linhas_com_mult_cit, regex_inside, "%s")
  
  for (i in seq_along(linhas_com_mult_cit)) {
    
    args <- c( list(linhas_com_mult_cit[[i]]), as.list(chaves[[i]]) )
    
    # print(i)
    # print(str(args))
    # print(args)
    
    linhas_com_mult_cit[[i]] <- do.call(
      sprintf,
      args
    )
  }
  
  text[ids] <- linhas_com_mult_cit
  
  return(text)
}



estilos_inside <- c(
  "\\\\citeonline\\{([a-zA-Z0-9_ ,]+)\\}",
  "\\\\cite\\{([a-zA-Z0-9_ ,]+)\\}"
)

estilos_backref <- c(
  "(?<=\\\\citeonline\\{)([a-zA-Z0-9_ ,]+)(?=\\})",
  "(?<=\\\\cite\\{)([a-zA-Z0-9_ ,]+)(?=\\})"
)



# for(j in 1:2){
#   arquivo <- replace_mult_citations(arquivo, estilos_backref[j], estilos_inside[j])  
# }









### Eliminando comandos comuns do Latex

fix_latex_cmds <- function(input){
  output <- input
  output <- str_replace_all(
    output,
    "(?:\\\\)?\\\\texttt\\{([- a-zA-Z0-9_ '\"\\(\\).,]+)\\}",
    "`\\1`"
  )
  output <- str_replace_all(
    output,
    "(?:\\\\)?\\\\textit\\{([- a-zA-Z0-9_ '\"\\(\\).,]+)\\}",
    "*\\1*"
  )
  output <- str_replace_all(
    output,
    "(?:\\\\)?\\\\textbf\\{([- a-zA-Z0-9_ '\"\\(\\).,]+)\\}",
    "**\\1**"
  )
  output <- str_replace_all(
    output,
    "(?:\\\\)?\\\\textdegree\\{\\}",
    "°"
  )
  
  
  return(output)
}

#arquivo <- fix_latex_cmds(arquivo)
#arquivo <- fix_latex_cmds(arquivo)






#### Substituindo Verbatins por code blocks

fix_verbatim <- function(input){
  output <- input
  output <- str_replace(
    output,
    "\\\\(begin|end)\\{([Vv]erbatim)\\}(\\[fontsize( )?=( )?\\\\small\\])?",
    "```"
  )
  
  return(output)
}








#### Substituir environment de center por HTML Tags

fix_begin_center <- function(input){
  output <- input
  output <- str_replace(
    output,
    "\\\\begin\\{center\\}",
    "<center>"
  )
  output <- str_replace(
    output,
    "\\\\end\\{center\\}",
    "</center>"
  )
  
  return(output)
}



#### Corrigindo capítulos

fix_chapter <- function(text){
  text <- str_replace(
    text,
    "\\\\chapter\\{(.+)\\}",
    "# \\1"
  )
  
  text <- str_replace(
    text,
    "\\\\appendix",
    "# (APPENDIX) Apêndices {-}"
  )
  
  text <- str_replace(
    text,
    "\\\\part\\{(.+)\\}",
    "# (PART) \\1 {-}"
  )
  
  return(text)
} 



### Corrigindo caption de tabelas
# A maior parte das tabelas do livro são 
# incluídas através de imagens. Caso esse
# ajuste não seja feito, essas imagens vão ser interpretadas
# como figuras (e não tabelas) do livro.

lista_tabelas <- c(
  "subsetting_table2?", "operadores_matematicos",
  "tab_operadores", "tab_codigos_format_date(time)?"
)

lista_tabelas <- str_c("Figuras/", lista_tabelas)


table_index <- 1


fix_tables_caption <- function(text){
  text <- text
  figs_pattern <- str_c(lista_tabelas, collapse = "|")
  indexes <- str_which(text, figs_pattern)
  figs_names <- str_extract(text[indexes], figs_pattern)
  figs_names <- str_c(figs_names, ".png")

  figs_captions <- str_replace(
    text[indexes - 1],
    "(.+)fig.cap( ?)=( ?)[\"']([-a-zA-Záéíóúàèìòùçãõ_` ]+)[\"'](.+)",
    "\\4"
  )
  ### Apagar qualquer final de linha que por ventura permanecer
  figs_captions <- str_replace(figs_captions, "[\r\n]", "")
  
  indexes <- map(indexes, function(i) seq.int(from = i - 1, to = i + 1))
  
  for(i in seq_along(indexes)){
    ind <- indexes[[i]]
    tab_name <- figs_names[i]
    tab_caption <- figs_captions[i]
    text[ind] <- "\n"
    text[ind[1]] <- build_markdown_table(tab_name, tab_caption)
  }
  
  return(text)
}


build_markdown_table <- function(fig_name, caption){
  tabs <- c(
    "|  <!-- -->   |", "| :------------ |",
    "| ![](%s) |", "Table: (\\#tab:%s) %s"
  )
  
  tabs <- str_c(tabs, collapse = "\n")
  tab_label <- sprintf("label%s", table_index)
  tabs <- sprintf(tabs, fig_name, tab_label, caption)
  table_index <<- table_index + 1
  
  return(tabs)
}

build_markdown_table("Teste.png", "Quem")
# arquivo <- read_rmds(arquivos_rmds[3])
# a <- fix_tables_caption(arquivo)



### Corrigindo imagens do Console no Capítulo "Noções Básicas"

# medidas <- tibble(
#   inicio = str_which(arquivo, pattern = "\\\\begin[{}]figure[{}]"),
#   fim = str_which(arquivo, pattern = "\\\\end[{}]figure[{}]"),
#   comprimento = fim - inicio
# )
# 
# 
# fig_console_inicio <- medidas$inicio[1]
# fig_console_fim <- medidas$fim[1]
# fig_console_range <- seq.default(
#   from = fig_console_inicio, to = fig_console_fim,
#   by = 1
# )
# 
# a_substituir <- arquivo[fig_console_range]
# n <- length(a_substituir) - 1
# if(n %% 2 == 0){
#   n_rep <- n / 2
#   reps <- rep("\n", times = n_rep)
#   substituicao <- c(
#     reps,
#     "\n```{r, echo = FALSE, fig.cap = 'Consoles no R padrão (à esquerda) e no RStudio (à direita)'}\nknitr::includegraphics(c('Figuras/r_console.png', 'Figuras/rstudio_console.png'))\n```\n",
#     reps
#   )
# } else {
#   n_rep <- floor(n / 2)
#   rest <- n - n_rep
#   substituicao <- c(
#     rep("\n", times = n_rep),
#     "\n```{r, echo = FALSE, fig.cap = 'Consoles no R padrão (à esquerda) e no RStudio (à direita)'}\nknitr::include_graphics(c('Figuras/r_console.png', 'Figuras/rstudio_console.png'))\n```\n",
#     rep("\n", times = rest)
#   )
# }
# 
# arquivo[fig_console_range] <- substituicao


fix_image_files <- function(text){
  str_replace(
    text,
    "include_graphics\\(['\"]Figuras/([a-zA-Z0-9_-]+)([.]pdf)['\"]\\)",
    "include_graphics(\"Figuras/\\1.png\")"
  )
}


fix_exerc_tex_file <- function(text){
  text <- str_replace(
    text,
    "(Exercícios/exec_cap[1-9][0-9]?)[.]tex",
    "\\1.Rmd"
  )
  
  return(text)
}










for(i in seq_along(arquivos_rmds)){
  path_rmd <- arquivos_rmds[i]
  arquivo <- read_rmds(path_rmd)
  
  arquivo <- fix_citations(arquivo)
  arquivo <- fix_citations(arquivo)
  
  for(j in 1:2){
    arquivo <- replace_mult_citations(arquivo, estilos_backref[j], estilos_inside[j])
  }
  
  arquivo <- fix_latex_cmds(arquivo)
  arquivo <- fix_verbatim(arquivo)
  arquivo <- fix_begin_center(arquivo)
  arquivo <- fix_tables_caption(arquivo)
  arquivo <- fix_chapter(arquivo)
  arquivo <- fix_image_files(arquivo)
  arquivo <- fix_exerc_tex_file(arquivo)
  
  nome_arquivo <- path_file(path_rmd)
  write_file(str_c(arquivo, collapse = "\n"), nome_arquivo)
  cat(sprintf("`%s` foi reescrito!\n", nome_arquivo))
}





fix_exercises <- function(text){
  text <- str_replace(
    text,
    "\\\\section[*]\\{([:script=Latin:]+)\\}",
    "## \\1 {.unnumbered}"
  )
  
  text <- str_replace(
    text,
    "(\\\\newpage|\\\\setcounter\\{Exercise\\}\\{0\\})",
    ""
  )
  
  text <- str_replace(
    text,
    "\\\\url\\{([-_/:.?=a-zA-Z0-9]+)\\}",
    "[\\1](\\1)"
  )
  
  
  return(text)
}






for(i in seq_along(exerc_rmds)){
  path_rmd <- exerc_rmds[i]
  nome_arquivo <- path_file(path_rmd)
  arquivo <- read_rmds(path_rmd)
  
  arquivo <- str_c(fix_exercises(arquivo), collapse = "\n")
  
  write_file(
    arquivo,
    str_c("Exercícios/", nome_arquivo)
  )
  cat(sprintf("`%s` foi reescrito!\n", nome_arquivo))
}






fix_exerc_titles <- function(input){
  output <- input
  # Erase any \large, \Large, \normalsize
  output <- str_replace_all(
    output,
    "\\\\([lL]arge|[hH]uge|normalsize|small)", ""
  )
  
  output <- str_replace_all(
    output,
    "\\\\textsf\\{(.+)\\}",
    "\\1"
  )
  
  output <- str_replace_all(
    output,
    "\\\\textbf\\{(.+)\\}",
    "*\\1*"
  )
  
  output <- str_replace_all(
    output,
    "\\\\quad",
    " "
  )
  
  
  return(output)
}


arquivo <- read_rmds(resp_rmd)
### Retirar referências bibliográficas do capítulo de respostas aos exercícios
referencias <- str_which(arquivo, "\\\\bibliographystyle|\\\\bibliography")
arquivo <- arquivo[
  ! (seq_along(arquivo) %in% referencias)
]


arquivo <- fix_citations(arquivo)
arquivo <- fix_citations(arquivo)

for(j in 1:2){
  arquivo <- replace_mult_citations(arquivo, estilos_backref[j], estilos_inside[j])
}

arquivo <- fix_latex_cmds(arquivo)
arquivo <- fix_verbatim(arquivo)
arquivo <- fix_begin_center(arquivo)
arquivo <- fix_chapter(arquivo)
arquivo <- fix_image_files(arquivo)


yaml_headers <- str_which(arquivo, "^---") |> sort()
starts <- yaml_headers[seq_along(yaml_headers) %% 2 != 0]
ends <- yaml_headers[seq_along(yaml_headers) %% 2 == 0]
difs <- ends - starts
yaml_headers <- sequence.default(from = starts, nvec = difs + 1)

arquivo <- arquivo[
  ! (seq_along(arquivo) %in% yaml_headers)
]

arquivo <- c(
  "# (PART) Respostas dos exercícios de cada capítulo {-}\n",
  "# Respostas {-}\n", arquivo
)

arquivo <- fix_exerc_titles(arquivo)


path_rmd <- resp_rmd
nome_arquivo <- path_file(path_rmd)

write_file(
  str_c(arquivo, collapse = "\n"),
  str_c("Exercícios/", nome_arquivo)
)
cat(sprintf("`%s` foi reescrito!\n", nome_arquivo))
