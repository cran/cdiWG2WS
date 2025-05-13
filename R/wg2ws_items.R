#' List of items to category table
#'
#' @description
#' Given a list of items, create a table of category scores
#'
#' @details
#'  Requires a list that exactly matches items as labeled from Wordbank
#'  (check [g_dict]). Converts to a table of category scores, ready for use
#'  with [wg2ws_category_score()].
#'
#'
#' @param items List of WG items present for individual.
#' @param error_on_missing If TRUE, check whether all items are actual WG
#'  items. See helper function [wg2ws_list_items()].
#' @param in_inside "In" and "inside" appear as two items on WG, but one
#'  ("inside/in") on WS. If "either," treat "inside/in" as endorsed if either
#'  appears. For "both", both must be endorsed. For "in" or "inside", treat
#'  "inside/in" as endorsed based solely on the presence of the indicated item.
#'
#' @return A data frame with 22 rows indicating item totals for all WS
#'  categories. These values are *not* adjusted, and need to be adjusted with
#'  [wg2ws_category_score()].
#'
#' @example man/examples/wg2ws_items.R
#' @export

wg2ws_items <- function(items, error_on_missing = TRUE, in_inside = "either") {

  if (!(in_inside %in% c("either", "in", "inside"))) {
    stop("Parameter in_inside must be one of: either, in, inside")
  }

  s_dict$category <- as.factor(s_dict$category)

  # Get list of WS categories
  categories <- unique(s_dict$category)

  # Check for bad items =======================================================

  items_not_in_dict <- items[!(items %in% g_dict$item_definition)]

  if (length(items_not_in_dict) > 0 & error_on_missing) {
    stop(paste0("Items ``", paste(items_not_in_dict, collapse = ", "),
               "'' not in gestures dictionary!"))
  }

  # Fix in/inside depending on setting ========================================

  # Depending on the setting, append the "inside/in" to the data frame for
  # calculating WS score
  if (in_inside == "either" & ("in" %in% items | "inside" %in% items) |
      in_inside == "both" & ("in" %in% items & "inside" %in% items) |
      in_inside == "in" & "in" %in% items |
      in_inside == "inside" & "inside" %in% items) {

    items <- append(items, "inside/in")

  }

  # Remove in/inside for clarity
  items <- items[!(items %in% c("in", "inside"))]

  # Create table of results ===================================================

  items_df <- data.frame(item_definition = items)
  items_df <- merge(items_df, s_dict)

  categories_tbl <- as.data.frame(table(items_df$category),
                                  responseName = "n",
                                  stringsAsFactors = FALSE)

  colnames(categories_tbl)[1] <- "category"

  # ===========================================================================

  return(categories_tbl)

}
