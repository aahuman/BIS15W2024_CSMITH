---
title: "Midterm 1 W24"
author: "Clive Smith"
date: "2024-02-06"
output:
  html_document: 
    keep_md: yes
  pdf_document: default
---

## Instructions
Answer the following questions and complete the exercises in RMarkdown. Please embed all of your code and push your final work to your repository. Your code must be organized, clean, and run free from errors. Remember, you must remove the `#` for any included code chunks to run. Be sure to add your name to the author header above. 

Your code must knit in order to be considered. If you are stuck and cannot answer a question, then comment out your code and knit the document. You may use your notes, labs, and homework to help you complete this exam. Do not use any other resources- including AI assistance.  

Don't forget to answer any questions that are asked in the prompt!  

Be sure to push your completed midterm to your repository. This exam is worth 30 points.  

## Background
In the data folder, you will find data related to a study on wolf mortality collected by the National Park Service. You should start by reading the `README_NPSwolfdata.pdf` file. This will provide an abstract of the study and an explanation of variables.  

The data are from: Cassidy, Kira et al. (2022). Gray wolf packs and human-caused wolf mortality. [Dryad](https://doi.org/10.5061/dryad.mkkwh713f). 

## Load the libraries

```r
library("tidyverse")
library("janitor")
```

## Load the wolves data
In these data, the authors used `NULL` to represent missing values. I am correcting this for you below and using `janitor` to clean the column names.

```r
wolves <- read.csv("data/NPS_wolfmortalitydata.csv", na = c("NULL")) %>% clean_names()
```

## Questions
Problem 1. (1 point) Let's start with some data exploration. What are the variable (column) names?  


```r
names(wolves)
```

```
##  [1] "park"         "biolyr"       "pack"         "packcode"     "packsize_aug"
##  [6] "mort_yn"      "mort_all"     "mort_lead"    "mort_nonlead" "reprody1"    
## [11] "persisty1"
```

Problem 2. (1 point) Use the function of your choice to summarize the data and get an idea of its structure.  


```r
str(wolves)
```

```
## 'data.frame':	864 obs. of  11 variables:
##  $ park        : chr  "DENA" "DENA" "DENA" "DENA" ...
##  $ biolyr      : int  1996 1991 2017 1996 1992 1994 2007 2007 1995 2003 ...
##  $ pack        : chr  "McKinley River1" "Birch Creek N" "Eagle Gorge" "East Fork" ...
##  $ packcode    : int  89 58 71 72 74 77 101 108 109 53 ...
##  $ packsize_aug: num  12 5 8 13 7 6 10 NA 9 8 ...
##  $ mort_yn     : int  1 1 1 1 1 1 1 1 1 1 ...
##  $ mort_all    : int  4 2 2 2 2 2 2 2 2 1 ...
##  $ mort_lead   : int  2 2 0 0 0 0 1 2 1 1 ...
##  $ mort_nonlead: int  2 0 2 2 2 2 1 0 1 0 ...
##  $ reprody1    : int  0 0 NA 1 NA 0 0 1 0 1 ...
##  $ persisty1   : int  0 0 1 1 1 1 0 1 0 1 ...
```

Problem 3. (3 points) Which parks/ reserves are represented in the data? Don't just use the abstract, pull this information from the data.  


```r
table(wolves$park)
```

```
## 
## DENA GNTP  VNP  YNP YUCH 
##  340   77   48  248  151
```
Denali National Park, Grand Teton National Park, Voyageurs National Park, Yellowstone National Park, and Yukon-Charley Rivers National Preserve are represented in the data.

Problem 4. (4 points) Which park has the largest number of wolf packs?


```r
wolves %>% 
  group_by(park) %>% 
  summarize(wolf_packs=n_distinct(pack)) %>% 
  arrange(desc(wolf_packs))
```

```
## # A tibble: 5 × 2
##   park  wolf_packs
##   <chr>      <int>
## 1 DENA          69
## 2 YNP           46
## 3 YUCH          36
## 4 VNP           22
## 5 GNTP          12
```
Denali National Park has the greatest number of wolf packs. 

Problem 5. (4 points) Which park has the highest total number of human-caused mortalities `mort_all`?


```r
wolves %>% 
  group_by(park) %>% 
  summarize(h_caused_deaths=sum(mort_all)) %>% 
  arrange(desc(h_caused_deaths))
```

```
## # A tibble: 5 × 2
##   park  h_caused_deaths
##   <chr>           <int>
## 1 YUCH              136
## 2 YNP                72
## 3 DENA               64
## 4 GNTP               38
## 5 VNP                11
```
Yukon-Charley Rivers National Preserve has the most human-caused mortalities. 

The wolves in [Yellowstone National Park](https://www.nps.gov/yell/learn/nature/wolf-restoration.htm) are an incredible conservation success story. Let's focus our attention on this park.  

Problem 6. (2 points) Create a new object "ynp" that only includes the data from Yellowstone National Park.  


```r
ynp <- wolves %>% 
  filter(park=="YNP")
```


Problem 7. (3 points) Among the Yellowstone wolf packs, the [Druid Peak Pack](https://www.pbs.org/wnet/nature/in-the-valley-of-the-wolves-the-druid-wolf-pack-story/209/) is one of most famous. What was the average pack size of this pack for the years represented in the data?


```r
ynp %>% 
  filter(pack=="druid") %>% 
  summarize(mean_pack_size=mean(packsize_aug), 
            n_years=n())
```

```
##   mean_pack_size n_years
## 1       13.93333      15
```

Problem 8. (4 points) Pack dynamics can be hard to predict- even for strong packs like the Druid Peak pack. At which year did the Druid Peak pack have the largest pack size? What do you think happened in 2010?


```r
ynp %>% 
  filter(pack=="druid") %>% 
   group_by(biolyr) %>% 
  summarize(pack_size=sum(packsize_aug)) %>% 
  arrange(desc(pack_size))
```

```
## # A tibble: 15 × 2
##    biolyr pack_size
##     <int>     <dbl>
##  1   2001        37
##  2   2000        27
##  3   2008        21
##  4   2003        18
##  5   2007        18
##  6   2002        16
##  7   2006        15
##  8   2004        13
##  9   2009        12
## 10   1999         9
## 11   1998         8
## 12   1996         5
## 13   1997         5
## 14   2005         5
## 15   2010         0
```
In 2010, the pack size was 0. 2010 is also the last year that the Druid Peak pack appears in the data frame. This means that the remaining members of the pack likely died in 2010.

Problem 9. (5 points) Among the YNP wolf packs, which one has had the highest overall persistence `persisty1` for the years represented in the data? Look this pack up online and tell me what is unique about its behavior- specifically, what prey animals does this pack specialize on?  


```r
ynp %>% 
  group_by(pack) %>% 
  summarize(pack_persistence=sum(persisty1, na.rm=T)) %>% 
  arrange(desc(pack_persistence))
```

```
## # A tibble: 46 × 2
##    pack        pack_persistence
##    <chr>                  <int>
##  1 mollies                   26
##  2 cougar                    20
##  3 yelldelta                 18
##  4 druid                     13
##  5 leopold                   12
##  6 agate                     10
##  7 8mile                      9
##  8 canyon                     9
##  9 gibbon/mary                9
## 10 nezperce                   9
## # ℹ 36 more rows
```
Mollie's Pack has survived with at least 2 members for 26 years, making it the pack with the highest overall persistence in Yellowstone National Park. According to the [Yellowstone Wolf website](https://www.yellowstonewolf.org/yellowstones_wolves.php?pack_id=6), this pack mostly relies on hunting bison to survive. 

Problem 10. (3 points) Perform one analysis or exploration of your choice on the `wolves` data. Your answer needs to include at least two lines of code and not be a summary function.  

I wanted to see which national park wolves had the highest persistence in.


```r
wolves %>% 
   group_by(park) %>% 
  summarize(overall_park_persistence=sum(persisty1, na.rm=T), 
            n=n()) %>% 
  arrange(desc(overall_park_persistence))
```

```
## # A tibble: 5 × 3
##   park  overall_park_persistence     n
##   <chr>                    <int> <int>
## 1 DENA                       295   340
## 2 YNP                        219   248
## 3 YUCH                       129   151
## 4 GNTP                        71    77
## 5 VNP                         44    48
```
This order makes sense to me, given that Denali also has the highest number of distinct wolf packs. Thinking more logically, this makes sense to me, given that Denali National Park is very large, and is in Alaska, a very remote state. 
