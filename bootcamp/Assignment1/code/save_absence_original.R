getwd()
pacman::p_load(tidyverse)
pacman::p_load(readxl)
pacman::p_load(purrr)

#read data (total)
df_stdnumber <- read_xlsx("Assignment1/data/raw/assignment1_data/生徒数/生徒数.xlsx")
#change variables name
df_stdnumber <- df_stdnumber |>
  rename(Prefecture = "都道府県",
         Year       = "年度",
         Number     = "生徒数")
saveRDS(df_stdnumber, file = "Assignment1/data/original/df_stdnumber.rds")

#read data (absent)
file_list <- list.files("Assignment1/data/raw/assignment1_data/不登校生徒数", 
                        full.names = TRUE)
list_absent <- map(file_list, read_xlsx)

for (i in 1:10){
  list_absent[[i]] <- list_absent[[i]] |>
    rename(Prefecture    = "都道府県",
           Number_absent = "不登校生徒数")
}
saveRDS(list_absent, file = "Assignment1/data/original/list_absent.rds")




