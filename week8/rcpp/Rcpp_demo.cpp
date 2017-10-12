// Based on Hadley Wickam's Rcpp tutorial:
// http://adv-r.had.co.nz/Rcpp.html

#include <Rcpp.h>

// The line [[Rcpp::export]] before a function tells R to treat it like
// a native function.
// [[Rcpp::export]]
Rcpp::NumericVector DistanceCPP(Rcpp::NumericVector x, Rcpp::NumericVector y) {
  // Calculate the euclidian distance between <x> and <y>.

  // C++ requires initialization of variables.
	double result = 0.0;

  // This is the length of the x vector.
	int n = x.size();

  // Check that the size is the same and return NA if it is not.
  if (y.size() != n) {
    Rcpp::Rcout << "Error: the size of x and y must be the same.\n";
    return(Rcpp::NumericVector::create(NA_REAL));
  }

	for (int i = 0; i < n; i++) {
		result += pow(x[i] - y[i], 2.0);
	}
  // We need to convert between the double type and the R numeric vector type.
	return Rcpp::NumericVector::create(sqrt(result));
}

// [[Rcpp::export]]
Rcpp::NumericVector DistanceMatrixCPP(Rcpp::NumericMatrix z) {
  // Calculate the euclidian distance between the first and
  // second column of z.

  // Check that there are two columns and return NA if it is not.
  if (z.ncol() != 2) {
    Rcpp::Rcout << "Error: z must only have two columns.\n";
    return(Rcpp::NumericVector::create(NA_REAL));
  }

  double result = 0;
	for (int i = 0; i < z.nrow(); i++) {
  // Note the curved braces for indexing matrices.
		result += pow(z(i, 0) - z(i, 1), 2.0);
	}
  return Rcpp::NumericVector::create(sqrt(result));
}
