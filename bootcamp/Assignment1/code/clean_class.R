rm(list = ls()) #clear 
getwd()
pacman::p_load(tidyverse, readr)

#read list
list_class <- readRDS("Assignment1/data/original/list_class.rds")

#year vector
years <- 2013:2022

list_class1 <- lapply(seq_along(list_class), function(i){
  df <- list_class[[i]]
  
  colnames(df)[1] <- "Prefecture"  #change the 1st column name
  colnames(df) <- str_remove(colnames(df), "学級") #remove "学級"
  colnames(df)[ncol(df)] <- "61~"  #align the last row's name
  
  df <- df |>
    select(-"計") |> #remove column "total"
    mutate(pref_no = 1:47, 
           year    = years[i]) |>
    mutate(across(2:34, ~as.double(.)))
  
  return(df)
})

names(list_class1) <- as.character(years) #change the names of df in list

df_all <- bind_rows(list_class1)  #df altogether

df_all <- df_all |>
  arrange(pref_no, year) |>
  relocate(pref_no, year, .after = "Prefecture")

non_class <- c("Prefecture", "year", "pref_no") #non class columns
class_col <- setdiff(colnames(df_all), non_class)  #class number


df_long <- df_all |>
  pivot_longer(cols       = all_of(class_col), #wide to long
               names_to   = "class_label",
               values_to  = "class_count") |>
  mutate(class_label2 = case_when(
    class_label == "25～30" ~ "27.5", 
    class_label == "31～36" ~ "33.5",
    class_label == "37～42" ~ "39.5",
    class_label == "43～48" ~ "45.5",
    class_label == "49～54" ~ "51.5",
    class_label == "55～60" ~ "57.5",
    class_label == "61~"    ~ "61",
    TRUE ~ class_label),
    class_label2 = as.numeric(class_label2),
    class_total  = class_label2 * class_count) 

#total class by year and prefecture
df_yearpref <- df_long |>
  group_by(year, pref_no, Prefecture) |>
  summarize(total_class_num = sum(class_total, na.rm = TRUE),
         .groups = "drop") |>
  arrange(pref_no) 
  
pref_name <- c("北海道", "青森", "岩手", "宮城", "秋田", "山形", "福島", "茨城", "栃木", "群馬", "埼玉", "千葉", "東京", "神奈川", "新潟", "富山", "石川", "福井", "山梨", "長野", "岐阜", "静岡", "愛知", "三重", "滋賀", "京都", "大阪", "兵庫", "奈良", "和歌山", "鳥取", "島根", "岡山", "広島", "山口", "徳島", "香川", "愛媛",  "高知", "福岡", "佐賀", "長崎", "熊本", "大分", "宮崎", "鹿児島", "沖縄")

df_yearpref <- df_yearpref |>
  mutate("Prefecture 都道府県" = pref_name[pref_no]) |>
  rename("year 年度"           = year,
         "total_class_num 合計学級数" = total_class_num) |>
  select("Prefecture 都道府県", "year 年度", "total_class_num 合計学級数")


saveRDS(df_yearpref, file = "Assignment1/data/cleaned/df_class.rds")



