#! /usr/bin/env Rscript

################################################################### 
#  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  ⊗  #
###################################################################

###################################################################
# THE FUNCTIONALITY OF generate matrices.R IS CRUDE AND LIKELY TO CHANGE IN
# THE FUTURE.
# You are advised to avoid excessive dependency on this script
# for the time being.
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

###################################################################

###################################################################
# Load required libraries
###################################################################
library(optparse)
library(pracma)

###################################################################
# Parse arguments to script, and ensure that the required arguments
# have been passed.
###################################################################
option_list = list(
   make_option(c("-i", "--mat"), action="store", default='null', type='character',
              help="Path to the first matrix to be merged or operated upon"),
   make_option(c("-j", "--js"), action="store", default='null', type='character',
              help=" Specify the confound require  to pull out  from frmriprep ouput
                  
                comment neeeded here later 
              
                  etc."),
   make_option(c("-o", "--out"), action="store", default=NA, type='character',
              help="Output path")
)
opt = parse_args(OptionParser(option_list=option_list))

if (is.na(opt$out)) {
   cat('User did not specify an output path.\n')
   cat('Use generate_confmat.R -h for an expanded usage menu.\n')
   quit()
}

in1 <- opt$mat
in2 <- opt$js
out <- opt$out

###################################################################
###################################################################
outmat=0

## read the confoundmatrix
mat1 <- read.table(in1,sep = '\t', header =TRUE)
b=colnames(mat1)

 #if ( b[1]=='csf' ) {

      if (in2 == 'csf') {
      outmat=mat1$csf
      outmat[is.na(outmat)]=0
      }  else if (in2 == 'wm' ) {
      outmat=mat1$white_matter
      outmat[is.na(outmat)]=0
      }  else if (in2 == 'gsr' ) {
      outmat=mat1$global_signal
      outmat[is.na(outmat)]=0
     } else if ( in2 == 'tCompCor' ) {
     outmat <- mat1[ , grepl('t_comp_cor',names(mat1))]
     outmat=outmat[,1:5]
     outmat[is.na(outmat)]=0
     } else if ( in2 == 'aCompCor' ) {
     outmat <- mat1[ , grepl('a_comp_cor', names(mat1))]
     outmat=outmat[,1:5]
     outmat[is.na(outmat)]=0
     } else if ( in2 == 'aroma' ) {
     outmat <- mat1[ , grepl('aroma', names(mat1))]
     outmat[is.na(outmat)]=0
     } else if ( in2 == 'Cosine') { 
     outmat = mat1[ , grepl( 'cosine', names(mat1))]
     outmat[is.na(outmat)]=0
     } else if ( in2 == 'rps' ) {
     outmat1=cbind(mat1$rot_x,mat1$rot_y,mat1$rot_z)
     outmat=cbind(outmat1,mat1$trans_x,mat1$trans_y,mat1$trans_z)
     outmat[is.na(outmat)]=0
     } else if (in2 == 'stdVARS') { 
      outmat=mat1$std_dvars
      outmat=suppressWarnings(as.numeric(as.character(outmat)))
      outmat[is.na(outmat)]=0
      outmat=as.factor(outmat)
     } else if (in2 == 'allVARS') {
     outmat=mat1[ , grepl( 'dvars' , names(mat1) ) ]
     outmat=suppressWarnings(as.numeric(as.character(outmat)))
     outmat[is.na(outmat)]=0
     outmat=as.factor(outmat)
     } else if ( in2 == 'rms' ) {
     mat2=(cbind(mat1$trans_x,mat1$trans_y,mat1$trans_z))^2
     outmat=sqrt(rowSum(mat2)/3)
     outmat[is.na(outmat)]=0  
    } else if (in2 == 'fd') {
     outmat = mat1$framewise_displacement
      outmat=suppressWarnings(as.numeric(as.character(outmat)))
      outmat[is.na(outmat)]=0
      outmat=as.factor(outmat)
      } else  {
      sprintf("the input is not available yet") 
   }
#}

write.table(outmat,file=out, col.names = F, row.names=F,quote=F)
