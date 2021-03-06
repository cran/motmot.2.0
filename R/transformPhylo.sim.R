#' @title Phylogenetic tree transformations
#' @description Transforms the branch lengths of a phylo object according to a model of trait evolution (see details).
#' @param phy An object of class "phylo" (see ape package).
#' @param n Number of simulations
#' @param x Vector, matrix or data.frame (with taxon names as names or rownames) of categories for each species. Only applicable if model="mixedRate" 
#' @param model The model of trait evolution (see details).
#' @param kappa Value of kappa transform.
#' @param lambda Value of lambda transform.
#' @param delta Value of delta transform.
#' @param alpha Value of alpha (OU) transform.
#' @param psi Value of psi transform.  Note that 'original nodes' from the full phylogeny can be included as an element on the phylogeny (e.g., phy$orig.node) as well as estimates of 'hidden' speciation (e.g., phy$hidden.speciation) if estimates of extinction (mu) are > 0.
#' @param lambda.sp Estimate of speciation (lambda) for the psi models
#' @param splitTime A split time (measured from the present, or most recent species) at which a shift in the rate occurs for the "timeSlice" model
#' @param timeRates The rates (from ancient to recent) for the timeSlice model
#' @param nodeIDs Integer - ancestral nodes of clades.
#' @param rateType If model="clade", a vector specifying if rate shift occurs in a clade ("clade") or on the single branch leading to a clade ("branch").
#' @param acdcRate Value of ACDC transform.
#' @param branchLabels Branches on which different psi parameters are estimated in the "multipsi" model.
#' @param branchRates Numeric vector specifying relative rates for individual branches
#' @param cladeRates Numeric vector specifying telative rates for clades.
#' @param rate a vector of relative rate parameters. The length of the vector is equal to the number of rates being estimated. 
#' @param group.means a vector of the relative difference in means between rate categories, expressed as a scalar applied to the expected standard deviation (see Ricklefs 2006)
#' @return Returns a matrix of simulated dated with taxon names as rownames (number of columns=n).
#' @references Ricklefs RE. 2006. Time, species, and the generation of trait variation in clades. Systematic Biology 55, 151-159.
#' @references Ricklefs RE. 2006. Thomas GH, Meiri S, & Phillimore AB. 2009. Body size diversification in Anolis: novel environments and island effects. Evolution 63, 2017-2030
#' @author Gavin Thomas, Mark Puttick
#' @examples
#' data(anolis.tree)
#' data(anolis.data)
#' 
#' # Simulate 10 sets of data with kappa=0.1 using the anolis tree
#' sim.dat1 <- transformPhylo.sim(phy=anolis.tree, n=10, model="kappa", kappa=0.1)
#' 
#' # Simulate 10 sets of data where rates and means differ between to the categories defined by "x"
#' x <- anolis.data$geo_ecomorph
#' names(x) <-  rownames(anolis.data)
#' sim.dat2 <- transformPhylo.sim(phy=anolis.tree, n=10, x=x, model="mixedRate", rate=c(1,1,2,4),
#' group.means=c(0,5,0,0))
#' @export

transformPhylo.sim <- function(phy, n=1, x=NULL, model=NULL, kappa=NULL, lambda=NULL, delta=NULL, alpha=NULL, psi=NULL, acdcRate=NULL, lambda.sp = NULL, nodeIDs=NULL, rateType=NULL, cladeRates=NULL, branchRates=NULL, rate=NULL, group.means=NULL, splitTime=NULL, timeRates=NULL, branchLabels = NULL) {
	
	switch(model,		  
		   
		   "bm" = {
					transformPhy <- phy
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)
					},
		   
		   "kappa" = {
					transformPhy <- transformPhylo(phy=phy, model="kappa", kappa=kappa, nodeIDs=nodeIDs)
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)
					},
		   
		   "lambda" = {
					transformPhy <- transformPhylo(phy=phy, model="lambda", lambda=lambda)
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)
					},
		   
		   "delta" = {
					transformPhy <- transformPhylo(phy=phy, model="delta", delta=delta, nodeIDs=nodeIDs)
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)
					},
					
		   "free" = {
					transformPhy <- transformPhylo(phy=phy, model="free", branchRates=branchRates)
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)		
					},
		   
		   "clade" = {
					transformPhy <- transformPhylo(phy=phy, model="clade", nodeIDs=nodeIDs, cladeRates=cladeRates, rateType=rateType)
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)
					},
		   
		   "OU" = {
					transformPhy <- transformPhylo(phy=phy, model="OU", alpha=alpha, nodeIDs=nodeIDs)
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)
					},
			"ACDC" = {
					transformPhy <- transformPhylo(phy=phy, model="ACDC", acdcRate=acdcRate, nodeIDs=nodeIDs, cladeRates=cladeRates)
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)
					},
		   "psi" = {
					transformPhy <- transformPhylo(phy = phy, model = "psi", psi = psi, lambda.sp = lambda.sp)
					phyMat <- VCV.array(transformPhy)
					attr(phyMat, "class") <- "matrix"
					ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
					rownames(ydum) <- rownames(phyMat)
					},
			"multipsi" = {
       				transformPhy <- transformPhylo(phy = phy, model = "multipsi", psi = psi, lambda.sp = lambda.sp, branchLabels = branchLabels)
       				phyMat <- VCV.array(transformPhy)
       				attr(phyMat, "class") <- "matrix"
        			ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
        			rownames(ydum) <- rownames(phyMat)
    				},
					
			"timeSlice" = {
				phy2 <- phy	   
		   		transformPhy <- transformPhylo.sim(phy=phy, model="timeSlice", splitTime=splitTime, timeRates=timeRates)
		   		phyMat <- VCV.array(transformPhy)
				attr(phyMat, "class") <- "matrix"
				ydum <- as.matrix(t(rmvnorm(n, sigma = phyMat)))
				rownames(ydum) <- rownames(phyMat)
		   		} ,

			"mixedRate" = {
        			x <- as.matrix(x)
		        dat <- data.frame(x = x, y = rep(0, length(x[, 1])))
		        rateData <- as.rateData(y = "y", x = "x", rateMatrix = NULL, phy = phy, data = dat)
		        V <- transformRateMatrix(rateData, rate = rate)
		        expect.sd <- sqrt(mean(V[upper.tri(V)]))
		        if (is.null(group.means)) {
		            ydum <- as.matrix(t(rmvnorm(n, sigma = (V))))
		            rownames(ydum) <- rownames(V)
		        } else {
		            x.means <- unique(rateData$x)
		            n.means <- length(x.means)
		            samp.means <- rep(NA, length(rateData$x))
		            ydum <- vector(mode = "list", length = length(group.means))
		            for (i in 1:n.means) {
		                samp.means[which(rateData$x == (i - 1))] <- rep(0 +
		                (expect.sd * group.means[i]), length(which(rateData$x ==
		                (i - 1))))
		            }
		            ydum <- as.matrix(t(rmvnorm(n, mean = samp.means,
		            sigma = (V))))
		            rownames(ydum) <- rownames(V)
		       		}
		       	}
		   )
	return(ydum)
}
