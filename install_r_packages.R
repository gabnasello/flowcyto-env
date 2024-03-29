options(unzip = 'internal') # not sure it is necessary, put it here after looking at https://github.com/r-lib/devtools/issues/1722#issuecomment-370019534
options(install.packages.compile.from.source = 'always')
update.packages(ask=FALSE, repos='https://ftp.gwdg.de/pub/misc/cran/')

install.packages('IRkernel',repos = 'http://cran.us.r-project.org')
IRkernel::installspec(user = FALSE)

# Install Cytoverse
remotes::install_github("RGLab/cytoverse")
cytoverse::cytoverse_update(upgrades_approved=TRUE)

# Install cytoqc, which is not in Bioconductor
remotes::install_github("RGLab/cytoqc")

# Install CytoExploreR
# CytoExploreRData 
devtools::install_github("DillonHammill/CytoExploreRData")
# CytoExploreR 
devtools::install_github("DillonHammill/CytoExploreR")

# Spectral_Flow_Workflow requirements
# [https://github.com/HdBraanker/Spectral_Flow_Workflow]
BiocManager::install("flowViz")
BiocManager::install("flowVS")
BiocManager::install("FlowSOM")
BiocManager::install("CATALYST")
BiocManager::install("SingleCellExperiment")

devtools::install_github('saeyslab/CytoNorm')
install.packages("uwot",repos = 'http://cran.us.r-project.org')
install.packages("knitr",repos = 'http://cran.us.r-project.org')
install.packages("xlsx",repos = 'http://cran.us.r-project.org')