#' @rdname plotGene
#'
#' @description
#' A method to see the shapes of the estimated synthesis, degradation and processing rates, pre-RNA and total RNA 
#' concentrations (solid thin lines) their variances (dashed lines) and the modeled rates and concentrations 
#' (ticker solid line) of a single gene. 
#' @param object An object of class INSPEcT
#' @param ix Eiher a rowname or a row number to select one single gene
#' @param fix.yaxis A logical, indicating whether the limits for y-axis of degradation and processing rates should be fixed
#' relative to their distributions
#' @param priors A logical, if true the priors of the rates are plotted
#' @param constantModel A logical, if true the constant model for the + nascent modeling are shown
#' @return A list containing total RNA levels and their confidence interval (levels plus and minus
#' one standard deviation), pre-RNA lelevs and their confidence intervals, synthsis rates and 
#' their confidence intervals, degradation rates and processing rates of the selected gene.
#' @examples
#' nascentInspObj10 <- readRDS(system.file(package='INSPEcT', 'nascentInspObj10.rds'))
#' plotGene(nascentInspObj10, 1)
setMethod('plotGene', 'INSPEcT', function(object, ix, fix.yaxis=FALSE, priors=TRUE, constantModel=FALSE) {
	checkINSPEcTObjectversion(object)
	
	ix <- ix[1]
	tpts <- object@tpts

	oneGene <- object[ix]
	
	oldMfrow <- par()$mfrow
	oldMar <- par()$mar

	ratesFirstGuessTotalTmp <- ratesFirstGuess(object, 'total')[ix,]
	ratesFirstGuessPreTmp <- ratesFirstGuess(object, 'preMRNA')[ix,]

	ratesFirstGuessTotalVarTmp <- ratesFirstGuessVar(object, 'total')[ix,]
	ratesFirstGuessPreVarTmp <- ratesFirstGuessVar(object, 'preMRNA')[ix,]

	ratesFirstGuessSynthesisTmp <- ratesFirstGuess(object, 'synthesis')[ix,]
	ratesFirstGuessProcessingTmp <- ratesFirstGuess(object, 'processing')[ix,]
	ratesFirstGuessDegradationTmp <- ratesFirstGuess(object, 'degradation')[ix,]

	ratesFirstGuessSynthesisVarTmp <- ratesFirstGuessVar(object, 'synthesis')[ix,]

	if(!priors)
	{
		ratesFirstGuessProcessingTmp[is.finite(ratesFirstGuessProcessingTmp)] <- NaN
		ratesFirstGuessDegradationTmp[is.finite(ratesFirstGuessDegradationTmp)] <- NaN

		if(oneGene@NoNascent)
		{
			ratesFirstGuessSynthesisTmp[is.finite(ratesFirstGuessSynthesisTmp)] <- NaN
			ratesFirstGuessSynthesisVarTmp[is.finite(ratesFirstGuessSynthesisVarTmp)] <- NaN			
		}
	}

	if( nrow(oneGene@modelRates) > 0 ) {

		pValues <- formatC(as.numeric(ratePvals(object)[ix,]),format = "e", digits = 1)
		names(pValues) <- c('synthesis','processing','degradation')

		if( oneGene@NoNascent & !oneGene@NF )
			foe <- capture.output(oneGene <- computeConfidenceIntervals(oneGene))

		alpha_left <- tryCatch(viewConfidenceIntervals(oneGene,"synthesis_left"),error=function(e){rep(NaN,length(tpts(oneGene)))})
		alpha_right <- tryCatch(viewConfidenceIntervals(oneGene,"synthesis_right"),error=function(e){rep(NaN,length(tpts(oneGene)))})
		alpha_constant <- tryCatch(viewConfidenceIntervals(oneGene,"synthesis_constant"),error=function(e){rep(NaN,length(tpts(oneGene)))})
		
		gamma_left <- tryCatch(viewConfidenceIntervals(oneGene,"processing_left"),error=function(e){rep(NaN,length(tpts(oneGene)))})
		gamma_right <- tryCatch(viewConfidenceIntervals(oneGene,"processing_right"),error=function(e){rep(NaN,length(tpts(oneGene)))})
		gamma_constant <- tryCatch(viewConfidenceIntervals(oneGene,"processing_constant"),error=function(e){rep(NaN,length(tpts(oneGene)))})

		beta_left <- tryCatch(viewConfidenceIntervals(oneGene,"degradation_left"),error=function(e){rep(NaN,length(tpts(oneGene)))})
		beta_right <- tryCatch(viewConfidenceIntervals(oneGene,"degradation_right"),error=function(e){rep(NaN,length(tpts(oneGene)))})
		beta_constant <- tryCatch(viewConfidenceIntervals(oneGene,"degradation_constant"),error=function(e){rep(NaN,length(tpts(oneGene)))})

		if(oneGene@NoNascent|!constantModel)
		{
			alpha_constant <- rep(NaN,length(tpts(oneGene)))
			gamma_constant <- rep(NaN,length(tpts(oneGene)))
			beta_constant <- rep(NaN,length(tpts(oneGene)))
		}

		total <- t(rbind(
			ratesFirstGuessTotalTmp
			, ratesFirstGuessTotalTmp + 
				sqrt(ratesFirstGuessTotalVarTmp)
			, ratesFirstGuessTotalTmp - 
				sqrt(ratesFirstGuessTotalVarTmp)
			, viewModelRates(object, 'total')[ix,]
			))
		preMRNA <- t(rbind(
			ratesFirstGuessPreTmp
			, ratesFirstGuessPreTmp + 
				sqrt(ratesFirstGuessPreVarTmp)
			, ratesFirstGuessPreTmp - 
				sqrt(ratesFirstGuessPreVarTmp)
			, viewModelRates(object, 'preMRNA')[ix,]
			))

		alpha <- t(rbind(ratesFirstGuessSynthesisTmp
				, viewModelRates(object, 'synthesis')[ix,]
				, alpha_left#ratesFirstGuessSynthesisTmp + sqrt(ratesFirstGuessSynthesisVarTmp)
				, alpha_right#ratesFirstGuessSynthesisTmp - sqrt(ratesFirstGuessSynthesisVarTmp)
				, alpha_constant
		))

		gamma <- t(rbind(ratesFirstGuessProcessingTmp
				, viewModelRates(object, 'processing')[ix,]
				, gamma_left#ratesFirstGuessSynthesisTmp + sqrt(ratesFirstGuessSynthesisVarTmp)
				, gamma_right#ratesFirstGuessSynthesisTmp - sqrt(ratesFirstGuessSynthesisVarTmp)
				, gamma_constant
		))

		beta <- t(rbind(ratesFirstGuessDegradationTmp
				, viewModelRates(object, 'degradation')[ix,]
				, beta_left#ratesFirstGuessSynthesisTmp + sqrt(ratesFirstGuessSynthesisVarTmp)
				, beta_right#ratesFirstGuessSynthesisTmp - sqrt(ratesFirstGuessSynthesisVarTmp)
				, beta_constant
		))

		if( fix.yaxis ) {

			degradationYlim <- quantile(ratesFirstGuess(oneGene, 'degradation'), probs=c(.02, .98), na.rm=TRUE)
			processingYlim <- quantile(ratesFirstGuess(oneGene, 'processing'), probs=c(.02, .98), na.rm=TRUE)

			x <- seq_along(tpts)

			par(mfrow=c(1,5), mar=.1+c(5,2.5,4,.5))
			matplot(x, total, type='l', lty=c(1,2,2,1), lwd=c(1,1,1,3), col=1, main='total RNA', xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)

			functionTmp <- function()
			{
				matplot(x, preMRNA, type='l', lty=c(1,2,2,1), lwd=c(1,1,1,3), col=2, main='pre-RNA', xaxt='n', xlab='time', ylab='')
				axis(1, at=x, labels=signif(tpts, 2), las=3)
			}
			tryCatch(functionTmp(),error=function(e)NaN)

			matplot(x, alpha, type='l', lty=c(1,1,2,2,3), lwd=c(1,3,1,1,3)
				, col=3, main=paste0('synthesis\n',pValues['synthesis']), xaxt='n', xlab='time', ylab='')		
			axis(1, at=x, labels=signif(tpts, 2), las=3)

			functionTmp <- function()
			{
				matplot(x, gamma, type='l', lty=c(1,1,2,2,3), lwd=c(1,3,1,1,3), col=5
					, main=paste0('processing\n',pValues['processing']), xaxt='n', xlab='time', ylab='', ylim=processingYlim)
				axis(1, at=x, labels=signif(tpts, 2), las=3)		
			}
			tryCatch(functionTmp(),error=function(e)NaN)

			matplot(x, beta, type='l', lty=c(1,1,2,2,3), lwd=c(1,3,1,1,3), col=4
				, main=paste0('degradation\n',pValues['degradation']), xaxt='n', xlab='time', ylab='', ylim=degradationYlim)
			axis(1, at=x, labels=signif(tpts, 2), las=3)

		} else {

			x <- seq_along(tpts)

			par(mfrow=c(1,5), mar=.1+c(5,2.5,4,.5))
			matplot(x, total, type='l', lty=c(1,2,2,1), lwd=c(1,1,1,3)
				, col=1, main='total RNA', xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)

			functionTmp <- function()
			{
				matplot(x, preMRNA, type='l', lty=c(1,2,2,1), lwd=c(1,1,1,3)
					, col=2, main='pre-RNA', xaxt='n', xlab='time', ylab='')
				axis(1, at=x, labels=signif(tpts, 2), las=3)			
			}
			tryCatch(functionTmp(),error=function(e)NaN)

			matplot(x, alpha, type='l', lty=c(1,1,2,2,3), lwd=c(1,3,1,1,3)
				, col=3, main=paste0('synthesis\n',pValues['synthesis']), xaxt='n', xlab='time', ylab='')		
			axis(1, at=x, labels=signif(tpts, 2), las=3)

			functionTmp <- function()
			{
				matplot(x, gamma, type='l', lty=c(1,1,2,2,3), lwd=c(1,3,1,1,3), col=5
					, main=paste0('processing\n',pValues['processing']), xaxt='n', xlab='time', ylab='')
				axis(1, at=x, labels=signif(tpts, 2), las=3)		
			}

			tryCatch(functionTmp(),error=function(e)NaN)

			matplot(x, beta, type='l', lty=c(1,1,2,2,3), lwd=c(1,3,1,1,3), col=4
				, main=paste0('degradation\n',pValues['degradation']), xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)
		}

	} else {

		total <- t(rbind(
			ratesFirstGuessTotalTmp
			, ratesFirstGuessTotalTmp + 
				sqrt(ratesFirstGuessTotalVarTmp)
			, ratesFirstGuessTotalTmp - 
				sqrt(ratesFirstGuessTotalVarTmp)
			))
		preMRNA <- t(rbind(
			ratesFirstGuessPreTmp
			, ratesFirstGuessPreTmp + 
				sqrt(ratesFirstGuessPreVarTmp)
			, ratesFirstGuessPreTmp - 
				sqrt(ratesFirstGuessPreVarTmp)
			))
		if(!oneGene@NoNascent)
		{
			alpha <- t(rbind(
				ratesFirstGuessSynthesisTmp
				, ratesFirstGuessSynthesisTmp + 
					sqrt(ratesFirstGuessSynthesisVarTmp)
				, ratesFirstGuessSynthesisTmp - 
					sqrt(ratesFirstGuessSynthesisVarTmp)
				))
		}else{
		alpha <- t(rbind(
			ratesFirstGuessSynthesisTmp
			))			
		}
		beta <- t(rbind(
			ratesFirstGuessDegradationTmp
			))
		gamma <- t(rbind(
			ratesFirstGuessProcessingTmp
			))

		pValues <- c('synthesis'=NA,'processing'=NA,'degradation'=NA)

		if( fix.yaxis ) {

			degradationYlim <- quantile(ratesFirstGuess(oneGene, 'degradation'), probs=c(.02, .98), na.rm=TRUE)
			processingYlim <- quantile(ratesFirstGuess(oneGene, 'processing'), probs=c(.02, .98), na.rm=TRUE)
			
			x <- seq_along(tpts)

			par(mfrow=c(1,5), mar=.1+c(5,2.5,4,.5))
			matplot(x, total, type='l', lty=c(1,2,2), lwd=c(1,1,1)
				, col=1, main='total RNA', xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)
			
			functionTmp <- function()
			{
			matplot(x, preMRNA, type='l', lty=c(1,2,2), lwd=c(1,1,1)
				, col=2, main='pre-RNA', xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)				
			}
			tryCatch(functionTmp(),error=function(e)NaN)

			matplot(x, alpha, type='l', lty=c(1,2,2), lwd=c(1,1,1)
				, col=3, main=paste0('synthesis\n',pValues['synthesis']), xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)

			functionTmp <- function()
			{
				matplot(x, gamma, type='l', lty=c(1), lwd=c(1), col=5
					, main=paste0('processing\n',pValues['processing']), xaxt='n', xlab='time', ylab='', ylim=processingYlim)
				axis(1, at=x, labels=signif(tpts, 2), las=3)		
			}
			tryCatch(functionTmp(),error=function(e)NaN)

			matplot(x, beta, type='l', lty=c(1), lwd=c(1), col=4
				, main=paste0('degradation\n',pValues['degradation']), xaxt='n', xlab='time', ylab='', ylim=degradationYlim)
			axis(1, at=x, labels=signif(tpts, 2), las=3)
		} else {
			
			x <- seq_along(tpts)

			par(mfrow=c(1,5), mar=.1+c(5,2.5,4,.5))
			matplot(x, total, type='l', lty=c(1,2,2), lwd=c(1,1,1)
				, col=1, main='total RNA', xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)

			functionTmp <- function()
			{
				matplot(x, preMRNA, type='l', lty=c(1,2,2), lwd=c(1,1,1)
					, col=2, main='pre-RNA', xaxt='n', xlab='time', ylab='')
				axis(1, at=x, labels=signif(tpts, 2), las=3)
			}
			tryCatch(functionTmp(),error=function(e)NaN)

			matplot(x, alpha, type='l', lty=c(1,2,2), lwd=c(1,1,1)
				, col=3, main=paste0('synthesis\n',pValues['synthesis']), xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)

			functionTmp <- function()
			{
				matplot(x, gamma, type='l', lty=c(1), lwd=c(1), col=5
					, main=paste0('processing\n',pValues['processing']), xaxt='n', xlab='time', ylab='')
				axis(1, at=x, labels=signif(tpts, 2), las=3)		
			}

			tryCatch(functionTmp(),error=function(e)NaN)

			matplot(x, beta, type='l', lty=c(1), lwd=c(1), col=4
				, main=paste0('degradation\n',pValues['degradation']), xaxt='n', xlab='time', ylab='')
			axis(1, at=x, labels=signif(tpts, 2), las=3)
		}

	}

	par(mfrow=oldMfrow, mar=oldMar)
	out <- list(total=total, premature=preMRNA, synthesis=alpha, processing=gamma, degradation=beta)

	})
