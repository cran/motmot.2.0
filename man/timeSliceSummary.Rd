% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timeSliceSummary.R
\name{timeSliceSummary}
\alias{timeSliceSummary}
\title{Identify shifts in the rate of trait diversification through time}
\usage{
timeSliceSummary(timeSliceObject, cutoff = 4, AICc = TRUE,
  lowerBound = 1e-08, upperBound = 1000, plot.phylo = TRUE, cex.tip = 1,
  tip.offset = 1, phylo.width = 1, tip.colour = "grey50",
  colour.ramp = c("blue", "red"))
}
\arguments{
\item{timeSliceObject}{Output of a timeSlice analysis in transformPhylo.ML}

\item{cutoff}{Cutoff value for differences in AIC scores when comparing models. More complex models with an AIC score more than this number of units lower than simpler models are retained (as per runMedusa in the geiger package).}

\item{AICc}{If true, AICc is used instead of AIC.}

\item{lowerBound}{Minimum value for parameter estimates.}

\item{upperBound}{Maximum value for parameter estimates.}

\item{plot.phylo}{Logical. If TRUE, the phylogeny is plotted}

\item{cex.tip}{The character size of tip labels}

\item{tip.offset}{the distance tip labels should be printed from pendant edges}

\item{phylo.width}{The width of edges on the phylogeny}

\item{tip.colour}{Colour of species' tip labels}

\item{colour.ramp}{The colours signifying different rates from low (first colour) to high (second colour)}
}
\value{
ModelFit Summary of the best optimal rate shift model.

Rates Summary of the rate parameters from the best rate shift model.

optimalTree A phylo object with branch lengths scaled relative to rate.
}
\description{
Summarises phenotypic rate variation on phylogenies through
}
\details{
This functions summarises the output of a "timeSlice" model in transformPhylo.ML (see below). The best overall model is chosen based on AIC (or AICc if AICc=TRUE). The cut-off point for improvement in AIC score between successively more complex models can be defined using cutoff. The default cutoff is 4 but this is somewhat arbitrary and a "good" cut-off may well vary between data sets so it may well be worth exploring different cutoffs.
}
\examples{
data(anolis.tree)
data(anolis.data)
attach(anolis.data)
male.length <- matrix(Male_SVL, dimnames=list(rownames(anolis.data)))
sortedData <- sortTraitData(anolis.tree, male.length)
phy <- sortedData$phy
male.length <- sortedData$trait
phy.clade <- extract.clade(phy, 182)
male.length.clade <- as.matrix(male.length[match(phy.clade$tip.label, 
rownames(male.length)),])
timeSlice.10.ml <- transformPhylo.ML(y=male.length.clade, phy=phy.clade, model="timeSlice", 
splitTime=c(10))
outputSummary <- timeSliceSummary(timeSlice.10.ml, cutoff=0.001, cex.tip=0.5, 
phylo.width=2, colour.ramp=c("blue", "red"))
}
\references{
To Add
}
\author{
Mark Puttick
}
