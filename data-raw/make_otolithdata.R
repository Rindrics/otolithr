devtools::load_all() 
library(dplyr)
library(ggplot2)
library(plotly)
library(ggrepel)
library(otolithr)
library(gghighlight)
data(measure)
data(stations)

exclude_list <- c("YK1608_MT10_12",
                  "YK1608_MT10_20",
                  "YK1608_MT14_16",
                  "YK1608_MT11_2",
                  "YK1608_MT11_5",
                  "YK1611_B4_1",
                  "YK1611_B4_1_hayashi",
                  "YK1611_B4_1_shiki",
                  "YK1611_C1_5",
                  "YK1611_C1_7",
                  "YK1611_C1_9",
                  "YK1611_C1_10",
                  "YK1611_C1_11",
                  "YK1611_C1_13",
                  "YK1611_C2_3",
                  "YK1611_C2_3_shiki",
                  "YK1611_C2_4",
                  "YK1611_C2_4_shiki",
                  "YK1611_C2_5",
                  "YK1611_C2_5_shiki",
                  "YK1611_C2_6",
                  "YK1611_C2_6_2",
                  "YK1611_C2_6_shiki",
                  "YK1611_C2_7",
                  "YK1611_C2_7_shiki",
                  "YK1611_C2_10",
                  "YK1611_C2_10_shiki",
                  "YK1611_C2_15")

yk1308 <- hdr2df_in_dir("otolith/YK1308", species = "maiwashi") %>%
  mutate(Cruise = "YK1308")
yk1509 <- hdr2df_in_dir("otolith/YK1509", species = "maiwashi") %>%
  mutate(Cruise = "YK1509") %>%
  tidyr::separate(ID, into = c("Species", "Cruise", "Station", "SampleNo"), sep = "_") %>%
  dplyr::mutate(ID = paste(Station, SampleNo, sep = "_"),
                Species = "maiwashi")
yk1608 <- hdr2df_in_dir("otolith/YK1608", species = "maiwashi") %>%
  mutate(Cruise = "YK1608")
yk1611 <- hdr2df_in_dir("otolith/YK1611", species = "maiwashi") %>%
  mutate(Cruise = "YK1611")

otolith <- bind_rows(yk1308,
                     yk1509,
                     yk1608,
                     yk1611) %>%
  mutate(ID = paste0(Cruise, "_", ID) %>%
                stringr::str_replace("_0+([1-9])", "_\\1")) %>%
  dplyr::mutate(ID2 = ID) %>%
  dplyr::select(-BL_mm) %>%
  tidyr::separate(ID2, into = c("Cruise", "Station", "SampleNo")) %>%
  dplyr::mutate(CruiseStation = paste(Cruise, Station, sep = "_"),
                SampleNo = as.integer(SampleNo)) %>%
  filter(ID %not_in% exclude_list) %>%
  dplyr::left_join(stations) %>%
  dplyr::mutate(DateHatched = DateCollected - Age,
                FiscalYr = as.numeric(paste0(20, substr(Cruise, 3, 4))),
                Day1_FiscalYr = as.Date(paste(FiscalYr, "01", "01", sep = "-")),
                DateHatched_jday = DateHatched - Day1_FiscalYr) %>%
  dplyr::select(-Cruise) %>%
  back_calculate(measure)

p <- otolith %>%
  group_by(ID, Age, SL_mm, Cruise) %>%
  summarize(OR_microm = max(OR_microm)) %>%
  plot_ly(x = ~Age, y = ~OR_microm, color = ~Cruise, type = 'scatter',
        mode = 'markers', hoverinfo = text,
        text = ~paste('ID: ', ID,
                      '</br> SL_mm: ', SL_mm))
p
  
p <- otolith %>%
  group_by(ID, Age, SL_mm, Cruise) %>%
  summarize(OR_microm = max(OR_microm)) %>%
  plot_ly(x = ~OR_microm, y = ~SL_mm, color = ~Cruise, type = 'scatter',
        mode = 'markers', hoverinfo = text,
        text = ~paste('ID: ', ID,
                      '</br> SL_mm: ', SL_mm))
p

otolith %>%
  dplyr::filter(IncNo == 1) %>%
  ggplot(aes(LonStart_decimal, LatStart_decimal, color = Cruise)) +
  geom_point()

otolith %>%
  ggplot(aes(iAge, IncWidth_microm, group = ID, color = Cruise)) +
  geom_line(size = 0.5, alpha = 0.05) +
  facet_wrap(~ Cruise) +
  gghighlight(use_direct_label = FALSE)

otolith %>%
  dplyr::filter(IncNo == 1) %>%
  ggplot(aes(DateHatched_jday, fill = Cruise)) +
  geom_histogram() +
  facet_grid(Cruise ~ ., scales = "free_x")

otolith %>%
  dplyr::filter(IncNo == 1) %>%
  ggplot(aes(DateHatched, fill = Cruise)) +
  geom_histogram() +
  facet_wrap(~ Cruise, scales = "free_x")

otolith %>%
  dplyr::filter(IncNo == 1, !is.na(Cruise)) %>%
  ggplot(aes(Age, fill = Cruise)) +
  geom_histogram() +
  facet_grid(Cruise ~ .)

otolith %>%
  dplyr::filter(!is.na(Cruise)) %>%
  ggplot(aes(iAge, BackCalSL_mm, group = ID, color = Cruise)) +
  geom_line() +
  facet_wrap(~ Cruise) +
  gghighlight(use_direct_label = FALSE) +
  xlim(c(0, 50))


measure %>%
  ggplot(aes(SL_mm, BW_g, color = Cruise)) +
  geom_point()

measure %>%
  dplyr::mutate(CF = BW_g * 1000000 / SL_mm ^ 3) %>%
  ggplot(aes(SL_mm, CF, color = Cruise)) +
  geom_point()

measure %>%
  dplyr::mutate(CF = BW_g * 1000000 / SL_mm ^ 3) %>%
  ggplot(aes(Cruise, CF, fill = Cruise)) +
  geom_boxplot()

measure %>%
  ggplot(aes(Cruise, SL_mm, fill = Cruise)) +
  geom_boxplot()

measure %>%
  dplyr::mutate(CF = BW_g * 1000000 / SL_mm ^ 3) %>%
  ggplot(aes(Cruise, CF/SL_mm, fill = Cruise)) +
  geom_boxplot()
