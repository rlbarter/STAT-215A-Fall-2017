
# Fill in a kernel function
# Could be Gaussian, square, cosine
Kernel <- function(x, h) {
  # A kernel function for use in nonparametric estimation.
  # Args:
  #  x: The point to evaluate the kernel
  #  h: The bandwidth of the kernel.
  # Returns:
  #  The value of a kernel with bandwidth h evaluated at x.
  
  BaseKernel <- function(x) {
    return(dnorm(x))
  }
  return((1 / h) * BaseKernel(x / h))
}

EstimateDensity <- function(x.data, KernelFun, h, resolution=length(eval.x), eval.x=NULL) {
  # Perform a kernel density estimate.
  # Args:
  #   x.data: The observations from the density to be estimated.
  #   KernelFun: A kernel function.
  #   h: the bandwidth.
  #   resolution: The number of points at which to evaluate the density.  Only necessary
  #               if eval.x is unspecified.
  #   eval.x: Optional, the points at which to evaluate the density.  Defaults to
  #           resolution points in [ min(x.data), max(x.data) ]
  # Returns:
  #  A data frame containing the x values and kernel density estimates with
  #  column names "x" and "f.hat" respectively.
  
  if (is.null(eval.x)) {
    # Get the values at which we want to plot the function
    eval.x = seq(from = min(x.data), to = max(x.data), length.out=resolution)    
  }
  
  # Calculate the estimated function values.
  MeanOfKernelsAtPoint <- function(x) {
    return(mean(KernelFun(x.data - x, h)))
  }
  f.hat <- sapply(eval.x, MeanOfKernelsAtPoint)
  return(data.frame(x=eval.x, f.hat=f.hat))
}


