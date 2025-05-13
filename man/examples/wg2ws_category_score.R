# Create list of words a child knows
words <- c("smile", "old", "chicken (animal)", "breakfast", "snow", "uh oh",
           "please", "bad", "bicycle", "moon")

# Create table
wg_categories <- wg2ws_items(words)

# Convert to WS score
ws_categories <- wg2ws_category_score(wg_categories, age = 20)
