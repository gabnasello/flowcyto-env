options(unzip = "internal") # not sure it is necessary, put it here after looking at https://github.com/r-lib/devtools/issues/1722#issuecomment-370019534
options(install.packages.compile.from.source = 'always')
update.packages(ask=FALSE, repos='https://ftp.gwdg.de/pub/misc/cran/')

install.packages('devtools',repos = "http://cran.us.r-project.org")
install.packages('repr',repos = "http://cran.us.r-project.org")
install.packages('svglite',repos = "http://cran.us.r-project.org")
install.packages('latex2exp',repos = "http://cran.us.r-project.org")
install.packages('rstatix',repos = "http://cran.us.r-project.org")
install.packages('ggpubr',repos = "http://cran.us.r-project.org")
install.packages('ggsci',repos = "http://cran.us.r-project.org")

# avoid update of other packages
# remotes::install_github("RGLab/cytoqc")

# Install R kernel for Jupyter Notebook
install.packages('IRdisplay',repos = 'http://cran.us.r-project.org')
install.packages('IRkernel',repos = 'http://cran.us.r-project.org')
IRkernel::installspec(user = FALSE)