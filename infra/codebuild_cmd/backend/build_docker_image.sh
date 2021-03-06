cd "${CODEBUILD_SRC_DIR}/backend"
echo Build started on `date`

docker build -t youtube-movies-analytics-backend:latest ./
echo Build completed on `date`