#' Calculate WS total score from WG score.
#'
#' @details
#' Given a single number (WG total score) and optionally age, calculate a WG
#' score.
#'
#'
#' @param WG Words and Gestures total score.
#' @param age Age in months (optional). A different, more accurate model is
#'  used if age is supplied.
#'
#' @return Adjusted score, rounded to the nearest integer. Does not return
#'  values below 0 or greater than 680.
#'
#' @export
#'
#' @examples
#'
#' wg2ws_total_age(200)
#' wg2ws_total_age(200, age = 21)
#'
#' @references
#'  Day, T. K. M., Borovsky, A., Thal, D., & Elison, J. T. (2025).
#'  Modeling Longitudinal Trajectories of Word Production With the CDI.
#'  \emph{Developmental Science}, 28(4), e70036. \doi{10.1111/desc.70036}

wg2ws_total_age <- function(WG, age = NA) {


  if (age > 18 | is.na(age)) {

    newdata <- data.frame(total_WG = WG, age = age)
    newdata$age_c <- age - 18

    if (is.na(age)) {
      y_hat <- predict(total_WG_to_WS_noage_stripped, newdata)
    }  else {
      y_hat <- predict(total_WG_to_WS_stripped, newdata)
    }

    # Cutoff at 0/680
    y_hat <- replace(y_hat, y_hat < 0, 0)
    y_hat <- replace(y_hat, y_hat > 680, 680)
    y_hat <- unname(round(y_hat))

    return(y_hat)

  } else if (age < 8) {

    message("Age is below normed range (<8 months), returning input unchanged.")
    return(WG)

  } else if (age > 40) {

    message("Age is greater than 40 months, not performing projection.")
    return(NA)

  } else {

    message("Age is within normed range (8-18 months), returning input unchanged.")
    return(WG)

  }

}
