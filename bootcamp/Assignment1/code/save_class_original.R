rm(list = ls()) #clear 
getwd()
pacman::p_load(tidyverse, readr)

#read data
file_class <- list.files("Assignment1/data/raw/assignment1_data/学級数",
                         full.names = TRUE)
list_class <- map(file_class, read_xlsx, skip = 1)

saveRDS(list_class, file = "Assignment1/data/original/list_class.rds")
