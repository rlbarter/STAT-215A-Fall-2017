# Example based on Chris Paciorek's tutorial:
# https://github.com/berkeley-scf/tutorial-parallel-basics/blob/master/parallel-basics.html
#
# Note: there is a conflict between openBLAS, the multi-threaded linear
# algebra package, and foreach.  It can cause linear algebra operations
# within a foreach loop to hang
# If your system uses openBLAS (note that the SCF computers do),
# then before running R, execute the command:
#
# export OMP_NUM_THREADS=1
#
# This command sets an environment variable that tells BLAS to only
# use a single thread.


###################################################
########## identify number of cores ###############
###################################################




###################################################
################### FOREACH #######################
###################################################

library(foreach)
library(doParallel)

# load in data and looFit
source("rf.R")

# look at the looFit (leave-one-out fit) function
looFit

# set the number of cores to use manually
nCores <- 4
registerDoParallel(nCores) 

# do only first 30 for illustration
nSub <- 30


result <- foreach(i = 1:nSub) %dopar% {
  cat('Starting ', i, 'th job.\n', sep = '')
  output <- looFit(i, Y, X)
  cat('Finishing ', i, 'th job.\n', sep = '')
  output # this will become part of the out object
}

result_df <- data.frame(results = unlist(result))

# remember to save the results of your analysis if 
# you're running it using a shell script!
write.csv(result_df, "results_foreach.csv")


####################################################
################## parLapply #######################

library(parallel)

# set the number of cores to use manually
nCores <- 4  # to set manually 
cl <- makeCluster(nCores) 

nSub <- 30
input <- 1:nSub

# clusterExport(cl, c('x', 'y')) # if the processes need objects
# from master's workspace (not needed here as no global vars used)

# need to load randomForest package within function
# when using parLapply/parSapply
result <- parLapply(cl = cl, 
                 X = input,
                 FUN = looFit, 
                 # extra arguments to looFit
                 Y, X, TRUE)

result_df <- data.frame(results = unlist(result))


# remember to save the results of your analysis if 
# you're running it using a shell script!
write.csv(result_df, "results_foreach.csv")