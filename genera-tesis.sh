#!/bin/bash

# Directorio raíz para el repositorio de tesis
root_dir="/home/murph/Repos/tesis-doctorado"
rm -rf "${root_dir}"
mkdir "${root_dir}"
cd "${root_dir}" || exit

# Verificar si ya existe un repositorio Git en el directorio actual
if [ ! -d ".git" ]; then
    # No hay repositorio Git, inicializar uno nuevo
    git init
    git config user.email "murpholinoxpeligro@protonmail.com"
    git config user.name "Murpholinox Peligro"
    echo "Repositorio Git inicializado."
else
    echo "Ya existe un repositorio Git en este directorio."
fi

# Crear archivo tesis.tex
cat << EOF > tesis.tex
\documentclass[
fontsize=12pt,          % Font size
twoside=semi,           % Set to "true" for double-sided printing
parskip=half,           % Space between paragraphs
index=totoc,            % Add index to table of contents
bib=numbered,           % Numbered bibliography
listof=totoc,           % Add lists to table of contents
titlepage=on,           % Enable title page
titlepage-rule=on,      % Add a rule under the title
]{kaobook}

% Customization
\usepackage{tikz}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{lipsum} % Placeholder text, remove this line
\usepackage[spanish,es-noindentfirst]{babel} % Language and no indentation for first paragraphs
\usepackage[backend=biber, style=numeric, sorting=none]{biblatex}
\addbibresource{bibliografia.bib}

\begin{document}

\title{Efecto del pH en la condición de cristalización sobre el daño por radiación en cristales de proteína}
\author{Francisco Murphy Pérez}
\date{\today}
\maketitle

\tableofcontents
\listoftables
\listoffigures

EOF

# Lista de capítulos y apéndices
capitulos=("Agradecimientos" "Resumen" "Introducción" "Antecedentes" "Materiales y métodos" "Resultados" "Conclusiones" "Perspectivas")
apendices=("Apéndice A" "Apéndice B" "Apéndice C")

# Crea estructura de carpetas y archivos para capítulos
for capitulo in "${capitulos[@]}"; do
    # Nombre de la carpeta en minúsculas y sin espacios ni acentos
    cap_mod=$(echo "$capitulo" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | iconv -f utf-8 -t ascii//TRANSLIT)
    mkdir -p "$cap_mod"
    
    # Agrega el capítulo al archivo tesis.tex
    if [ "$cap_mod" == "agradecimientos" ] || [ "$cap_mod" == "resumen" ]; then
        echo "\\chapter*{$capitulo}" >> tesis.tex
    else
        echo "\\chapter{$capitulo}" >> tesis.tex
    fi
    
    echo "\\include{$cap_mod/$cap_mod.tex}" >> tesis.tex
    echo "\\lipsum[1-4]" > "$cap_mod/$cap_mod.tex"
done

# Agrega los apéndices
echo >> tesis.tex
echo '\appendix' >> tesis.tex

# Crea estructura de carpetas y archivos para apéndices
for apendice in "${apendices[@]}"; do
    # Nombre de la carpeta en minúsculas y sin espacios ni acentos
    ape_mod=$(echo "$apendice" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | iconv -f utf-8 -t ascii//TRANSLIT)
    mkdir -p "$ape_mod"
    echo "\\include{$ape_mod/$ape_mod.tex}" >> tesis.tex
    echo "\\chapter{$apendice}" > "$ape_mod/$ape_mod.tex"
    echo "\\lipsum[1-4]" >> "$ape_mod/$ape_mod.tex"
done

# Bibliografía con Biber y estilo científico en español
echo '\printbibliography[heading=bibintoc]' >> tesis.tex

# Fin del documento
echo '\end{document}' >> tesis.tex

# Crear archivo bibliografia.bib
touch bibliografia.bib

# Crear carpeta para imágenes
mkdir imgs

# Crear archivo .gitignore
echo -e "*.aux\n*.bbl\n*.blg\n*.log\n*.out\n*.pdf\n*.toc\n*.lof\n*.lot" > .gitignore

# Agrega un archivo README.md
echo "# Tesis de Doctorado" > README.md
echo "Repositorio creado el $(date +'%Y-%m-%d') con la ayuda de OpenAI's ChatGPT." >> README.md
echo "Autores: Francisco Murphy Pérez, ChatGPT" >> README.md
echo "Licencia: GPL" >> README.md

# Copia la clase kaobook y demás aquí
cp /home/murph/Repos/kaobook/kao* .

# Hacer commit final
git add *
git commit -m "Agregada estructura de carpetas y archivos LaTeX"

echo "Estructura de carpetas y archivos creada, plantilla LaTeX generada, repositorio Git inicializado y archivo .gitignore creado con éxito."

