% aga-homework.cls
%
% A LaTeX2e document class for preparing homework solutions.

% --- METADATA -----------------------------------------------------------------
\def\fileversion{0.1}
\def\filedate{2018/02/07}

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{aga-homework}[\filedate\space Version \fileversion\space by
  Applied Geometric Algorithms group, TU Eindhoven]

% --- OPTION PROCESSSING -------------------------------------------------------
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
  family = agahomework,
  prefix = agahomework@,
  setkeys = \kvsetkeys
}

\DeclareStringOption[2IL50 Data Structures]%
  {course}
\DeclareStringOption[3]%
  {quartile}
\DeclareStringOption[1]%
  {assignment}
\DeclareStringOption[Some One]%
  {name}
\DeclareStringOption[0123456]%
  {studentnumber}
\DeclareStringOption[s.one@student.tue.nl]%
  {email}
\DeclareStringOption[1]%
  {firstexercise}
\DeclareStringOption[4a Fall 2020]%
  {term}

% pass unrecognized options to `article` class
\DeclareDefaultOption{%
  \PassOptionsToClass{\CurrentOption}{article}%
}

% process all options
\ProcessKeyvalOptions{agahomework}

% load parent class with some default options
\LoadClass[a4paper, 11pt]{article}

% --- PACKAGES AND SETUP -------------------------------------------------------
\RequirePackage[
    a4paper,
    headheight = 20pt,
    margin = 1in,
    tmargin = \dimexpr 1in - 10pt \relax
  ]{geometry} % set up nicer margins
  \addtolength{\footskip}{20pt}
\RequirePackage{fancyhdr} % for headers and footers
\RequirePackage{graphicx} % for including figures
\RequirePackage{mathpazo} % use Palation font
\RequirePackage{amsmath} % use AMS math package
\RequirePackage{amssymb} % use AMS symbols
\RequirePackage{amsthm} % for writing proofs
\RequirePackage{array} % for setting up arguments to columns
\RequirePackage{booktabs} % for professional tables
\RequirePackage{cancel} % for stricking out equations
\RequirePackage{empheq} % for making boxed equations
\RequirePackage%
  [tworuled, linesnumbered, noend, noline]%
  {algorithm2e} % for typesetting pseudo-code
\RequirePackage{xcolor} % for colored text (comments in algorithms)
\RequirePackage{trimspaces, xstring} % for multiple author parsing

% option post-processing
\newcommand*{\aga@quartileLastYear}{Q\agahomework@quartile~%
    \the\numexpr\year-1\relax-\the\year}
\newcommand*{\aga@quartileNextYear}{Q\agahomework@quartile~%
    \the\year-\the\numexpr\year+1\relax}
\newcommand*{\aga@quartile}{%
  % print last year - this year for Q3+, print this year - next year for Q1, Q2
  % exception: in the first months of the new year, it can be Q2 and the first
  % option must be used (handled in nested if)
  \ifnum\agahomework@quartile < 3%
    \ifnum\the\month < 6%
      \aga@quartileLastYear%
    \else%
      \aga@quartileNextYear%
    \fi%
  \else%
    \aga@quartileLastYear%
  \fi%
}

