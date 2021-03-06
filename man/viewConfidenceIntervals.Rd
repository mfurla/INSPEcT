% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R,
%   R/viewConfidenceIntervals-methods.R
\name{viewConfidenceIntervals}
\alias{viewConfidenceIntervals}
\alias{viewConfidenceIntervals,INSPEcT-method}
\title{Retrieve the modeled Confidence Intervals}
\usage{
viewConfidenceIntervals(object, feature)

\S4method{viewConfidenceIntervals}{INSPEcT}(object, feature)
}
\arguments{
\item{object}{An object of class INSPEcT}

\item{feature}{A character indicating the feature to retireve: "synthesis", "degradation", "processing".}
}
\value{
A numeric matrix containing the values for the selected feature
}
\description{
A method to access the modeld confidence intervals computed via the method \code{\link{computeConfidenceIntervals}}
}
\examples{
nascentInspObj10 <- readRDS(system.file(package='INSPEcT', 'nascentInspObj10.rds'))
viewConfidenceIntervals(nascentInspObj10, 'synthesis')
}
