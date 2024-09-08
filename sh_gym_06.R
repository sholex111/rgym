
##### R-Fingertips 
# https://github.com/ropensci/fingertipsR#example

# # Enable repository from ropensci
# options(repos = c(
#   ropensci = 'https://ropensci.r-universe.dev',
#   CRAN = 'https://cloud.r-project.org'))
# 
# 
# # Download and install fingertipsR in R
# install.packages('fingertipsR')



library(fingertipsR)

######Step 1 -->  view and select profiles

profs <- profiles()
profs <- profs[grepl("Public Health Outcomes Framework", profs$ProfileName),]
head(profs)
#> # A tibble: 6 x 4
#>   ProfileID ProfileName                        DomainID DomainName              
#>       <int> <chr>                                 <int> <chr>                   
#> 1        19 Public Health Outcomes Framework    1000049 A. Overarching indicato~
#> 2        19 Public Health Outcomes Framework    1000041 B. Wider determinants o~
#> 3        19 Public Health Outcomes Framework    1000042 C. Health improvement   
#> 4        19 Public Health Outcomes Framework    1000043 D. Health protection    
#> 5        19 Public Health Outcomes Framework    1000044 E. Healthcare and prema~
#> 6        19 Public Health Outcomes Framework 1938132983 Supporting information

# This table shows that the ProfileID for the Public Health Outcomes Framework is 19. 
# This can be used as an input for the indicators() function:



###### Step 2 -->  view and select profiles
  
profid <- 19

#list all indicators associated with profile 19
inds <- indicators(ProfileID = profid)

print(inds[grepl("Healthy", inds$IndicatorName), c("IndicatorID", "IndicatorName")])
#> # A tibble: 2 x 2
#>   IndicatorID IndicatorName                          
#>         <int> <fct>                                  
#> 1       90362 A01a - Healthy life expectancy at birth
#> 2       93505 A01a - Healthy life expectancy at 65



#Healthy Life Expectancy at Birth has the IndicatorID equal to 90362.

#Finally, the data can be extracted using the fingertips_data() function using that IndicatorID:


# indid <- 93505
# df <- fingertips_data(IndicatorID = indid, AreaTypeID = 202)
## The above for some reasons returns no observation (i guess data was retired) 

## navigate to any indicator through the fingertips website
# https://fingertips.phe.org.uk/profile/public-health-outcomes-framework/data#page/3/
# gid/1000049/ati/502/iid/90362/age/1/sex/1/cat/-1/ctp/-1/yrr/3/cid/4/tbm/1/page-options/car-do-0

df_1 <- fingertips_data(IndicatorID = 90362, AreaTypeID = 502)

head(df_1)


