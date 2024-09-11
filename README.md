I have carefully created a few regular workings with R using common tools for data science.
There is a lot to learn in here.
Explore the covid data
Explore the function that returns all the associations of a postcode.
Enjoy learning and gyming on R


To load git codes into R using R codes,
library(git2r)
#load codes into a specified directory
clone(url = "https://github.com/sholex111/rgym.git", local_path = "copy your folder path here")


To load the repo without installing GIT use git2r package


install.packages("git2r")

library(git2r)

# Specify the URL of the repository and the destination directory
repo_url <- "https://github.com/sholex111/rgym.git"
destination <- "C:/Users/****"

# Clone the repository
repo <- clone(repo_url, destination)

# Verify the cloned repository
print(repo)









