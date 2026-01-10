
# Convert quality score from string to numeric representation
quality_score <- function(s) {
	# ! is assigned a score of 0
	# charToRaw returns hexadecimal, which needs to be converted to integer
	as.integer(charToRaw(s)) - as.integer(charToRaw("!"))
}

phred_to_numeric <- function(scores) {
	10^(- scores / 10)
}

read_genotype <- function(path) {
	lines <- readLines(file.path(path, "genotypes.txt"));
	genotypes <- unlist(lapply(lines, as.integer));

	genotypes
}

read_input <- function(path) {
	lines <- readLines(file.path(path, "indicators.txt"));
	indicatorsl <- lapply(strsplit(lines, ""), as.integer);

	strings <- readLines(file.path(path, "errors.txt"));
	qualsl <- lapply(strings, quality_score);
	errorsl <- lapply(qualsl, phred_to_numeric);

	# check that the number of loci are the same
	stopifnot(length(indicatorsl) == length(errorsl))

	# check tha thte number of reads are the same
	stopifnot(unlist(lapply(indicatorsl, length)) == 
		unlist(lapply(errorsl, length)))

	# merge the indicators list and errors list
	reads <- mapply(
		function(x, e, g) {
			list(x = x, e = e)
		},
		indicatorsl, errorsl,
		SIMPLIFY = FALSE
	);

	reads
}

write_output <- function(obj, name, path="calls") {
	library(io)
	fname <- filename(name, ext="rds", path=path, date=NA);
	qwrite(obj, fname);
}

