#' Four-Variable Model Parameters
#'
#' Population model parameters for the four-variable VAR(1) simulation
#' condition.
#'
#' @author Ivan Jacob Agaloos Pesigan
#'
#' @docType data
#' @name modelk4
#' @usage data(modelk4)
#' @format A list with 15 elements:
#'
#' \describe{
#'   \item{k}{
#'     Number of variables, equal to 4.
#'   }
#'   \item{mu_mu}{
#'     Mean of the set-point vector
#'     \eqn{\boldsymbol{\mu}}.
#'   }
#'   \item{mu_sigma}{
#'     Covariance matrix of the parameter
#'     \eqn{\boldsymbol{\mu}}.
#'   }
#'   \item{mu_sigma_l}{
#'     Cholesky factor of the covariance matrix of the parameter
#'     \eqn{\boldsymbol{\mu}}.
#'   }
#'   \item{beta_mu}{
#'     Mean of the lagged-coefficient matrix
#'     \eqn{\boldsymbol{\beta}}.
#'   }
#'   \item{beta_sigma}{
#'     Covariance matrix of the parameter
#'     \eqn{\mathrm{vec} \left( \boldsymbol{\beta} \right)}.
#'   }
#'   \item{beta_sigma_l}{
#'     Cholesky factor of the covariance matrix of the parameter
#'     \eqn{\mathrm{vec} \left( \boldsymbol{\beta} \right)}.
#'   }
#'   \item{psi}{
#'     Process-noise covariance matrix
#'     \eqn{\boldsymbol{\Psi}}.
#'   }
#'   \item{psi_l}{
#'     Cholesky factor of the process-noise covariance matrix
#'     \eqn{\boldsymbol{\Psi}}.
#'   }
#'   \item{psi_d_ldl}{
#'     `uc_d` of the LDL' decomposition of the process-noise covariance matrix
#'     \eqn{\boldsymbol{\Psi}}.
#'     See [fitVARMxID::LDL()].
#'   }
#'   \item{psi_l_ldl}{
#'     `s_l` of the LDL' decomposition of the process-noise covariance matrix
#'     \eqn{\boldsymbol{\Psi}}.
#'     See [fitVARMxID::LDL()].
#'   }
#'   \item{ma_fixed}{
#'     Vector of fixed effects
#'     \eqn{
#'       \boldsymbol{\theta} = \left[
#'       \boldsymbol{\mu},
#'       \mathrm{vec} \left( \boldsymbol{\beta} \right)
#'       \right]^{\prime}.
#'     }
#'   }
#'   \item{ma_random}{
#'     Covariance matrix of the random effects in
#'     \eqn{
#'       \boldsymbol{\theta} = \left[
#'       \boldsymbol{\mu},
#'       \mathrm{vec} \left( \boldsymbol{\beta} \right)
#'       \right]^{\prime}.
#'     }
#'   }
#'   \item{ma_random_d_ldl}{
#'     `uc_d` of the LDL' decomposition of the random-effects covariance
#'     matrix.
#'     See [fitVARMxID::LDL()].
#'   }
#'   \item{ma_random_l_ldl}{
#'     `s_l` of the LDL' decomposition of the random-effects covariance
#'     matrix.
#'     See [fitVARMxID::LDL()].
#'   }
#' }
#'
#' @keywords data parameters
"modelk4"
