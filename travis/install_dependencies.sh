#!/bin/bash

# exit as soon as a line fails, and print lines before executing it
set -ev

CURRENT_DIR=$(pwd)
echo "current dir is $CURRENT_DIR"

# test if poco has to be built
if [ $BUILD_POCO == true ]
then
    echo "build poco option active"

    echo "updating cmake to 3.0.0 (3.0.0 required for poco build) "
    CMAKE_VERSION_MAJOR_MINOR="3.0"
    CMAKE_VERSION_PATCH="0"
    CMAKE_VERSION="${CMAKE_VERSION_MAJOR_MINOR}.${CMAKE_VERSION_PATCH}"
    wget -V
    echo "as soon as wget is 1.13, we should disable certificate checking"
    wget --no-check-certificate "https://www.cmake.org/files/v${CMAKE_VERSION_MAJOR_MINOR}/cmake-${CMAKE_VERSION}.tar.gz"
    tar xzf "cmake-${CMAKE_VERSION}.tar.gz"
    cd "cmake-${CMAKE_VERSION}"
    cmake -DCMAKE_INSTALL_PREFIX=~ .
    make -j2
    make install
    export PATH="~\bin:${PATH}"
    # check that the version in PATH is the right one
    which cmake
    cmake --version

    cd ..

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
    cmake ../poco -DENABLE_XML=ON -DENABLE_JSON=ON -DENABLE_MONGODB=OFF -DENABLE_PDF=OFF \
    -DENABLE_UTIL=ON -DENABLE_NET=OFF -DENABLE_NETSSL=OFF -DENABLE_NETSSL_WIN=OFF -DENABLE_CRYPTO=OFF \
    -DENABLE_DATA=OFF -DENABLE_DATA_SQLITE=OFF -DENABLE_DATA_MYSQL=OFF -DENABLE_DATA_ODBC=OFF \
    -DENABLE_SEVENZIP=OFF -DENABLE_ZIP=OFF -DENABLE_APACHECONNECTOR=OFF -DENABLE_CPPPARSER=OFF \
    -DENABLE_POCODOC=OFF -DENABLE_PAGECOMPILER=OFF -DENABLE_PAGECOMPILER_FILE2PAGE=OFF \
    -DENABLE_REDIS=OFF
    make help
    make -j2

    # install using cmake
    echo "poco lib: cmake install"
    sudo make install
fi

# if poco is not being built, then get it from the packages
if [ $BUILD_POCO == false ]
then
    echo "get poco from the packages"
    # installing from packages
    if [ $TRAVIS_OS_NAME == linux ] 
    then 
    	echo "using apt-get"
            sudo apt-get install libpoco-dev -q -y 
            echo "poco lib installed with apt-get" 
    fi
    if [ $TRAVIS_OS_NAME == osx ] 
    then 
        echo "using homebrew"
        brew install poco
        echo "poco lib installed with homebrew" 
    fi
fi

cd $CURRENT_DIR
pwd
