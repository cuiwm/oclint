#! /bin/bash

# setup environment variables
CWD=`pwd`
PROJECT_ROOT="$CWD/.."
LLVM_SRC="$PROJECT_ROOT/llvm"
LLVM_BUILD="$PROJECT_ROOT/build/llvm-install"
GOOGLE_TEST_SRC="$PROJECT_ROOT/googletest"
GOOGLE_TEST_BUILD="$PROJECT_ROOT/build/googletest"
OCLINT_CORE_SRC="$PROJECT_ROOT/oclint-core"
OCLINT_CORE_BUILD="$PROJECT_ROOT/build/oclint-core"
OCLINT_RULES_SRC="$PROJECT_ROOT/oclint-rules"
OCLINT_RULES_BUILD="$PROJECT_ROOT/build/oclint-rules"
SUCCESS=0

# create directory and prepare for build
mkdir -p $OCLINT_RULES_BUILD
cd $OCLINT_RULES_BUILD

# configure and build
if [ $SUCCESS -eq 0 ]; then
    cmake -D CMAKE_CXX_COMPILER=$LLVM_BUILD/bin/clang++ -D CMAKE_C_COMPILER=$LLVM_BUILD/bin/clang -D LLVM_ROOT=$LLVM_BUILD -D OCLINT_SOURCE_DIR=$OCLINT_CORE_SRC -D OCLINT_BUILD_DIR=$OCLINT_CORE_BUILD -D GOOGLETEST_SRC=$GOOGLE_TEST_SRC -D GOOGLETEST_BUILD=$GOOGLE_TEST_BUILD -D TEST_BUILD=1 $OCLINT_RULES_SRC
    if [ $? -ne 0 ]; then
        SUCCESS=1
    fi
fi
if [ $SUCCESS -eq 0 ]; then
    make
    if [ $? -ne 0 ]; then
        SUCCESS=2
    fi
fi
if [ $SUCCESS -eq 0 ]; then
    $OCLINT_RULES_BUILD/bin/rules_test > $OCLINT_RULES_BUILD/testresults.txt
    if [ $? -ne 0 ]; then
        SUCCESS=3
        cat $OCLINT_RULES_BUILD/testresults.txt
    fi
    tail -n 2 $OCLINT_RULES_BUILD/testresults.txt
fi

# back to the current folder
cd $CWD
exit $SUCCESS
