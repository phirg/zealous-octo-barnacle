#!/bin/sh

CURRENT_DIR=$(pwd)
echo "current dir is $CURRENT_DIR"

POCO_INSTALL_PREFIX="/c/Program Files/Poco"

# get last poco via github
echo "getting the last poco release from github"
mkdir dependencies
cd dependencies
git clone https://github.com/pocoproject/poco.git
cd poco
POCO_TAG_NAME=$(git describe --tags)
echo "checking out poco at tag: $POCO_TAG_NAME"
git checkout $POCO_TAG_NAME

# build using cmake
echo "building poco with cmake" # which components?
cd ..; mkdir poco-build; cd poco-build

echo "preparing install destination to $POCO_INSTALL_PREFIX"
echo "CMake generator is: $GENERATOR"
cmake ../poco -DENABLE_XML=ON -DENABLE_JSON=ON -DENABLE_MONGODB=OFF -DENABLE_PDF=OFF \
    -DENABLE_UTIL=ON -DENABLE_NET=OFF -DENABLE_NETSSL=OFF -DENABLE_NETSSL_WIN=OFF -DENABLE_CRYPTO=OFF \
    -DENABLE_DATA=OFF -DENABLE_DATA_SQLITE=OFF -DENABLE_DATA_MYSQL=OFF -DENABLE_DATA_ODBC=OFF \
    -DENABLE_SEVENZIP=OFF -DENABLE_ZIP=OFF -DENABLE_APACHECONNECTOR=OFF -DENABLE_CPPPARSER=OFF \
    -DENABLE_POCODOC=OFF -DENABLE_PAGECOMPILER=OFF -DENABLE_PAGECOMPILER_FILE2PAGE=OFF \
    -DCMAKE_INSTALL_PREFIX="$POCO_INSTALL_PREFIX" -G"$GENERATOR" 
cmake --build . --config "RelWithDebInfo"
echo "Poco build done. "
cmake --build . --target install --config "RelWithDebInfo"
echo "Poco install done. "

export PATH="$POCO_INSTALL_PREFIX/bin:$PATH"
echo "new path is: $PATH"

cd $CURRENT_DIR
pwd
