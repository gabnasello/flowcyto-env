options(unzip = "internal") # not sure it is necessary, put it here after looking at https://github.com/r-lib/devtools/issues/1722#issuecomment-370019534
options(install.packages.compile.from.source = 'always')

update.packages(ask=FALSE, repos='https://ftp.gwdg.de/pub/misc/cran/')

# To install from the stable Bioconductor releases of cytoverse:
# https://cytoverse.org/install/index.html
remotes::install_github("RGLab/cytoverse")
cytoverse::cytoverse_update(upgrades_approved = TRUE)

# Install cytoinstaller and avoid any issue related to GitHub API tokens
#remotes::install_github("RGLab/cytoinstaller")
#system('wget https://github.com/RGLab/cytoinstaller/archive/refs/heads/master.zip')
#system('unzip master.zip')
#system('mv cytoinstaller-master/ cytoinstaller//')
#system('R CMD build cytoinstaller')
#install.packages(list.files(pattern="[cytoinstaller]*.tar.gz"), repos = NULL)
#system('rm -rf master.zip cytoinstaller/ cytoinstaller*.tar.gz')
# Install cytoverse packages
#cytoinstaller::install_cyto(bioc_ver = "devel")

# Install CytoExploreR and avoid any issue related to GitHub API tokens
devtools::install_github("DillonHammill/CytoExploreR")
#system('wget https://github.com/DillonHammill/CytoExploreR/archive/refs/heads/master.zip')
#system('unzip master.zip')
#system('mv CytoExploreR-master/ CytoExploreR//')
#system('R CMD build CytoExploreR')
#install.packages(list.files(pattern="[CytoExploreR]*.tar.gz"), repos = NULL)
#system('rm -rf master.zip CytoExploreR/ CytoExploreR*.tar.gz')

# Install CytoExploreRData and avoid any issue related to GitHub API tokens
devtools::install_github("DillonHammill/CytoExploreRData")
#system('wget https://github.com/DillonHammill/CytoExploreRData/archive/refs/heads/master.zip')
#system('unzip master.zip')
#system('mv CytoExploreRData-master/ CytoExploreRData//')
#system('R CMD build CytoExploreRData')
#install.packages(list.files(pattern="[CytoExploreRData]*.tar.gz"), repos = NULL)
#system('rm -rf master.zip CytoExploreRData/ CytoExploreRData*.tar.gz')