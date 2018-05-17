#!/bin/bash

echo "\documentclass[a4paper,11.5pt]{article}
\usepackage[latin1]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[english]{babel}
\usepackage{graphicx}
\usepackage{amsmath}
\usepackage{amsfonts}
\usepackage{multirow}
\usepackage{booktabs}
\usepackage{bbold}
\usepackage{mathtools}
\usepackage{mathrsfs}
\usepackage{enumitem}
\usepackage{array}
\usepackage{listings}


\setlength{\parindent}{0pt}
\DeclarePairedDelimiter{\floor}{\lfloor}{\rfloor}
\DeclarePairedDelimiter{\ceil}{\lceil}{\rceil}

\newcommand{\vt}{\boldsymbol}

\title{Digital Communications - HW3 - MATLAB Code}
\author{Jacopo Pegoraro, Edoardo Vanin}
\date{24/04/2018}

\begin{document}

\maketitle " > ./report/report3_code.tex

for file in *.m ; do
  echo "\lstinputlisting{../$file}" >> ./report/report3_code.tex
done

echo "
\end{document}
" >> ./report/report3_code.tex
