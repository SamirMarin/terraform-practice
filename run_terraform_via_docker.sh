command=$1
docker run --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -i -t -v $PWD:$PWD -w $PWD hashicorp/terraform:0.12.0 $command

