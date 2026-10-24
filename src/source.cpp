// -----------------------------------------------------------------------------
// edit .setup/cpp/manMetaVAR-chi-bar-draws-dot.cpp
// Ivan Jacob Agaloos Pesigan
// -----------------------------------------------------------------------------

#include <RcppArmadillo.h>

#include <cmath>
#include <limits>
// [[Rcpp::depends(RcppArmadillo)]]

// Simulated chi-bar-square draws for the boundary likelihood ratio test.
// For each column z of zu, returns
//   z' m z - min_{u in C} (z - u)' m (z - u),
// with C = PSD(k) x R^(q - qb), qb = k (k + 1) / 2.
// The first qb coordinates are Frobenius-isometric coordinates of a k x k
// symmetric matrix (column-wise vech; diagonal entries, sqrt(2) times
// off-diagonal entries); the remaining coordinates are unconstrained.
// The minimization uses accelerated projected gradient (FISTA) with the
// Frobenius projection onto the positive semidefinite cone.
// [[Rcpp::export(.ChiBarDraws)]]
Rcpp::NumericVector ChiBarDraws(const arma::mat& zu, const arma::mat& m,
                                const int k, const int maxit,
                                const double tol) {
  const arma::uword qb = static_cast<arma::uword>(k * (k + 1) / 2);
  const arma::uword r = zu.n_cols;
  const double step = 1.0 / (2.0 * arma::eig_sym(m).max());
  const double s2 = std::sqrt(2.0);
  arma::uvec ri(qb);
  arma::uvec ci(qb);
  arma::uword idx = 0;
  for (arma::uword j = 0; j < static_cast<arma::uword>(k); ++j) {
    for (arma::uword i = j; i < static_cast<arma::uword>(k); ++i) {
      ri(idx) = i;
      ci(idx) = j;
      ++idx;
    }
  }
  auto proj = [&](const arma::vec& u) {
    arma::mat s(k, k);
    for (arma::uword a = 0; a < qb; ++a) {
      const double val = (ri(a) == ci(a)) ? u(a) : u(a) / s2;
      s(ri(a), ci(a)) = val;
      s(ci(a), ri(a)) = val;
    }
    arma::vec ev;
    arma::mat evec;
    arma::eig_sym(ev, evec, s);
    ev.transform([](double x) { return x > 0.0 ? x : 0.0; });
    const arma::mat p = evec * arma::diagmat(ev) * evec.t();
    arma::vec out = u;
    for (arma::uword a = 0; a < qb; ++a) {
      out(a) = (ri(a) == ci(a)) ? p(ri(a), ci(a)) : s2 * p(ri(a), ci(a));
    }
    return out;
  };
  Rcpp::NumericVector out(r);
  for (arma::uword d = 0; d < r; ++d) {
    const arma::vec z = zu.col(d);
    const double full = arma::as_scalar(z.t() * m * z);
    arma::vec x = proj(z);
    arma::vec y = x;
    arma::vec xold = x;
    double t = 1.0;
    double fold = std::numeric_limits<double>::infinity();
    for (int it = 0; it < maxit; ++it) {
      const arma::vec g = 2.0 * m * (y - z);
      x = proj(y - step * g);
      const double tn = (1.0 + std::sqrt(1.0 + 4.0 * t * t)) / 2.0;
      y = x + ((t - 1.0) / tn) * (x - xold);
      xold = x;
      t = tn;
      const arma::vec e = z - x;
      const double f = arma::as_scalar(e.t() * m * e);
      if (std::abs(fold - f) < tol * (1.0 + f)) {
        fold = f;
        break;
      }
      fold = f;
    }
    out(d) = full - fold;
  }
  return out;
}
