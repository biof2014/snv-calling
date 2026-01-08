
# Convert quality score from string to numeric representation
quality_score <- function(s) {
	# ! is assigned a score of 0
	# charToRaw returns hexadecimal, which needs to be converted to integer
	as.integer(charToRaw(s)) - as.integer(charToRaw("!"))
}

phred_to_numeric <- function(scores) {
	10^(- scores / 10)
}

read_data <- function(path) {
	lines <- readLines(file.path(path, "indicators.txt"));
	indicatorsl <- lapply(strsplit(lines, ""), as.integer);

	strings <- readLines(file.path(path, "errors.txt"));
	qualsl <- lapply(strings, quality_score);
	errorsl <- lapply(qualsl, phred_to_numeric);

	lines <- readLines(file.path(path, "genotypes.txt"));
	genotypes <- unlist(lapply(lines, as.integer));

	# check that the lengths are the same
	stopifnot(length(indicatorsl) == length(errorsl))
	stopifnot(length(indicatorsl) == length(genotypes))

	# merge the indicators list and errors list
	reads <- mapply(
		function(x, e, g) {
			list(x = x, e = e)
		},
		indicatorsl, errorsl,
		SIMPLIFY = FALSE
	);

	list(
		input = reads,
		genotype = genotypes	
	)
}

write_output <- function(obj, name) {
	library(io)
	fname <- filename(name, ext="rds", path="calls", date=NA);
	qwrite(obj, fname);
}

