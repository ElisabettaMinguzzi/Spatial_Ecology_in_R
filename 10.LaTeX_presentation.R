\documentclass{beamer}
\usepackage{graphicx} % Required for inserting images
\usepackage{listings}  % It allows to show a code, from R for example, in the ppt or pdf file on LaTeX

\usetheme{Madrid}
\usecolortheme{crane}



\title{My first presentation in LaTeX}
\author{Elisabetta Minguzzi}
\date{December 2023}

\begin{document}

\maketitle

\section{Introduction}

\begin{frame} {My first slide in LaTeX}
This is my first text in LaTeX presentations!
\end{frame}


\begin{frame} {Items in LaTeX beamer}
     The main components of the Spatial Ecology course were:
     \begin{itemize}
         \item population ecology
         \item \pause community ecology 
         \item \pause ecosystems
     \end{itemize}
\end{frame}

\begin{frame}{Putting a figure}
    \includegraphics[width=0.4 \textwidth]{Andromeda_galaxy.png}
    \includegraphics[width=0.4 \textwidth]{Andromeda_galaxy.png}
\end{frame}

\section{Approach used}

\begin{frame}{Adding a formula}
    The formula used in this study was based on:\\
\begin{equation}
    H = - \sum_{i=1}^N p_i \times \log(p)
\end{equation}
where:\\
$p_i$ = proportion of class;
$i$ = proportion of the $i_{ith}$ class.
\end{frame}

\begin{frame}{Adding code}
      The functions used in this study were based on the \texttt{imageRy} package and look like :\\
      % Let's add the code 
      \lstinputlisting[language=R]{code.R(LaTeXpres).R}
\end{frame}

\begin{frame}{Adding code as a figure}
     \includegraphics[width=\textwidth]{code.png}   % I should upload the code as a png file
\end{frame}

\begin{frame}{text plus figure}
    \centering
    The final result achieved was that represented in the following figure.\\
    \bigskip   % The space between the text and the figure
    \includegraphics[width=0.7 \textwidth]{Andromeda_galaxy.png}
\end{frame}

\begin{frame}{Columns in beamer}
      \begin{columns}
          \column{0.5\textwidth}
          \centering
          Text here
          \column{0.5\textwidth}
          \centering
          \includegraphics[width=0.8\textwidth]{Andromeda_galaxy.png}
      \end{columns}
\end{frame}

\AtBeginSection[]   % Do nothing for \section*
{
\begin{frame}
\frametitle{Outline}
\tableofcontents[currentsection]
\end{frame}
}



\end{document}


