# Load "subject_test" into R
subject.test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.name = "subject")

# Load "y_test" into R 
y.test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.name = "activity")

# Load "x_test" into R
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt")

# Load "features into R" 
features <- read.table("./UCI HAR Dataset/features.txt")
features <- features["V2"]

# Find features with words "mean" or "std" in them
check.match <- grepl("mean|std", features$V2)
coi <- which(check.match == TRUE)

# Subset relevant columns
x.test <- x.test[, which(check.match == TRUE)]

# Label data with descriptive variable names
dvn <- as.character(features[c(coi), 1])
colnames(x.test) <- dvn

# Tidy "test" dataset 
subject.y.features.test <- cbind(subject.test, y.test, x.test)

##########

# Load "subject_train" into R
subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.name = "subject")

# Load "y_train" into R
y.train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.name = "activity")

# Load "x_train" into R 
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")

# Load "features" into R
features <- read.table("./UCI HAR Dataset/features.txt")
features <- features["V2"]

# Find features with words "mean" or "std" in them
test <- c("mean", "std")
check.match <- grepl("mean|std", features$V2)
coi <- which(check.match == TRUE)

# Subset relevant columns 
x.train <- x.train[, which(check.match == TRUE)]

# Label data with descriptive variable names
dvn <- as.character(features[c(coi), 1])
colnames(x.train) <- dvn

# Tidy "train" dataset
subject.y.features.train <- cbind(subject.train, y.train, x.train)

##########

# Combine tidy "test" and "train" datasets
new.ds <- rbind(subject.y.features.test, subject.y.features.train)

# Order the new dataset first by subject, then by activity
new.ds <- new.ds[order(new.ds$subject, new.ds$activity),]

# Label data with descriptive activity names 
new.ds[new.ds$activity == 1, 2] <- "walking"; 
new.ds[new.ds$activity == 2, 2] <- "walking_upstairs"; 
new.ds[new.ds$activity == 3, 2] <- "walking_downstairs"; 
new.ds[new.ds$activity == 4, 2] <- "sitting"; 
new.ds[new.ds$activity == 5, 2] <- "standing"; 
new.ds[new.ds$activity == 6, 2] <- "laying"

##########

# Create a second, independent data set 
average.ds <- data.frame(subject = rep(1:30, each = 6), activity = rep(c("walking", 
 "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying")))

# Find the average of each variable
average.list <- c()
for(i in 1:30) {
        new.ds.subset <- subset(new.ds, subject == i & activity == "walking")
        average.walking <- as.vector(colMeans(new.ds.subset[,c(3:81)]))
        average.list <- c(average.list, average.walking)
        
        new.ds.subset <- subset(new.ds, subject == i & activity == "walking_upstairs")
        average.walking_upstairs <- as.vector(colMeans(new.ds.subset[,c(3:81)]))
        average.list <- c(average.list, average.walking_upstairs)
        
        new.ds.subset <- subset(new.ds, subject == i & activity == "walking_downstairs")
        average.walking_downstairs <- as.vector(colMeans(new.ds.subset[,c(3:81)]))
        average.list <- c(average.list, average.walking_downstairs)
        
        new.ds.subset <- subset(new.ds, subject == i & activity == "sitting")
        average.sitting <- as.vector(colMeans(new.ds.subset[,c(3:81)]))
        average.list <- c(average.list, average.sitting)
        
        new.ds.subset <- subset(new.ds, subject == i & activity == "standing")
        average.standing <- as.vector(colMeans(new.ds.subset[,c(3:81)]))
        average.list <- c(average.list, average.standing)
        
        new.ds.subset <- subset(new.ds, subject == i & activity == "laying")
        average.laying <- as.vector(colMeans(new.ds.subset[,c(3:81)]))
        average.list <- c(average.list, average.laying)
}

# Set up the averages as a matrix
average.matrix <- matrix(average.list, ncol = 79, nrow = 180, byrow = TRUE)
colnames(average.matrix) <- dvn

# Combine everything
average.ds <- cbind(average.ds, average.matrix)

# Write the new dataset as a text file
average.ds <- as.data.frame(average.ds)
write.table(average.ds, "average.ds.txt", row.names = FALSE)