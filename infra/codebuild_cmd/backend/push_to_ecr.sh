cd "${CODEBUILD_SRC_DIR}/backend"
echo Push the docker image

echo Logining in to Amazon ECR...

ECR_REPO_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin $ECR_REPO_URI

docker tag "youtube-movies-analytics-backend:latest" "${ECR_REPO_URI}/youtube-movies-analytics-backend:latest"
docker push "${ECR_REPO_URI}/youtube-movies-analytics-backend:latest"

echo Push completed on `date`

echo Writing image definitions file...
printf '[{"name":"youtube-movies-analytics","imageUri":"%s"}]' "${ECR_REPO_URI}/youtube-movies-analytics-backend:latest" > imagedefinitions.json
