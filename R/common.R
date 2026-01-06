
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

	# merge the indicators list and errors list
	ds <- mapply(
		function(x, e, g) {
			list(x = x, e = e)
		},
		indicatorsl, errorsl,
		SIMPLIFY = FALSE
	);

	list(
		input = ds,
		genotype = genotypes	
	)
}

