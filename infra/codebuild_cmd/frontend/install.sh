cd "${CODEBUILD_SRC_DIR}/frontend"

echo Installing yarn...
npm install -g yarn

echo installing dependencies...
yarn install