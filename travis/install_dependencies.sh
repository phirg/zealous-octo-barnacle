#!/bin/bash

# exit as soon as a line fails, and print lines before executing it
set -ev

CURRENT_DIR=$(pwd)


# test if poco has to be built
if [ $BUILD_POCO == true ]
then
	echo "build poco option active"
    # get last poco via github
	echo "getting the last poco release from github"
    mkdir dependencies dependencies
    cd dependencies
    git clone https://github.com/pocoproject/poco.git
    POCO_TAG_NAME = $(git describe --tags)
    echo "checking out poco at tag: $POCO_TAG_NAME"
    git checkout $POCO_TAG_NAME

	# build using cmake
    echo "building poco with cmake" # which components? 

	# install using cmake
    echo "poco lib: cmake install"
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


echo "going back to current dir"
cd $CURRENT_DIR