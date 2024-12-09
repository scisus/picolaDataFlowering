# Create a dataset of events for use in the flowers R packages
here::i_am("data-raw/phenology/cleaning/5.derive_event_data.R")
library(dplyr)

state_data <- read.csv(here::here("data-raw/phenology/picola_state.csv"), header=TRUE)

## Dates to add to event data ##

datedata <- state_data %>% select(DoY, Date, Year) %>% distinct()

## Metadata to add to event data
meta <- state_data %>% select(-DoY, -Date, -Phenophase_Recorded, -State) %>% distinct() # dropping source here because otherwise duplicates get in the data!

# create an event dataframe ###############
event_data <- state_data %>%
    # summarize state data into DoY data for four events -
    # last before flowering day,
    # first flowering day
    # last flowering day
    # first after flowering day
    group_by(Index, State, Year) %>%
    dplyr::summarise(First_Observation = min(DoY), Last_Observation = max(DoY)) %>%
    tidyr::pivot_longer(contains("Observation"), names_to = "Event", values_to = "DoY") %>%
    filter(State == 1 & Event == "Last_Observation" | State == 2 | State == 3 & Event == "First_Observation") %>%
    arrange(Index, State) %>%
    # name events
    dplyr::mutate(Event_Label = case_when(State == 1 ~ "before_flowering",
                                    State == 2 & Event == "First_Observation" ~ "first_flowering",
                                    State == 2 & Event == "Last_Observation" ~ "last_flowering",
                                    State == 3 ~ "past_flowering")) %>%
    dplyr::mutate(Event_Obs = case_when(Event_Label == "before_flowering" ~ 1,
                                    Event_Label == "first_flowering" ~ 2,
                                    Event_Label == "last_flowering" ~ 3,
                                    Event_Label == "past_flowering" ~ 4)) %>%
    # join with metadata
    left_join(datedata) %>%
    left_join(meta) %>%
    select(-Event)

# TEST that events and states make sense #########
# no indexes have more than 4 events UNLESS they are the clones that were observed by both walsh and wagner
foo <- event_data %>%
    group_by(Index) %>%
    dplyr::summarise(count = n(), n_sources = length(unique(Source))) %>%
    filter(!(count <= 4 & n_sources == 1 )) %>%
    filter(!(count == 8 & n_sources == 2))
assertthat::are_equal(nrow(foo), 0)

# TEST states and events do not conflict
foo <- filter(event_data, State == 1 & Event_Obs == 1 |
           State == 2 & Event_Obs %in% c(2,3) |
           State == 3 & Event_Obs == 4)
assertthat::are_equal(nrow(foo), nrow(event_data))

# TEST that no indexes dropped
foo <- state_data %>%
    filter(State != 0)
assertthat::assert_that(all(unique(foo$Index) %in% unique(event_data$Index)))

# write out event data

write.csv(event_data, here::here('data-raw/phenology/picola_event.csv'), row.names = FALSE, quote = FALSE)





