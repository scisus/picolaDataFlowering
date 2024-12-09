# functions for clean_pheno.R

## read in ALL the excel sheets and pop them into a dataframe with a column identifying orchard
read_excel_tidy <- function(path, orchard_ids, sheets = 1, skip = 0, n_max = Inf, col_classes = NULL) {
    df <- lapply(excel_sheets(path)[sheets], read_excel,
                 path = path, col_types = col_classes, skip = skip, n_max = n_max)
    names(df) <- c(orchard_ids)
    plyr::ldply(df, .id = "Orchard")
}

# Add UID
# This function adds a unique identifier for each new record added to the dataset
add_new_records_to_df_with_UID <- function(new_records, old_dataframe = fromRW, uid_col = fromRW$UID) { # both old_dataframe and new_records should be dataframes. old_dataframe must contain a UID column
    maxUID <- max(uid_col)
    new_records$UID <- c((maxUID+1) : (maxUID+nrow(new_records)) )
    df <- rbind(old_dataframe, new_records)
    check <- assertthat::are_equal(nrow(old_dataframe), nrow(df)-nrow(new_records))
    stopifnot(check)
    return(df)
}

#Function to find and replace problem entries in PGTIS data. Includes feedback on replacements and current entries in vector.
fixweird <- function(vec, weird, replacement, df = fromRW) {
    if(any(is.na(weird))) stop("This function cannot replace NAs")
    weird_locs <- which(vec %in% weird) #find weirdos
    if (length(weird_locs) == 0) print("There's nothing like that here") else{
        print("Replacing entries like:")
        print(head(df[weird_locs,]))
        vec[weird_locs] <- replacement #replace weirdos
        print(c(paste("Replaced", length(weird_locs), "entries from")))
        deparse(substitute(vec))
        uniques <- unique(vec) #rebuild uniques to search for more problems
        print(c("Anything left to fix?", uniques))
        return(vec)
    }
    return(vec)
}

na_colmerge <- function(df, col1, col2) { #merge two columns in a dataframe, replacing NAs in the first column with values in the second column and then drop the replacing column. Columns should be character
    nacol <- which(colnames(df) == col1) # to be replaced
    repcol <- which(colnames(df) == col2) # replacement values
    df[ , nacol] <- ifelse(test = is.na(df[ , nacol]), yes = df[ , repcol], no = df[ , nacol])
    df[ , repcol] <- NULL
    return(df)
}

destroy_factors <- function(dat) { #convert all factor columns in a dataframe to character
    ss <- sapply(dat, is.factor)
    dat[ss] <- lapply(dat[ss], as.character)
    return(dat)
}

# remove or replace NAs in one column based on matching columns and decisions in a separate dataframe. data and criteria should be dataframes. id should be a vector of colnames that uniquely identify records of interest.
remove_and_replace_NAs <- function(data, criteria, id) {
    no_NAset <- data[!is.na(data$Phenophase),]
    NAset <- data[is.na(data$Phenophase),]
    criteria <- subset(criteria, !criteria$Action == "Nothing")
    if(assertthat::are_equal(nrow(unique(NAset[ , colnames(NAset) %in% id])), nrow(criteria)) == FALSE) {
        stop("You have criteria that aren't in the data and/or data that aren't in the criteria. Figure out which criteria you entered wrong or are missing.")
    }
    print("Number of NA entries:")
    the_NAs <- nrow(NAset)
    print(the_NAs)


    fixframe <- merge(NAset, criteria, all.x = TRUE) # Assign criteria to NA Phenophases
    if(assertthat::are_equal(sort(as.character(unique(fixframe$Action))), sort(c("Remove", "Replace"))) == FALSE) {
        stop("Some NA data do not have an associated criteria. Please update criteria.")
    }

    #Remove rows marked for Removal
    print("Number of removed NA entries:")
    the_removed <- length(which(fixframe$Action == "Remove"))
    print(the_removed)
    fixframe <- fixframe[fixframe$Action == "Replace",] #remove NAs that should be removed

    #Replace rows marked for replacement
    fixframe$Phenophase <- "-"#replace remaining NAs
    print("Number of replaced NA entries:")
    the_replaced <- nrow(fixframe)
    print(the_replaced)

    if(assertthat::are_equal(the_removed + the_replaced, the_NAs) == FALSE) {
        stop("You can't remove and replace more than the total number of NAs")
    }

    #Recombine non-NA data with corrected NA data
    correcteddata <- merge(no_NAset, fixframe, all.x = TRUE, all.y = TRUE)
    correcteddata$Action <- NULL
    return(correcteddata)
}


#standardize names
standardize_colnames <- function(dataframe) { #replace column names with easier and standard column names
    colnames(dataframe)[5:11] <- c("receptive20", "pollenshed20", "receptive80", "pollenshed80", "pickdate", "total_cone_weight_kg", "thirty_cone_weight_g")
    clone_loc <- which(colnames(dataframe) == "regno")
    if (length(clone_loc)>0) {colnames(dataframe)[clone_loc] <- "Clone"}
    return(dataframe)
}


# assign correct class to columns of walsh data dataframes

correct_walsh_col_types <- function(df) {

  df <- as.data.frame(df)

  char_cols <- c('Site', 'Orchard', 'Clone', 'X', 'Y')
  date_cols <- c('receptive20', 'pollenshed20', 'receptive80', 'pollenshed80', 'pickdate')
  num_cols <- c('total_cone_weight_kg', 'thirty_cone_weight_g')

  cols <- colnames(df)

  for (i in 1:length(cols)) {

    if (cols[i] %in% char_cols) df[,i] <- as.character(df[,i])
    if (cols[i] %in% date_cols) df[,i] <- df[,i]
    if (cols[i] %in% num_cols) df[,i] <- as.numeric(df[,i])
  }
  return(df)
}

