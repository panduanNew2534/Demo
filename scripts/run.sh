#!/bin/bash

CUR_OS="$( uname -s)"
echo $CUR_OS
if [ "$CUR_OS" = "Darwin" ]; then
    # brew install postgresql
    echo "skip"
else
    sudo apt-get update
fi

#set ENV
ENV="$1"

echo ENV="$ENV"
export ENV

# Go out to root of folder
cd ../
FOLDERNAME=${PWD##*/}
export FOLDERNAME

# Set test ENV
RESULT_FOLDER="results/$ENV"
pip install -r requirements.txt

rm -rf $RESULT_FOLDER
mkdir -p $RESULT_FOLDER
cd $RESULT_FOLDER
PWD

echo "RESULT_FOLDER" = "$RESULT_FOLDER"
if command -v python3; then
    python3 -m robot.run -L TRACE -v env:$ENV -o "$RESULT_FOLDER" ../../testcases/ 
else
    python -m robot.run -L TRACE -v env:$ENV -o "$RESULT_FOLDER" ../../testcases/
fi

# For do not let Jenkins mark failed from shell script.
exit 0