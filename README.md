# SNV calling

In this project, you will implement statistical models in R 

## Instructions

1. Install R packages by
```
./setup.sh
```

2. Run the model evaluation by
```
./evaluate-dev.sh
```
If successful, the evaluation results will be in `evaluate-dev.json`.

3. As the evaluation results show, the stub implementations of the 
   diploid and somatic models are ineffective.
   Implement your diploid model in `run-diploid.R`.
   Implement your somatic model in `run-somatic.R`.
   As you develop your models, re-run the model evaluation to see how
   your models perform.

4. Commit your code *regularly* by
```
git add run-diploid.R run-somatic.R
git commit -m "Describe your changes"
```

5. Test your code on GitHub *occasionally* by
```
git push
```
Then, you can see your workflow status under the `Actions` tab
at your Github project repo.


## Important remarks for students

- Do *not* change any other files. Your models will be evaluated in a new
  clone of the original Github project repo, and 
  only your `run-diploid.R` and `run-somatic.R` will be copied over.
- Do *not* share your code with anyone.
  If your code is similar to another person's code, your novelty
  score will be low.
- Ensure that your models do *not* depend on packages that are not in
  `requirements-r.txt`, and do *not* add packages to `requirements-r.txt`.

