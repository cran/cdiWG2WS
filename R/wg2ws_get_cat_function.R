#' Get function for category/age combination
#'
#' @description
#'  Returns a model object to predict category score given category and age.
#'
#' @details
#'  This is mostly an internal function, but is exposed in case somebody needs
#'  it. Returns a `lm()` object that has had the embedded data stripped, given
#'  a category and whether to model age.
#'
#' @param the_category Which category to use, following Wordbank naming
#'    convention.
#'  Options: sounds, animals, vehicles, toys, food_drink, clothing, body_parts,
#'            household, furniture_rooms, outside, places, people,
#'            games_routines, action_words, descriptive_words, time_words,
#'            pronouns, question_words, locations, quantifiers, helping_verbs,
#'            connecting_words
#' @param age T/F. If TRUE, return model that uses age as predictor.
#' @param echo_only T/F. If FALSE, returns model as function; if TRUE echoes
#'    as human readable.
#'
#' @importFrom stats coef
#'
#' @return Function or NULL
#' @export
#'
#' @examples wg2ws_get_cat_function("time_words", age = TRUE)
#'
#' @references
#'  Day, T. K. M., Borovsky, A., Thal, D., & Elison, J. T. (2025).
#'  Modeling Longitudinal Trajectories of Word Production With the CDI.
#'  \emph{Developmental Science}, 28(4), e70036. \doi{10.1111/desc.70036}

wg2ws_get_cat_function <- function(the_category, age = TRUE,
                                   echo_only = FALSE) {

  valid_cats <- c("animals", "vehicles", "toys", "food_drink", "clothing",
                  "body_parts", "household", "furniture_rooms", "outside",
                  "places", "people", "games_routines", "action_words",
                  "descriptive_words", "time_words", "pronouns",
                  "question_words", "locations", "quantifiers",
                  "helping_verbs")

  if (the_category == "sounds") {
    warning("No projection done for sounds")
    return(NA)
  } else if (the_category == "connecting_words") {
    warning("No modeling possible for connectiong words")
    return(NA)
  } else if (!(the_category %in% valid_cats)) {
    stop(paste(the_category, "is not a valid category"))
    return(NA)
  }

  model_index <- which(cat_models_stripped$category == the_category)

  if (!age)
    model <- cat_models_stripped$lm1[[model_index]]
  else
    model <- cat_models_stripped$lm4[[model_index]]

  if (!echo_only)
    return(model)
  else {
    coef(model)
  }

}
