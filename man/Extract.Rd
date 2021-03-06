% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Extract-methods.R
\docType{methods}
\name{Extract}
\alias{Extract}
\alias{[,INSPEcT_model,ANY,ANY,ANY-method}
\alias{[,INSPEcT,ANY,ANY,ANY-method}
\alias{[,INSPEcT_diffsteady,ANY,ANY,ANY-method}
\title{Extract Parts of an INSPEcT or an INSPEcT_model Object}
\usage{
\S4method{[}{INSPEcT_model,ANY,ANY,ANY}(x, i)

\S4method{[}{INSPEcT,ANY,ANY,ANY}(x, i, j)

\S4method{[}{INSPEcT_diffsteady,ANY,ANY,ANY}(x, i, j)
}
\arguments{
\item{x}{An object of class INSPEcT or INSPEcT_model}

\item{i}{A numeric, a vector of logicals or a vector of names indicating the 
features to be extracted}

\item{j}{A numeric, a vector of logicals indicating the 
time points to be extracted}
}
\value{
An Object of class INSPEcT
}
\description{
Operators acting on INSPEcT, INSPEcT_model or INSPEcT_diffsteady objects 
to extract parts. INSPEcT_model objects can be subsetted only by gene.
INSPEcT objects can be subsetted either by gene id or time point. In case
of subsetting an INSPEcT object by time point, the model should be empty.
}
\examples{
nascentInspObj10 <- readRDS(system.file(package='INSPEcT', 'nascentInspObj10.rds'))
nascentInspObj10_5genes <- nascentInspObj10[1:5]
\dontrun{
## This will turn out into an error:
nascentInspObj10_5genes_5tpts <- nascentInspObj10[1:5, 1:5]
}
## Before subsetting time points, the model should be removed:
nascentInspObj10_5genes_5tpts <- removeModel(nascentInspObj10)[1:5, 1:5]
}
\seealso{
removeModel
}
