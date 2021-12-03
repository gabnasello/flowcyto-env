options(unzip = "internal") # not sure it is necessary, put it here after looking at https://github.com/r-lib/devtools/issues/1722#issuecomment-370019534
options(install.packages.compile.from.source = 'always')

update.packages(ask=FALSE, repos='https://ftp.gwdg.de/pub/misc/cran/')

# To install from the stable Bioconductor releases of cytoverse:
# https://cytoverse.org/install/index.html
remotes::install_github("RGLab/cytoverse")
cytoverse::cytoverse_update(upgrades_approved = TRUE)

# Install CytoExploreR and avoid any issue related to GitHub API tokens
devtools::install_github("DillonHammill/CytoExploreR")

# Install CytoExploreRData and avoid any issue related to GitHub API tokens
devtools::install_github("DillonHammill/CytoExploreRData")