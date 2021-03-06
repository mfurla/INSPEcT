% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllGenerics.R, R/makeSimDataset-methods.R
\name{makeSimDataset}
\alias{makeSimDataset}
\alias{makeSimDataset,INSPEcT_model-method}
\title{Generate synthetic rates and concentrations}
\usage{
makeSimDataset(
  object,
  tpts,
  nRep,
  NoNascent = FALSE,
  seed = NULL,
  b = 0.3,
  tL = 1/6,
  noise_sd = 4
)

\S4method{makeSimDataset}{INSPEcT_model}(
  object,
  tpts,
  nRep,
  NoNascent = FALSE,
  seed = NULL,
  b = 0.3,
  tL = 1/6,
  noise_sd = 4
)
}
\arguments{
\item{object}{An object of class INSPEcT_model, usually the output of \code{\link{makeSimModel}}}

\item{tpts}{A numeric vector of time points where rates and concentrations have to be evaluated}

\item{nRep}{Number of replicates to simulate}

\item{NoNascent}{A logical which, if true, makes the output of the method suitable for an analysis 
without Nascent. (default=FALSE)}

\item{seed}{A numeric to obtain reproducible results. When NULL (default) no seed is set.}

\item{b}{A numeric which represents the probability of contamination of the unlabeled sample due to the labled one}

\item{tL}{A numeric which represents the labeling time for an ideal nascent RNA profiling, it is required for 
the contamination analysis. (default=1/6)}

\item{noise_sd}{A numeric which represents the noise standard deviation. (default=4)}
}
\value{
An object of the class ExpressionSet containing rates and concentrations
}
\description{
This method generates rates and concentrations where noise is added according to the desired number of 
replicates that the user set as an arguments from the INSPEcT_model object that has been created by the 
method of the class INSPEcT \code{\link{makeSimModel}}. Rates and concentrations can be generated at the 
time-points of interest within the original time window. This method generates an INSPEcT object that can
be modeled and the performance of the modeling can be tested directly aginst the INSPEcT_model object
created by \code{\link{makeSimModel}}.
}
\examples{
if( Sys.info()["sysname"] != "Windows" ) {
  nascentInspObj <- readRDS(system.file(package='INSPEcT', 'nascentInspObj.rds'))
  simRates<-makeSimModel(nascentInspObj, 1000, seed=1)
  tpts <- tpts(nascentInspObj)
  nascentSim2replicates <- makeSimDataset(object=simRates,tpts=tpts,nRep=3,NoNascent=FALSE,seed=1)
}
}
\seealso{
\code{\link{makeSimModel}}
}
