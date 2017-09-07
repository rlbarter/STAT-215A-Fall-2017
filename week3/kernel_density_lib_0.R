source(file.path(Sys.getenv("GIT_REPO_LOC"),
                 "classes/STAT215A_Fall2013/lab_sessions/09-16-2014/normal_point_mixture_lib.R"))

# Fill in a kernel function
# Could be Gaussian, square, cosine
Kernel <- function(x, h) {
  # A kernel function for use in nonparametric estimation.
  # Args:
  #  x: The point to evaluate the kernel
  #  h: The bandwidth of the kernel.
  # Returns:
  #  The value of a kernel with bandwidth h evaluated at x.
  
  return()
}

EstimateDensity <- function(x_data, KernelFun, h, 
                            resolution = length(eval_x), 
                            eval_x = NULL) {
  # Perform a kernel density estimate.
  # Args:
  #   x_data: The observations from the density to be estimated.
  #   KernelFun: A kernel function.
  #   h: the bandwidth.
  #   resolution: The number of points at which to evaluate the density.  
  #               Only necessary
  #               if eval_x is unspecified.
  #   eval_x: Optional, the points at which to evaluate the density. Defaults to
  #           resolution points in [min(x_data), max(x_data)]
  # Returns:
  #  A data frame containing the x values and kernel density estimates with
  #  column names "x" and "f.hat" respectively.
  
  return()
}
