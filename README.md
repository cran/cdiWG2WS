# cdiWG2WS

<!-- badges: start -->
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html)
![Static Badge](https://img.shields.io/badge/version-0.1.2-blue)
![GPL 3.0](https://img.shields.io/badge/license-GPLv3-blue)
<!-- badges: end -->

The function of this R package is to provide function for converting
MacArthur-Bates Communicative Development Inventory (CDI) Words and Gestures
(WG) scores collected on individuals outside the normed range (8-18 months)
to appropriate Words and Sentences (WS) scores (see Fenson et al., 1994).

This was done in order to adapt scores collected as part of the Baby Connectome
Project (BCP; Howell et al., 2018), which collected WG scores out of range
for comparison with studies of intellectual and developmental disabilities.

For more information, see the
[article](https://onlinelibrary.wiley.com/doi/10.1111/desc.70036)
(Day et al., 2025).

# Functions

All values are rounded to the nearest integer, and then truncated to the
possible range. Values below 0 are set to 0, and values above the maximum are
set to the maximum value.

## Total Score

`wg2ws_total_age()`

This function converts a total WG score (i.e., 0-396) to WS based on either
WG total score alone or including the effect of age. The models are listed
below:

### Age model

```math
\begin{align}
\hat{y} =
    & -0.74(\textrm{age}) + 1.2(\textrm{WG}) - {} \\
    & 0.014(\textrm{age}^2) - 0.00073(\textrm{WG}^2) + {} \\
    & 0.0074(\textrm{age}^3) + (4.9 \times{} 10^{-6})(\textrm{WG}^3) + {} \\
    & 0.012(\textrm{age})(\textrm{WG}) -
        (5.2 \times{} 10^{-6})(\textrm{age}^2)(\textrm{WG}^2) +
        (7.0 \times{} 10^{-10})(\textrm{age}^3)(\textrm{WG}^3)
\end{align}
```
### No age model

```math
\hat{y} = 1.2(\textrm{WG}) - (6.9\times10^{-4})(\textrm{WG}^2) +
    (4.99\times10^{-6})(\textrm{WG}^3)
```
# Category scores

Because 14 items are not in the same category between WG and WS, in
order to calculate WS category scores, **the entire list of items is needed**.

Those 14 items are (WG -> WS):

 - (Outside -> Places) *beach, church, home, house, outside, park,*
      *party, school, store, work (place), zoo*
 - (Games and Routines -> Action Words) *wait*
 - (Games and Routines -> Helping Verbs) *don't, wanna/want to*

Thus the flow looks something like:

    child_wg_words <- c("moo", "home", "run")

    child_wg2ws <- wg2ws_items(child_wg_words) # returns a 22x2 data frame

    \# Returns a 22x2 data frame
    child_ws_cat_scores <- wg2ws_category_score(child_wg2ws)

There is no need to estimate category scores if you don't need them, but the
new simulated WS score could be found as `sum(child_ws_cat_scores$n)`.

## WG items to WS categories

`wg2ws_items.R`

This function takes a vector of items (in Wordbank format), which includes
entires like `fish (food)` and `fish (animal)` and returns WS category totals
(i.e., remaps them).

Note that `in` and `inside` appear as two distinct items on WG, but as one
combined item (`inside/in`) on WS. Thus, you can choose how to score it.

 - `"either"` (**default**): If either is endorsed, treat `inside/in` as
    endorsed.
 - `"both"`: Both must be endorsed to treat `inside/in` as endorsed.
 - `"in"`: Only `in` has to be endorsed to treat `inside/in` as endorsed.
 - `"inside"`: As above, but with `inside`.

Example:

    items <- c("beach", "radio", "her", "penguin", "see", "tiger", "party", "in")

    wg2ws_items(items, in_inside = "either")

                category n
    1       action_words 1
    2            animals 2
    3         body_parts 0
    4           clothing 0
    5   connecting_words 0
    6  descriptive_words 0
    7         food_drink 0
    8    furniture_rooms 0
    9     games_routines 0
    10     helping_verbs 0
    11         household 1
    12         locations 1
    13           outside 0
    14            people 0
    15            places 2
    16          pronouns 1
    17       quantifiers 0
    18    question_words 0
    19            sounds 0
    20        time_words 0
    21              toys 0
    22          vehicles 0

## Categories to WS

`wg2ws_category_score.R`

Converts the WG total scores (calculated above) to WS scores using a set of
models.

## in/inside

Because some models include total WG score, and
because information is not kept on how `inside/in` was chosen to be endorsed,
there is technically a minor discrepancy between true WG score and its mapping
to WS (which is the value used for prediction), of up to one word.

In random simulations, with 3,297 faux inventories, 1,408 (43%) had a one-item
discrepancy in the *predicted result*. Because the predicted result is out of
680, we consider this fairly minor, and provide a parameter to override the
WG score used in modeling with the true WG score from the original instrument.

## Calculating category scores

The function lets you model age and WG total score, either can be excluded,
and the best available model will be used.

    random <- sample(wg2ws_list_items("WG"), 380)
    c("in", "inside") %in% random

    test_table <- wg2ws_items(random)

    test_result_noage <- wg2ws_category_score(test_table, age = NA, verbose = TRUE)
    test_result_30mo <- wg2ws_category_score(test_table, age = 30, verbose = TRUE)
    test_result_36mo <- wg2ws_category_score(test_table, age = 36, verbose = TRUE)

    > head(test_result_noage)
               category  n new_value
    1      action_words 56        98
    2           animals 35        41
    3        body_parts 19        23
    4          clothing 18        24
    5  connecting_words  0         4
    6 descriptive_words 37        62

    > head(test_result_30mo)
               category  n new_value
    1      action_words 54        98
    2           animals 35        41
    3        body_parts 18        24
    4          clothing 18        25
    5  connecting_words  0         5
    6 descriptive_words 35        60

    > head(test_result_36mo)
                category  n new_value
    1      action_words 54       101
    2           animals 35        41
    3        body_parts 18        25
    4          clothing 18        26
    5  connecting_words  0         6
    6 descriptive_words 35        63

# Helper functions

 - `wg2ws_list_items(instrument = c("WG", "WS"))`: List items on WG or WS.
 - `wg2ws_get_cat_function(the_category, age)`: Returns the function to do the
        projection, or with `echo_only = TRUE`, returns the coefficients in a
        human-readable format.
 - `wg2ws_summarize_cat(category_scores)`: Take a table from
        `wg2ws_category_score` and summarize the results into a total score,
        and a lexical/syntactic score (Day & Elison, 2021).

# References

 1. Fenson, L., Dale, P. S., Reznick, J. S., Bates, E., Thal, D. J., &
    Pethick, S. J. (1994). Variability in Early Cognitive Development.
    *Monographs of the Society for Research in Child Development*, *59*(5).

 2. Howell, B. R., ... Elison, J. T. (2018).
    The UNC/UMN Baby Connectome Project (BCP): An overview of the study
    design and protocol development. *NeuroImage*.
    https://doi.org/10.1016/j.neuroimage.2018.03.049

 3. Day, T. K. M., Borovsky, A., Thal, D., & Elison, J. T. (2025).
    Modeling Longitudinal Trajectories of Word Production With the CDI.
    *Developmental Science*, *28*(4), Article e70036.
    https://doi.org/10.1111/desc.70036

 4. Day, T. K. M., & Elison, J. T. (2021).
    A broadened estimate of syntactic and lexical ability from the MB-CDI.
    *Journal of Child Language*, 849*(4), 615-632.
    https://doi.org/10.1017/S0305000921000283

 5. Frank, M. C., Braginsky, M., Yurovsky, D., & Marchman, V. A. (2017).
    Wordbank: An open repository for developmental vocabulary data.
    *Journal of Child Language*, *44*(3), 677–694.
    https://doi.org/10.1017/S0305000916000209

