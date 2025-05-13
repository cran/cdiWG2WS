#' WG dictionary: items, categories
#'
#' @format A data frame with 396 rows and 4 columns:
#'
#' \describe{
#'
#'  \item{category}{Name of category}
#'  \item{item_definition}{Item label, e.g. "baa baa"}
#'  \item{item_id}{Unique ID}
#'  \item{item_kind}{Type of item, only "word"}
#'
#' }
#'
#' @references
#'
#'  Frank, M. C., Braginsky, M., Yurovsky, D., & Marchman, V. A. (2017).
#'  Wordbank: An open repository for developmental vocabulary data.
#'  \emph{Journal of Child Language}, 44(3), 677-694.
#'  \doi{10.1017/S0305000916000209}
#'
"g_dict"

#' WS dictionary: items, categories
#'
#' @format A data frame with 680 rows and 4 columns:
#'
#' \describe{
#'
#'  \item{category}{Name of category}
#'  \item{item_definition}{Item label, e.g. "baa baa"}
#'  \item{item_id}{Unique ID}
#'  \item{item_kind}{Type of item, only "word"}
#'
#' }
#'
#' @references
#'
#'  Frank, M. C., Braginsky, M., Yurovsky, D., & Marchman, V. A. (2017).
#'  Wordbank: An open repository for developmental vocabulary data.
#'  \emph{Journal of Child Language}, 44(3), 677-694.
#'  \doi{10.1017/S0305000916000209}
#'
"s_dict"

#' Predict total score
#'
#' @format A linear model
#'
#'  A linear model predicting WS score from WG score (no age). The embedded
#'  data have been stripped from the object.
#'
#' @references
#'
#'  Frank, M. C., Braginsky, M., Yurovsky, D., & Marchman, V. A. (2017).
#'  Wordbank: An open repository for developmental vocabulary data.
#'  \emph{Journal of Child Language}, 44(3), 677-694.
#'  \doi{10.1017/S0305000916000209}
#'
"total_WG_to_WS_noage_stripped"

#' Predict total score (w/ age)
#'
#' @format A linear model
#'
#'  A linear model predicting WS score from WG score and age. The embedded
#'  data have been stripped from the object.
#'
#' @references
#'
#'  Frank, M. C., Braginsky, M., Yurovsky, D., & Marchman, V. A. (2017).
#'  Wordbank: An open repository for developmental vocabulary data.
#'  \emph{Journal of Child Language}, 44(3), 677-694.
#'  \doi{10.1017/S0305000916000209}
#'
"total_WG_to_WS_stripped"

#' Predict category scores
#'
#' @format An object of many linear models.
#'
#'  Linear models predicting WS category scores from WG score and age. The
#'  embedded data have been stripped from the object.
#'
#' @references
#'
#'  Frank, M. C., Braginsky, M., Yurovsky, D., & Marchman, V. A. (2017).
#'  Wordbank: An open repository for developmental vocabulary data.
#'  \emph{Journal of Child Language}, 44(3), 677-694.
#'  \doi{10.1017/S0305000916000209}
#'
"cat_models_stripped"

#' Predict Connecting Words scores
#'
#' @format Linear model
#'
#'  A linear model predicting Connecting Words scores from other scores and
#'  age. The embedded data have been stripped from the objects.
#'
#' @references
#'
#'  Frank, M. C., Braginsky, M., Yurovsky, D., & Marchman, V. A. (2017).
#'  Wordbank: An open repository for developmental vocabulary data.
#'  \emph{Journal of Child Language}, 44(3), 677-694.
#'  \doi{10.1017/S0305000916000209}
#'
"cw_stripped"


#' Predict Connecting Words scores (no age)
#'
#' @format Linear model
#'
#'  A linear model predicting Connecting Words scores from other scores
#'  (no age). The embedded data have been stripped from the object.
#'
#' @references
#'
#'  Frank, M. C., Braginsky, M., Yurovsky, D., & Marchman, V. A. (2017).
#'  Wordbank: An open repository for developmental vocabulary data.
#'  \emph{Journal of Child Language}, 44(3), 677-694.
#'  \doi{10.1017/S0305000916000209}
#'
"cw_noage_stripped"
