cd "${CODEBUILD_SRC_DIR}/frontend"

echo Run frontend test code...
yarn test

echo Frontend app building...
yarn build