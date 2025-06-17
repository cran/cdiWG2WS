#' Simulate WS category score from given WG score
#'
#' @description
#' Take 22 WG scores and simulates WS scores for each one.
#'
#' @details
#'  This function predicts simulated WS scores for each category score
#'  independently. If an age is not supplied, models not using age are used
#'  (less accurate than including age).
#'
#' @param wg_table A 22-row table with the columns `category` and `n`. Includes
#'  Sounds and Connecting Words.
#' @param age (Optional). Age in months. If unset, models not including age
#'          are used
#' @param verbose T/F: Be verbose.
#' @param WG_total NA/numeric:
#'                  In the case of `in/inside`, the WG score model can be
#'                  off-by-one. Out of so many items, this is negligible, but
#'                  can be set explicitly here.
#'
#' @return New scores (data frame of 22 scores)
#' @export
#'
#' @importFrom stats predict
#'
#' @example man/examples/wg2ws_category_score.R
#'
#' @references
#'  Day, T. K. M., Borovsky, A., Thal, D., & Elison, J. T. (2025).
#'  Modeling Longitudinal Trajectories of Word Production With the CDI.
#'  \emph{Developmental Science}, 28(4), e70036. \doi{10.1111/desc.70036}


wg2ws_category_score <- function(wg_table, age = NA, WG_total = NA,
                                 verbose = FALSE) {

  if (!all.equal(colnames(wg_table), c("category", "n"))) {
    stop("Category expects exactly two columns: category and score")
  }

  if (nrow(wg_table) != 22) {
    stop("Expecting all 22 categories - including SEAS/CW.")
  }

  if (is.na(WG_total)) {
    WG_total <- sum(wg_table$n)
    if (verbose)
      message(paste("WG total:", WG_total))
  }

  # Center age
  age_c <- age - 18

  # Hat values
  new_value <- rep(NA, 22)

  for (i in 1:22) {

    the_category <- wg_table$category[i]
    the_score <- wg_table$n[i]

    # Sounds gets passed through: Identical
    if (the_category == "sounds"){
      new_value[i] <- the_score
      next
    }

    # Don't predict
    if (the_category == "connecting_words")
      next

    # Get model. 'age' parameter for this function is T/F, so if age is NA,
    # convert that to FALSE.
    model <- wg2ws_get_cat_function(the_category, !is.na(age))

    # Do model prediction
    new_data = data.frame(cat_total_WG = the_score, age_c = age_c,
                          WG_total_score = WG_total)

    result <- predict(model, newdata = new_data)

    # Add to result
    new_value[i] <- unname(round(result))

  }

  # Floor new values (no values less than 0)
  new_value <- ifelse(new_value < 0, 0, new_value)

  # Max sure no values exceed maximum
  max_value <- as.data.frame(table(s_dict$category), responseName = "max")

  # Get maximum value in order presented
  wg_to_max <- match(wg_table$category, as.character(max_value$Var1))
  maximums <- max_value$max[wg_to_max]
  if (verbose) {
    bad <- sum(new_value > maximums, na.rm = TRUE)
    message(paste("Found", bad, "values in excess of category maximum"))
  }
  new_value <- ifelse(new_value > maximums, maximums, new_value)

  new_table <- cbind(wg_table, new_value)

  # Predict CW

  awords <- wg_table$n[wg_table$category == "action_words"]
  clothing <- wg_table$n[wg_table$category == "clothing"]
  fd <- wg_table$n[wg_table$category == "food_drink"]
  gr <- wg_table$n[wg_table$category == "games_routines"]
  loc <- wg_table$n[wg_table$category == "locations"]
  pron <- wg_table$n[wg_table$category == "pronouns"]
  quant <- wg_table$n[wg_table$category == "quantifiers"]
  qwords <- wg_table$n[wg_table$category == "question_words"]
  sounds <- wg_table$n[wg_table$category == "sounds"]
  twords <- wg_table$n[wg_table$category == "time_words"]
  toys <- wg_table$n[wg_table$category == "toys"]

  cw_new_data <- data.frame(age_c = age_c, WG_total = WG_total,
                             action_words = awords, clothing = clothing,
                             food_drink = fd, games_routines = gr,
                             locations = loc, pronouns = pron,
                             quantifiers = quant, question_words = qwords,
                             sounds = sounds, time_words = twords, toys = toys)

  # Round and truncate to [0, 6]

  if (!is.na(age))
    cw_new <- round(predict(cw_stripped, cw_new_data))
  else
    cw_new <- round(predict(cw_noage_stripped, cw_new_data))

  # Truncate to possible range
  cw_new <- ifelse(cw_new > 6, 6, ifelse(cw_new < 0, 0, cw_new))

  if (verbose) message(paste("Connecting words:", cw_new))

  # Add to results
  new_table$new_value[new_table$category == "connecting_words"] <- cw_new

  return(new_table)

}
