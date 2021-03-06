#' @title Sort data and remove missing entries for tree and trait data
#' @description Plots a phylogeny with lines representing the value of a continuous trait
#' @param y A matrix of trait values with taxon names as rownames. Missing values should be NA
#' @param phy An object of class "phylo" or "multiPhylo" (see ape package).
#' @param log.trait Logical. If TRUE, data are log-transformed
#' @return phy Tree with missing data pruned
#' @return trait Rearranged data with missing species removed
#' @author Mark Puttick
#' @examples 
#' data(anolis.tree)
#' data(anolis.data)
#' attach(anolis.data)
#' male.length <- matrix(Male_SVL, dimnames=list(rownames(anolis.data)))
#' any(is.na(male.length[,1]))
#' data.sorted <- sortTraitData(anolis.tree, male.length)
#' phy <- data.sorted[[1]]
#' male.length <- data.sorted[[2]]
#' @export

sortTraitData <- function(phy, y, log.trait=TRUE) {
	
	
	trait.data <- y
	
	if(class(phy) == "multiPhylo") {
		tree <- phy
		phy <- phy[[1]]
		multi.phy <- TRUE
	} else {
		multi.phy <- FALSE
	}
			
	phy.names <- phy$tip.label
	trait.names <- rownames(trait.data)
	missing <- which(is.na(trait.data))
	dat.trait <- matrix(trait.data[-missing], dimnames=list(trait.names[-missing]))
	rm.tip <- match(phy.names, rownames(dat.trait))
	if(multi.phy) {
		red.phy <- lapply(tree, function(x) drop.tip(x, phy.names[which(is.na(rm.tip))]))
		class(red.phy) <- "multiPhylo"
		trait <- dat.trait[match(red.phy[[1]]$tip.label, rownames(dat.trait)), ]
		} else {
		red.phy <- drop.tip(phy, phy.names[which(is.na(rm.tip))])
		trait <- dat.trait[match(red.phy$tip.label, rownames(dat.trait)), ]
	}	
	
	if(log.trait) trait <- log(trait)
	out <- list()
	out$phy <- red.phy
	out$trait <- as.matrix(trait)
	return(out)
}