% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/chisqtest-methods.R
\name{chisqtest}
\alias{chisqtest}
\alias{chisqtest,INSPEcT_model-method}
\alias{chisqtest,INSPEcT-method}
\title{Retrieve all results of chi-squared test}
\usage{
chisqtest(object, ...)

\S4method{chisqtest}{INSPEcT_model}(object, ...)

\S4method{chisqtest}{INSPEcT}(object, ...)
}
\arguments{
\item{object}{An object of class INSPEcT or INSPEcT_model}

\item{...}{Additional arguments for the generic}
}
\value{
A matrix of chi-squared test results for all the tested models
}
\description{
This method is used to retrieve all the chi-squared test results for all models tested for all genes.
}
\examples{
nascentInspObj10 <- readRDS(system.file(package='INSPEcT', 'nascentInspObj10.rds'))
chisqtest(nascentInspObj10)
}
