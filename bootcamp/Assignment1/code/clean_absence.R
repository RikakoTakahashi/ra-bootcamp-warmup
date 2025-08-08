getwd()
pacman::p_load(tidyverse, purrr, readr)

df_stdnumber <- readRDS("Assignment1/data/original/df_stdnumber.rds")
list_absent <- readRDS("Assignment1/data/original/list_absent.rds")

#absent list
df_absent <- 
for(i in 1:10){
  list_absent[[i]] <- list_absent[[i]] |>
    select(-blank)|>  #delete blank columns
    mutate(Year = 2012 + i)  #add year
}

#expand the list and create data frame
df_absent <- do.call(rbind, list_absent)
df_absent$Prefecture <- factor(df_absent$Prefecture)
df_absent$Number_absent <- as.numeric(df_absent$Number_absent)

#character to factor
df_stdnumber$Prefecture <- factor(df_stdnumber$Prefecture)


df_int <- inner_join(df_stdnumber, df_absent,
                     by = c("Prefecture", "Year"))

#Proportion by year
df_int_year <- df_int |>
  group_by(Year) |>
  summarize(sum_total_year = sum(Number, na.rm = TRUE),
            sum_absent_year = sum(Number_absent, na.rm = TRUE),
            .groups = "drop")|>
  mutate(proportion_year = sum_absent_year / sum_total_year)

#Proportion by prefecture
df_int_Prefecture <- df_int |>
  group_by(Prefecture) |>
  summarize(sum_total_pref = sum(Number, na.rm = TRUE),
            sum_absent_pref = sum(Number_absent, na.rm = TRUE),
            .groups = "drop")|>
  mutate(proportion_pref = sum_absent_pref / sum_total_pref)

df_int <- df_int |>
  inner_join(df_int_year, by = "Year") |>
  inner_join(df_int_Prefecture, by = "Prefecture")



df_int$Year <- as.integer(df_int$Year)

saveRDS(df_int, file = "Assignment1/data/cleaned/df_absent.rds")


