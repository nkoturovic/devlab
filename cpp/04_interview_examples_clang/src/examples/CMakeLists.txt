add_library(examples)
target_compile_options(examples PRIVATE ${CLANG_WARNINGS})
target_sources(examples
  PUBLIC
    FILE_SET CXX_MODULES FILES
      basic.cpp)
