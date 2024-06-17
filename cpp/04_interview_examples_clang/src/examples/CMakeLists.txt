add_library(examples)
target_sources(examples
  PUBLIC
    FILE_SET CXX_MODULES FILES
      basic.cpp)
