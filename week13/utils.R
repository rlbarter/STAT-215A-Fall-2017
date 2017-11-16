# General functions for handling images and Gabor features
RotateImageVector <- function(image.vec) {
  # Rotate a raw image vector into the
  # correct orientation for viewing.

  # There are this many rows and columns,
  # and transpose and re-ordering gives it the correct
  # orientation.
  kRows <- 128
  return(t(matrix(image.vec, nrow = kRows)[kRows:1,]))
}


ReadImage <- function(number) {
  # Read a single line from fit <- stim.csv into
  # a matrix that can be plotted as an image.
  #
  # Args:
  #  - number: Which image number to load, starting
  #            with 1.
  #
  # Returns:
  #  - A matrix containing the raw image pixels.

  # The first line contains column names, so we always
  # skip at least one line.
  img <- scan("data/fit_stim.csv",
              skip = number, nlines = 1, sep=",")

  return(RotateImageVector(img))

}

ReadRealBasisFunction <- function(number) { 
  # Read a single column from real <- wav.csv into 
  # a matrix that can be plotted as an image.  This 
  # uses a bash command and may not work for windows users.  
  # 
  # Args: 
  #  - number: Which basis function to load, starting 
  #            with 1. 
  # 
  # Returns: 
  #  - A matrix containing the basis function.  NB: 
  #    I am not 100% sure that the rotation is the same 
  #    for the basis function as for the images. 
   
  # Use bash to read a single column into a text file. 
  # Note that this may not work for windows users. 
  temp.file <- tempfile() 
  system(paste("cat data/real_wav.csv | cut -d, -f ", 
               number, " > ", temp.file)) 
  basis.data <- read.csv(temp.file, header=T)[[1]] 
  return(RotateImageVector(basis.data)) 
} 
