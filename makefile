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


# Where to find user code.
SRC_DIR = ./src


# Flags passed to the preprocessor.
CPPFLAGS += -isystem

# Flags passed to the C++ compiler.
CXXFLAGS += --std=c++1414 -g -Wall -Wextra -pthread

TARGET = main

# House-keeping build targets.

all : main

main : $(SRC_DIR)/main.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -lpthread $^ -o $@

clean :
	# Cleaning intermediate and output files ($(TARGET))
	rm $(TARGET) 
# rm -f $(TARGET) gtest.a gtest_main.a *.o *.exe
