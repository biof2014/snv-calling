#!/bin/bash

json_dev="evaluate.json"
json_prod="prod/evaluate.json"

echo "development:"
jq . $json_dev
echo "production:"
jq . $json_prod

pass_dev=$(jq .grade.pass[0] $json_dev)
total_dev=$(jq .grade.total[0] $json_dev)
echo "Development score: $pass_dev/$total_dev"

pass_prod=$(jq .grade.pass[0] $json_prod)
total_prod=$(jq .grade.total[0] $json_prod)
pass_prod=$(( 2 * pass_prod))
total_prod=$(( 2 * total_prod))
echo "Production score: $pass_prod/$total_prod"

pass=$(( pass_dev + pass_prod ))
total=$(( total_dev + total_prod ))
echo "::notice title=Autograding complete::Points ${pass}/${total}"
echo "::notice title=Autograding report::{\"totalPoints\":${pass},\"maxPoints\":${total}}"

