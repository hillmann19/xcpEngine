#!/usr/bin/env Rscript

###################################################################
#  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  #
###################################################################

###################################################################
# This script inputs an image and returns all unique values found
# in that image.
###################################################################

###################################################################
# Load required libraries
###################################################################
suppressMessages(suppressWarnings(library(optparse)))
suppressMessages(suppressWarnings(library(pracma)))
suppressMessages(suppressWarnings(library(RNifti)))

###################################################################
# Parse arguments to script, and ensure that the required arguments
# have been passed.
###################################################################
option_list = list(
   make_option(c("-i", "--img"), action="store", default=NA, type='character',
              help="Path to the input image. unique will return all
                  unique values in the input image.")
)
opt = parse_args(OptionParser(option_list=option_list))

if (is.na(opt$img)) {
   cat('User did not specify an input image.\n')
   cat('Use unique.R -h for an expanded usage menu.\n')
   quit()
}

refImgPath           <- opt$img
sink("/dev/null")

###################################################################
# Read input image
###################################################################
refImg               <- readNifti(refImgPath)
refImg               <- refImg[refImg!=0]
uniq                 <- sort(unique(refImg))

sink(file=NULL)

for (i in 1:length(uniq)) {
   cat(uniq[i],'\n',sep='')
}
