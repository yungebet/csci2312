# Make file for CSCI 2312

# Please feel free to explore these commands and their options.

# In very simple terms, we are setting up aliases, and simple scripts that can quickly referenced and executed from the terminal.

# Based mainly on the template provided in Google Test documentation.

# -------------------------------------------------------------------

# A sample Makefile for building Google Test and using it in user
# tests.
#
# SYNOPSIS:
#
#   make [all]  - makes everything.
#   make TARGET - makes the given target. A target is a keyword setup on the left side of a colon.
#   make clean  - removes all files generated by make.

# Please tweak the following variable definitions as needed by your
# project, except GTEST_HEADERS, which you can use in your own targets
# but shouldn't modify.


# Where to find user code.
USER_DIR = ./src

# Where to find the unit tests.
TEST_DIR = ./tests

# Flags passed to the preprocessor.
# Set Google Test's header directory as a system directory, such that
# the compiler doesn't generate warnings in Google Test headers.
CPPFLAGS += -isystem $(GTEST_DIR)/include

# Flags passed to the C++ compiler.
# These ones mean we wish to see all warnings generated by our code and that threading with be used (by the tests, not us)
CXXFLAGS += -g -Wall -Wextra -pthread

# All tests produced by this Makefile.  Remember to add new tests you
# created to the list.
TESTS = hello_test goodbye_test main

# All Google Test headers.  Usually you shouldn't change this
# definition.
GTEST_HEADERS = $(GTEST_DIR)/include/gtest/*.h \
                $(GTEST_DIR)/include/gtest/internal/*.h

# House-keeping build targets.

all : tests

tests : $(TESTS)

clean :
	rm -f $(TESTS) gtest.a gtest_main.a *.o *.exe

# Builds gtest.a and gtest_main.a.

# Usually you shouldn't tweak such internal variables, indicated by a
# trailing _.
GTEST_SRCS_ = $(GTEST_DIR)/src/*.cc $(GTEST_DIR)/src/*.h $(GTEST_HEADERS)

# For simplicity and to avoid depending on Google Test's
# implementation details, the dependencies specified below are
# conservative and not optimized.  This is fine as Google Test
# compiles fast and for ordinary users its source rarely changes.
gtest-all.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
            $(GTEST_DIR)/src/gtest-all.cc

gtest_main.o : $(GTEST_SRCS_)
	$(CXX) $(CPPFLAGS) -I$(GTEST_DIR) $(CXXFLAGS) -c \
            $(GTEST_DIR)/src/gtest_main.cc

gtest.a : gtest-all.o
	$(AR) $(ARFLAGS) $@ $^

gtest_main.a : gtest-all.o gtest_main.o
	$(AR) $(ARFLAGS) $@ $^

# Builds a sample test.  A test should link with either gtest.a or
# gtest_main.a, depending on whether it defines its own main()
# function.

## Building the unit tests requires proper linking with user source code, the unit tests as well as the Google Test library. ##

# This is done in three steps:

### STEP 1: Compile a source file into an object file ###

## If hello.cc depends on other .cc files, list them on the first line, making sure to include their file paths.

hello.o : $(USER_DIR)/hello.cc $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/hello.cc

### STEP 2: Compile test's source file into an object file ###

hello_test.o : $(TEST_DIR)/hello_test.cc \
                    $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/hello_test.cc

### STEP 3: Link the source object file with the test object file, link googletest with them, and spawn an executable ###

hello_test : hello.o hello_test.o gtest_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@


## The steps are repeated for each unit test. ##

goodbye.o : $(USER_DIR)/goodbye.cc $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(USER_DIR)/goodbye.cc

goodbye_test.o : $(TEST_DIR)/goodbye_test.cc \
                     $(GTEST_HEADERS)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $(TEST_DIR)/goodbye_test.cc

goodbye_test : goodbye.o goodbye_test.o gtest_main.a
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

## To build the main program, first call the build targets for any object files that need to be linked, then the main.cc file. ##

main : hello.o goodbye.o $(USER_DIR)/main.cc
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

# Run targets for the unit tests.

# If you want the hello_unittest target to run automatically after it's built, you can add a command to execute the built program within the same target in the Makefile.

# Here's how you can modify the hello_unittest target to do this:

# make

# hello_unittest : hello.o hello_unittest.o gtest_main.a
# 	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@
# 	./$@

# The ./$@ line will run the program after it's built. $@ is an automatic variable that represents the target name, which in this case is hello_unittest.

# However, a more conventional approach is to have separate targets for building and running. For example:

# make

# # Build target
# hello_unittest : hello.o hello_unittest.o gtest_main.a
# 	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

# # Run target
# run_hello_unittest: hello_unittest
# 	./hello_unittest

# With this setup, you would run make run_hello_unittest to both build and run the hello_unittest program.
# If hello_unittest is already up-to-date and hasn't been modified, make will skip the build step and just
# run the program. If it's out-of-date, make will rebuild hello_unittest first and then run it.

run_main : main
	./main

run_all_tests : run_hello_test run_goodbye_test

run_hello_test : hello_test
	./hello_test

run_goodbye_test : goodbye_test
	./goodbye_test
