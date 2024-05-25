# Sobre este repositório

<a href="https://pedro-faria.netlify.app/pt/publication/book/introducao_linguagem_r/"><img src="capa.png" width="250" height="366" class="cover" align="right"/></a> Este repositório, guarda os vários arquivos que compõe o livro "Introdução à Linguagem R: seus fundamentos e sua prática". O livro é construído por meio dos pacotes `rmarkdown` e `bookdown`. Qualquer um pode contribuir com o livro, ao registrar um *pull request* para este repositório.

## Leia o livro em seu navegador

Ao acessar o [site do livro](https://pedropark99.github.io/Introducao_R/), você pode ler o livro inteiro em seu navegador, de maneira gratuita, rápida e eficiente.

## Você também pode comprar uma versão física ou em eBook do livro

O livro também está [disponível para compra através da loja da Amazon](https://www.amazon.com.br/dp/B0D57F5Q1P). Tanto uma versão física quanto uma versão em eBook do livro são oferecidas.

# Como contribuir para o livro?

Esse é um livro aberto para toda a comunidade brasileira. Qualquer pessoa pode contribuir
para este livro ao submeter PR's para este repositório. Caso tenha dúvidas sobre como
construir o livro localmente na sua máquina, consulte as sessões abaixo.

## Construa o livro localmente na sua máquina

Supondo que você conseguiu instalar todas as dependências do livro corretamente (veja seções abaixo), você
pode construir o livro localmente na sua máquina executando o comando abaixo
no terminal de seu sistema operacional:

```bash
quarto render
```



## Instale as dependências

Para construir o livro localmente na sua máquina é necessário:

1. ter o R instalado (acesse [CRAN R](https://cran.r-project.org/)).
1. ter o Python instalado (algumas partes específicas do livro executam alguns exemplos de Python).
1. ter alguns pacotes do R instalados (consulte o script `dependencies.R`).
1. ter o Quarto instalado (acesse o [site oficial](https://quarto.org/)).

### Como instalar os pacotes do R?
Alguns pacotes do R precisam estar instalados na sua máquina para construir
o livro localmente na sua máquina.

Você pode instalar rapidamente esses pacotes ao
executar o script `dependencies.R`, que está disponível na pasta *root* deste projeto.

Você pode rodar manualmente o script no RStudio por exemplo, ou então, se preferir, você
pode rodá-lo diretamente no terminal executando o comando abaixo em qualquer terminal
de seu sistema operacional:

```bash
Rscript dependencies.R
```

### Instalar o R
Para instalar o R, procure pelas informações de instalação específicas de seu
sistema operacional no site do [CRAN R](https://cran.r-project.org/).

### Instalar o Python
Para instalar o Python, procure pelas informações de instalação específicas de seu
sistema operacional no [site oficial da linguagem](https://www.python.org/).

### Instalar o Quarto

Já para instalar o Quarto, procure pelas informações de instalação específicas de seu
sistema operacional no [site oficial da ferramenta](https://quarto.org/).





# Licença

Copyright © 2024 Pedro Duarte Faria. Este livro está sob a licença CC-BY 4.0 Creative Commons Attribution 4.0 International Public License.

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a>