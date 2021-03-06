% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/transformPhylo.ML.R
\name{transformPhylo.ML}
\alias{transformPhylo.ML}
\title{Maximum likelihood for models of trait evoluion}
\usage{
transformPhylo.ML(y, phy, model = NULL, modelCIs = TRUE, nodeIDs = NULL,
  rateType = NULL, minCladeSize = 1, nSplits = 2, splitTime = NULL,
  boundaryAge = 10, testAge = 1, restrictNode = NULL, lambdaEst = FALSE,
  acdcScalar = FALSE, branchLabels = NULL, hiddenSpeciation = FALSE,
  full.phy = NULL, useMean = FALSE, profilePlot = FALSE,
  lowerBound = NULL, upperBound = NULL, covPIC = TRUE, n.cores = 1,
  tol = NULL, meserr = NULL, controlList = c(fnscale = -1, maxit = 100,
  factr = 1e-07, pgtol = 0, type = 2, lmm = 5), returnPhy = FALSE)
}
\arguments{
\item{y}{A matrix of trait values.}

\item{phy}{An object of class "phylo" (see ape package).}

\item{model}{The model of trait evolution (see details).}

\item{modelCIs}{Logical - estimate confidence intervals for parameter estimates.}

\item{nodeIDs}{Integer - ancestral nodes of clades applicable to rate heterogenous and nested models of evolution (see details)}

\item{rateType}{If model="clade", a vector specifying if rate shift occurs in a clade ("clade") or on the single branch leading to a clade ("branch").}

\item{minCladeSize}{Integer - minimum clade size for inferred rate shift (where model="medusa").}

\item{nSplits}{Integer - number of rate shifts to apply for model="medusa" and "timeSlice".}

\item{splitTime}{A split time (measured from the present, or most recent species) at which a shift in the rate occurs for the "timeSlice" model. If splitTime = NULL, then all ages between 1 million year intervals from the root age - 10 Ma to the present + 10 Ma will be included in the search. The best model will be retained in each search, and will be used as a fixed age in the next search. The model will calculate the likelihood for the number of shifts defined by 'nSplits'.}

\item{boundaryAge}{Only applicable if splitTime = NULL, the age distance from the tips and and youngest tip for which to search for rate shifts. For example, if boundaryAge = 10, only ages between the root age - 10 and the latest tip + 10 will be included in the search. Set to zero to allow testing of all ages.}

\item{testAge}{If splitTime = NULL, the interval between ages to be tested. For example, if testAge = 1, all 1 Ma ages between the ages defined by 'boundaryAge' will be tested.}

\item{restrictNode}{List defining monophyletic groups within which no further rate shifts are searched.}

\item{lambdaEst}{Logical.  Estimate lambda alongside parameter estimates to reduce data noise. Only applicable for models "kappa", "delta", "OU", "psi", "multispi", and "ACDC". Default=FALSE.}

\item{acdcScalar}{Logical.  For nested EB rate model, simultaneously estimated a rate scalar alongside EB model. Default=FALSE.}

\item{branchLabels}{Branches on which different psi parameters are estimated in the "multipsi" model}

\item{hiddenSpeciation}{Logical. If TRUE the psi model will include nodes that are on the 'full.phy' but not the tree pruned of trait data}

\item{full.phy}{The full phylogeny containing the species that do not contain trait data so are not included in 'phy'}

\item{useMean}{Logical. Use the branch-based estimates of extinction of mean (TRUE, default) for the "psi" and "multispi" models only applicable if "hiddenSpeciation" = TRUE}

\item{profilePlot}{Logical.  For the single parameter models "kappa", "lambda", "delta", "OU", "psi", "multipsi", and "ACDC", plot the profile of the likelihood.}

\item{lowerBound}{Minimum value for parameter estimates}

\item{upperBound}{Maximum value for parameter estimates}

\item{covPIC}{Logical. For multivariate analyses, allow for co-variance between traits rates (TRUE) or no covariance in trait rates (FALSE). If FALSE, only the trait variances not co-variances are used.}

\item{n.cores}{Integer. Set number of computing cores when running model="traitMedusa" (tm1 and tm2 models)}

\item{tol}{Tolerance (minimum branch length) to exclude branches from trait MEDUSA search. Primarily intended to prevent inference of rate shifts at randomly resolved polytomies.}

\item{meserr}{A vector (or matrix) of measurement error for each tip. This is only applicable to univariate analyses. Largely untested - please use cautiously}

\item{controlList}{List. Specify fine-tune parameters for the optim likelihood search}

\item{returnPhy}{Logical. In TRUE the phylogeny with branch lengths transformed by the ML model parameters is returned}
}
\value{
Returns the maximum log-likelihood and parameter estimates (with 95 percent confidence intervals if specified). If model="bm" instead returns the Brownian (co)variance and log-likelihood.

traitMedusaObject A list in which the first element contains a matrix summarising the parameter estimates and node ids, log-likelihoods, number of parameters (k), AIC and AICc for the best one-rate model, two-rate model, three rate model and so on. The second element is a sub-list where the first element contains all two-rate models, the second element contains all three-rate models and so on. This can be summarised using traitMedusaSummary. The third element is the input trait data. The fourth element is the input phylogeny.
}
\description{
Fits likelihood models for various models of continuous character evolution. Model fitting is based on maximum-likelihood evaluation using phylogenetically independent contrasts. This is exactly equivalent to, but substantially faster than, GLS approaches.
}
\details{
This function finds the maximum likelihood parameter values for continuous character evolution. For "kappa", "delta", "OU", "multipsi", and "ACDC" it is possible to fit a 'nested' model of evolution in which the ancestral rate of BM swicthes to a different node, as specified by nodeIDs or branchLabels for multipsi. The function returns the maximum-likelihood parameter estimates for the following models.
\itemize{
\item {model="bm"} {Brownian motion (constant rates random walk).}
\item {model="kappa"} {fits Pagel's kappa by raising all branch lengths to the power kappa. As kappa approaches zero, trait change becomes focused at branching events. For complete phylogenies, if kappa approaches zero this infers speciational trait change. Default bounds from ~0 - 1.}
\item {model="lambda"} {fits Pagel's lambda to estimate phylogenetic signal by multiplying all internal branches of the tree by lambda, leaving tip branches as their original length (root to tip distances are unchanged). Default bounds from ~0 - 1.}
\item {model="delta"} {fits Pagel's delta by raising all node depths to the power delta. If delta <1, trait evolution is concentrated early in the tree whereas if delta >1 trait evolution is concentrated towards the tips. Values of delta above one can be difficult to fit reliably. If a nodeIDs is supplied, the model will fit a delta model nested within a clade, with a BM fit to the rest of the tree. Default bounds from ~0 - 5.}
\item {model="OU"} {fits an Ornstein-Uhlenbeck model - a random walk with a central tendency proportional to alpha. High values of alpha can be interpreted as evidence of evolutionary constraints, stabilising selection or weak phylogenetic signal. It is often difficult to distinguish among these possibilities. If a nodeIDs is supplied, the model will fit a OU model nested within a clade, with a BM fit to the rest of the tree. For OU models, alternative optimisation are performed with different starting values (1e-8, 0.01, 0.1, 1, 5). Default bounds from ~0 - 10.}
\item {model="ACDC"} {fits a model to in which rates can exponentially increased or decrease through time (Blomberg et al. 2003). If the upper bound is < 0, the model is equivalent to the 'Early Burst' model of Harmon et al. 2010. If a nodeIDs is supplied, the model will fit a ACDC model nested within a clade, with a BM fit to the rest of the tree. Default rate parameter bounds from ln(1e-10) ~ ln(20) divided by the root age. Note this process starts on the stem branch leading to the MRCA of the common node, unlike the other methods that start at the common node.}
\item {model="psi"} {fits a acceleration-deacceleration model to assess to the relative contributions of speciation and gradual evolution to a trait's evolutionary rate (Ingram 2010). Note that the algorithm will automatically estimate speciation and extinction estimates, and will incorporate estimates of 'hidden' speciation if death estimates are greater than 0. }
\item {model="multiPsi"} {fits a acceleration-deacceleration model to assess to the relative contributions of speciation and gradual evolution to a trait's evolutionary rate but allows seperate values of psi fitted to seperate branches (Ingram 2010; Ingram et al. 2016). Note that the algorithm will automatically estimate speciation and extinction estimates, and will incorporate estimates of 'hidden' speciation if death estimates are greater than 0.}
\item {model="free"} {fits Mooers et al's free model where each branch has its own rate of trait evolution. This can be a useful exploratory analysis but it is slow due to the number of parameters, particularly for large trees. Default rate parameter bounds from ~0 - 200.}
\item {model="clade"} {fits a model where particular clades are a priori hypothesised to have different rates of trait evolution (see O'Meara et al. 2006; Thomas et al. 2006, 2009). Clades are specified using nodeIDs and are defined as the mrca node. Default rate parameter bounds from ~0 - 200.}
\item {model="tm1"} {fits "clade" models without any a priori assertion of the location of phenotypic diversification rate shifts. It uses the same AIC approach as the runMedusa function in the geiger package (runMedusa tests for shifts in the rate of lineage diversification). The algorithm first fits a constant-rate Brownian model to the data, it then works iteratively through the phylogeny fitting a two-rate model at each node in turn. Each two-rate model is compared to the constant rate model and the best two-rate model is retained. Keeping the location of this rate shift intact, it then repeats the procedure for a three-rate model and so on. The maximum number of rate shifts can be specified a priori using nSplits. Limits can be applied to the size (species richness) of clades on which to infer new rate shifts using minCladeSize. This can be useful to enable large trees to be handled but should be used cautiously since specifiying a large minimum clade size may result in biologically interesting nested rate shifts being missed. Equally, very small clade sizes may provide poor estimates of rate that may not be informative. Limits on the search can also be placed using restrictNode. This requires a list where each element of the list is a vector of tip names that define monophyletic groups. Rate shifts will not be searched for within any of the defined groups. Default rate parameter bounds from ~0 - 1000.}
\item {model="tm2"} {this model is similar to "tm1", however, at each node it assesses the fit of two models. The first model is exactly as per "tm1". The second model infers a rate shift on the single branch descending directly from a node but not on any of the descending branches thereafter. Only the best fitting single-branch or whole clade model is retained for the next iteration. If a single-branch shift is favoured, this infers either that there was a rapid shift in trait value along the stem leading to the crown group, or that the members of the clade have undergone parallel shifts. In either case, this can be considered as a change in mean, though separating a single early shift from a clade-parallel shift is not possible with this method. }
\item {model="timeSlice"} {A model in which all branch rates change at a time or times set a priori by the user. If  Default rate parameter bounds from ~0 - 1000. If splitTime=NULL, all 1 Ma (as defined by test Age) intervals from the root of the tree - 10 and the youngest tip + 10 will be included in the search. The +/- 10 Ma age can be modified using the argument boundaryAge. At each stage the best fitting model will be stored, and the search will continue until n shifts, with n shifts defined by nSplits. If a single value or vector is used for splitTime, only these ages are included in the search.}
}
}
\note{
Confidence intervals are based on the assumption of an asymptotic Chi-square distribution. For multi-parameter models (e.g. rate shift models with more than two rates) the confidence intervals are approximate and are calculated for each parameter in turn while holding all other parameters at their maximum likelihood value.
}
\examples{
# Data and phylogeny
data(anolis.tree)
data(anolis.data)
attach(anolis.data)
male.length <- matrix(Male_SVL, dimnames=list(rownames(anolis.data)))
sortedData <- sortTraitData(anolis.tree, male.length)
phy <- sortedData$phy
male.length <- sortedData$trait
phy.clade <- extract.clade(phy, 182)
male.length.clade <- as.matrix(male.length[match(phy.clade$tip.label, rownames(male.length)),])

# Brownian motion model
transformPhylo.ML(male.length.clade , phy=phy.clade, model="bm")

# Delta
transformPhylo.ML(male.length.clade , phy=phy.clade, model="delta", upperBound=2)

# The upper confidence interval for kappa is outside the bounds so try increasing
# the upper bound

transformPhylo.ML(male.length.clade , phy=phy.clade, model="delta", upperBound=5)

# Test for different rates in different clades - here with 2 hypothesised
# unusual rates compared to the background

# This fits the non-censored model of O'Meara et al. (2006)
phy.clade$node.label[which(phy.clade$node.label == "3")] <- 2
transformPhylo.ML(male.length.clade, phy=phy.clade, model="clade", nodeIDs=c(49, 54))

# Identify rate shifts and print and plot results with upto three rate shifts
# and minimum clade size of 20.
anolisSVL_MEDUSA <- transformPhylo.ML(male.length.clade, phy=phy.clade, model="tm1",
minCladeSize=10, nSplits=2)
}
\references{
Alfaro ME, Santini F, Brock CD, Alamillo H, Dornburg A, Carnevale G, Rabosky D & Harmon LJ. 2009. Nine exceptional radiations plus high turnover explain species diversity in jawed vertebrates. PNAS 106, 13410-13414.

Blomberg SP, Garland T & Ives AR 2003. Testing for phylogenetic signal in comparative data: behavioral traits are more labile. Evolution 57, 717-745.

Felsenstein J. 1973. Maximum-likelihood estimation of evolutionary trees from continuous characters. Am. J. Hum. Genet. 25, 471-492.

Felsenstein J. 1985. Phylogenies and the comparative method. American Naturalist 125, 1-15.

Freckleton RP & Jetz W. 2009. Space versus phylogeny: disentangling phylogenetic and spatial signals in comparative data. Proc. Roy. Soc. B 276, 21-30.

Harmon LJ et al. 2010. Early bursts of body size and shape evolution are rare in comparative data. Evolution 57, 717-745.

Ingram T. 2011. Speciation along a depth gradient in a marine adaptive radiation. Proc. Roy. Soc. B. 278, 613-618.

Ingram T,  Harrison AD, Mahler L, Castaneda MdR, Glor RE, Herrel A, Stuart YE, and Losos JB. 2016. Comparative tests of the role of dewlap size in Anolis lizard speciation. Proc. Roy. Soc. B. 283, 20162199.

Mooers AO, Vamosi S, & Schluter D. 1999. Using phylogenies to test macroevolutionary models of trait evolution: sexual selection and speciation in Cranes (Gruinae). American Naturalist 154, 249-259.

O'Meara BC, Ane C, Sanderson MJ & Wainwright PC. 2006. Testing for different rates of continuous trait evolution using likelihood. Evolution 60, 922-933

Pagel M. 1997. Inferring evolutionary processes from phylogenies. Zoologica Scripta 26, 331-348.

Pagel M. 1999 Inferring the historical patterns of biological evolution. Nature 401, 877-884.

Pagel M. 1999 Inferring the historical patterns of biological evolution. Nature 401, 877-884.

Thomas GH, Meiri S, & Phillimore AB. 2009. Body size diversification in Anolis: novel environments and island effects. Evolution 63, 2017-2030.
}
\author{
Gavin Thomas, Mark Puttick
}
