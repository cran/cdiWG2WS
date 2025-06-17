#' Summarize category table
#'
#' @details
#' Given a 22x2 category table, calculate total scores and lexical and
#' syntax scores.
#'
#' @param category_scores A 22x2 category result table
#'
#' @return A three column data frame, with total score, lexical, and syntactic
#'  scores
#' @export
#'
#' @references
#'  Day, T. K. M., & Elison, J. T. (2021). A broadened estimate of syntactic
#'  and lexical ability from the MB-CDI. \emph{Journal of Child Language},
#'  49(3), 615-632. \doi{10.1017/S0305000921000283}
#'
#' @examples
#'
#' words <- c("smile", "old", "chicken (animal)", "breakfast", "snow", "uh oh",
#'            "please", "bad", "bicycle", "moon")
#'
#' categories <- wg2ws_items(words)
#' scores <- wg2ws_summarize_cat(categories)

wg2ws_summarize_cat <- function(category_scores) {

  syntax_cats <- c("time_words", "pronouns", "question_words",
                   "locations", "quantifiers", "helping_verbs",
                   "connecting_words")

  total <- sum(category_scores$n)
  lexical <- sum(category_scores$n[!(category_scores$category %in% syntax_cats)])
  syntax <- sum(category_scores$n[category_scores$category %in% syntax_cats])

  result <- data.frame("total" = total, "lexical" = lexical, "syntax" = syntax)

  return(result)

}
