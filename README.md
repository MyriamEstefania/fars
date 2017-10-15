# FARS: Accident Data Analysis package

[![Travis-CI Build Status](https://travis-ci.org/MyriamEstefania/fars.svg?branch=master)](https://travis-ci.org/MyriamEstefania/fars)

Este es un paquete `R` creado para el curso Coursera [Building R Packages](https://www.coursera.org/learn/r-packages/home). Contiene varias funciones básicas para analizar datos del Sistema de Informes de Análisis de Fatalidades (FARS) - [source](http://www.nhtsa.gov/Data/Fatality-Analysis-Reporting-System-(FARS)). El objetivo es demostrar la capacidad de documentar funciones, crear viñetas y pruebas y también incluir datos con el paquete.

# Contiene en su estructura cuatro fuciones:
fars_read()	 que  lee un FARS archivo

fars_read_years()	Lea el (los) archivo (s) de datos de FARS para el (los) año (s) proporcionado (s)

fars_summarize_years()	Resuma las lesiones por mes para el año (s) provisto (s)

fars_map_state()	Visualice el mapa con lesiones para el estado proporcionado (EE. UU.) Y año

# Instalación
Using devtools and Github
devtools::install_github("MyriamEstefania/fars")
