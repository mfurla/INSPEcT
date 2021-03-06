#' @rdname INSPEcT_model-class
#' @param object An object of class INSPEcT_model
#' @return Method show for objects of class INSPEcT_model returns the number of
#' the genes that have been modeled
setMethod('show', 'INSPEcT_model', function(object) {
	message(paste('object of class INSPEcT_model of length', 
		length(object@ratesSpecs)))
	})

#' @rdname INSPEcT-class
#' @param object An object of class INSPEcT
#' @return Method show for objects of class INSPEcT displays the main features
#' of the slots ratesFirstGuess, model and modelRates
setMethod('show', 'INSPEcT', function(object) {
	
	tpts <- tpts(object)
	
	if( object@NoNascent ) {
		message("No Nascent RNA mode.")
	} else {
		message("Nascent RNA mode.")
	}
	
	if( is.numeric(tpts) ) {
		message(paste("Time-course INSPEcT object with", length(featureNames(object)), "genes and", length(tpts), "time points."))
	} else {
		message(paste("Steady-state INSPEcT object with", length(featureNames(object)), "genes and", length(tpts), "conditions."))
	}
	
	if( object@NF ) {
		message("Rates first guess and confidence intervals were computed (non-functional framework).")
		message("Access complete rates with the method ratesFirstGuess.")
	} else if( length(object@model@ratesSpecs)>0 ) {
		if( modelingParams(object)$estimateRatesWith == 'int' ) {
			if( modelingParams(object)$useSigmoidFun ) {
				message("Rates were modeled using the integrative framework with either constant, sigmoid or impulse functions.")		
			} else {
				message("Rates were modeled using the integrative framework with either constant or impulse functions.")		
			}
		} else {
			if( modelingParams(object)$useSigmoidFun ) {
				message("Rates were modeled using the derivative framework with either constant, sigmoid or impulse functions.")	
			} else {
				message("Rates were modeled using the derivative framework with either constant or impulse functions.")	
			}
		}
		message("Access complete rates with the method viewModelRates.")
		# table(convergence(myc))
		# quantile(chisqmodel(myc), probs = c(.01,.25,.5,.75,.99))
	} else {
		message("Only Rates first guess were computed.")
		message("Access complete rates with the method ratesFirstGuess.")
	}
	
	if( .hasSlot(object, 'version') ) {
		message(paste("INSPEcT Version",object@version))
	} else {
		message("This object is OBSOLETE and most of the INSPEcT routines will not work on it.")
	}

	})

#' @rdname INSPEcT_diffsteady-class
#' @param object An object of class INSPEcT_model
#' @return Method show for objects of class INSPEcT_model returns the number of
#' the genes that have been modeled
setMethod('show', 'INSPEcT_diffsteady', function(object) {
	message('Object of class INSPEcT_diffsteady')

	for(sn in c('synthesis','processing','degradation') ) {
		data <- slot(object, sn)
		if(nrow(data)>6) {
			message('Head of slot ',sn,':')
			print(head(data))
			message('... and other ', nrow(data)-6, ' hidden genes.')
		} else {
			message('Slot "',sn,'":')
			print(data)
		}
		message('')
	}

	})

#' @title Gene Names Associated with an Object of Class INSPEcT
#' @description
#' A method to visualize gene names associated with the object of class INSPEcT
#' @param object An object of class INSPEcT
#' @return A character that contains gene names associated with the object of class INSPEcT
setMethod('featureNames', 'INSPEcT', function(object) {
	featureNames(object@ratesFirstGuess)
	})

#' @rdname featureNames-INSPEcT-method
#' @param value A character that will replace the current feature names
setReplaceMethod('featureNames', signature(object='INSPEcT', value='ANY')
	, function(object, value) {
	featureNames(object@ratesFirstGuess) <- value
	featureNames(object@ratesFirstGuessVar) <- value
	if( nrow(object@modelRates) > 0 ) {
		featureNames(object@confidenceIntervals) <- value
		featureNames(object@modelRates) <- value
		names(object@model@ratesSpecs) <- value
		rownames(object@ratePvals) <- value
	}
	object
	})

#' @rdname nGenes
#' @description
#' A method to obtain the number of the genes associated with the object of class INSPEcT
#' @param object An object of class INSPEcT
#' @return A numeric that indicates the number of genes within the object
#' @examples
#' nascentInspObj10 <- readRDS(system.file(package='INSPEcT', 'nascentInspObj10.rds'))
#' nGenes(nascentInspObj10)
setMethod('nGenes', 'INSPEcT', function(object) {
	length(featureNames(object@ratesFirstGuess))
	})

#' @rdname nTpts
#' @description
#' A method to obtain the number of the tpts associated with the object of class INSPEcT
#' @param object An object of class INSPEcT
#' @return A numeric that indicates the number of time points contained the object
#' @examples
#' nascentInspObj10 <- readRDS(system.file(package='INSPEcT', 'nascentInspObj10.rds'))
#' nTpts(nascentInspObj10)
setMethod('nTpts', 'INSPEcT', function(object) {
	length(object@tpts)
	})

#' @title Dimensions of an Object of Class INSPEcT
#' @description
#' A method to obtain the dimension of the object of class INSPEcT reported as a vector
#' containing of the genes and the number of time points
#' @param x An object of class INSPEcT
#' @seealso \code{\link{nGenes}}, \code{\link{nTpts}}
#' @return A numeric that indicates the number of genes within the object and 
#' the number of time points contained the object
setMethod('dim', 'INSPEcT', function(x) {
	c(
	length(featureNames(x@ratesFirstGuess))
	, length(x@tpts)
	)
	})

#' @rdname tpts
#' @description
#' Accessor to obtain the tpts associated with the object of class INSPEcT
#' @param object An object of class INSPEcT
#' @return A numeric that indicates time points contained the object
#' @examples
#' nascentInspObj10 <- readRDS(system.file(package='INSPEcT', 'nascentInspObj10.rds'))
#' tpts(nascentInspObj10)
setMethod('tpts', 'INSPEcT', function(object) {
	object@tpts
	})

#' @rdname labeledSF
#' @description
#' Accessor to obtain the labeledSF slot associated with the object of class INSPEcT
#' @param object An object of class INSPEcT
#' @return A numeric that indicates the scaling factors applied between time points
#' of the data coming from Nascent-seq library (applies directly to synthesis
#' rates and indirectly to degradation rates)
#' @examples
#' nascentInspObj10 <- readRDS(system.file(package='INSPEcT', 'nascentInspObj10.rds'))
#' labeledSF(nascentInspObj10)
setMethod('labeledSF', 'INSPEcT', function(object) {
	object@labeledSF
	})