\newcommand{\aga@temp}{}
\newcommand{\aga@sub}[4]{%
  \ifnum#3 = 1\relax%
    \ifnum#4 = 1\relax%
      \renewcommand{\aga@temp}{#1}%
    \else%
      \StrBefore{#1}{#2}[\aga@temp]%
    \fi%
  \else%
    \ifnum#3 = #4\relax%
      \StrBehind[\numexpr#3 - 1\relax]{#1}{#2}[\aga@temp]%
    \else%
      \StrBetween[\numexpr#3 - 1\relax,#3]{#1}{#2}{#2}[\aga@temp]%
    \fi%
  \fi%
  \expandafter\trim@spaces\expandafter{\aga@temp}%
}
\newcommand{\aga@authorProcessed}[1]{%
  \aga@sub{\agahomework@name}{;}{#1}{\arabic{aga@numAuthors}}~%
  (\aga@sub{\agahomework@studentnumber}{;}{#1}{\arabic{aga@numAuthors}})\\%
  \texttt{\aga@sub{\agahomework@email}{;}{#1}{\arabic{aga@numAuthors}}}%
  % if there are more authors, do a recursive call for the next one
  \ifnum#1 < \arabic{aga@numAuthors}\relax\and\aga@authorProcessed{\numexpr#1 + 1\relax}\fi%
}
\newcommand{\aga@authorsProcessed}{%
  % count number of authors; one more than number of semicolons
  \StrCount{\agahomework@name}{;}[\aga@numAuthors]%
  \newcounter{aga@numAuthors}%
  \setcounter{aga@numAuthors}{\aga@numAuthors}%
  \stepcounter{aga@numAuthors}%
  % produce output
  \aga@authorProcessed{1}%
}

% look for figures in the figures directory
\graphicspath{{figures/}}

% set up headers and footers; same for all pages
\setlength{\headheight}{14pt}
\newcommand{\agahomework@setupHF}{%
  \fancyhf{}
  \fancyhead[L]{\sffamily University of Waterloo, ON}
  \fancyhead[R]{\sffamily \agahomework@course, \agahomework@term}
  \fancyfoot[L]{\sffamily }
  \fancyfoot[R]{\sffamily\bfseries\thepage}
  \renewcommand{\headrulewidth}{0.5pt}
  \renewcommand{\footrulewidth}{0.5pt}
}
\fancypagestyle{plain}{\agahomework@setupHF{}}
\agahomework@setupHF{}
\pagestyle{fancy}

% ensure that the title is inserted in the document
\title{\vspace{-2\baselineskip}Assignment \agahomework@assignment}
\author{\aga@authorsProcessed}
\AtBeginDocument{\maketitle}

% add some keywords
\SetKw{And}{and}
\SetKw{Or}{or}
\SetKw{To}{to}
% make it possible to not have line numbers on a single line
\let\oldnl\nl
\newcommand{\nonl}{\renewcommand{\nl}{\let\nl\oldnl}}
% style algorithm captions
\newcommand{\agahomework@capsty}[1]{\!}
\SetAlCapSty{agahomework@capsty}
\SetAlCapNameFnt{\scshape\hspace{.69em}}
% get rid of semicolons
\DontPrintSemicolon
% comment formatting
\newcommand\agacommfont[1]{\footnotesize\ttfamily\textcolor{gray}{#1}}
\SetCommentSty{agacommfont}

% --- USEFUL MACROS ------------------------------------------------------------
\newcommand*{\R}{{\mathbb R}}
\newcommand*{\N}{{\mathbb N}}
\newcommand*{\Z}{{\mathbb Z}}
\newcommand*{\Q}{{\mathbb Q}}
\newcommand*{\V}{{\mathbb V}}
\newcommand*{\W}{{\mathbb W}}
\newcommand*{\U}{{\mathbb U}}
\newcommand*{\B}{{\mathbb B}}
\newcommand*{\C}{{\mathbb C}}
\newcommand*{\one}{{\mathbb 1}}

% --- CUSTOM COMMANDS ----------------------------------------------------------
\newcounter{exercise}
\setcounter{exercise}{\agahomework@firstexercise}
\addtocounter{exercise}{-1}
\newcounter{subexercise}
\newcounter{ssubexercise}
\newcommand*{\exercise}[1][]{%
    \section*{Exercise \ifx/#1/\stepcounter{exercise}\arabic{exercise}\else#1\fi}%
    \setcounter{subexercise}{0}%
    \setcounter{ssubexercise}{0}%
}
\newcommand*{\subexercise}[1][]{%
    \paragraph{(\ifx/#1/\protect\stepcounter{subexercise}\alph{subexercise}\else#1\fi)}%
    \setcounter{ssubexercise}{0}%
    }

\newcommand*{\ssubexercise}[1][]{%
    \paragraph{(\ifx/#1/\protect\stepcounter{ssubexercise}\roman{ssubexercise}\else#1\fi)}}

\newcommand*{\boxedeq}[2]{\begin{empheq}[box={\fboxsep=6pt\fbox}]{align}\label{#1}#2\end{empheq}}
\newcommand*{\boxedeqn}[2]{\begin{empheq}[box={\fboxsep=6pt\fbox}]{align*}\label{#1}#2\end{empheq}}
