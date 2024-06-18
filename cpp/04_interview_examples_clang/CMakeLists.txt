cmake_minimum_required(VERSION 3.29)
Project(InterviewExamples)

set(CMAKE_CXX_STANDARD 26)

set(CLANG_WARNINGS
    -Wall
    -Wextra # reasonable and standard
    -Wshadow # warn the user if a variable declaration shadows one from a parent context
    -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps
    # catch hard to track down memory errors
    -Wold-style-cast # warn for c-style casts
    -Wcast-align # warn for potential performance problem casts
    -Wunused # warn on anything being unused
    -Woverloaded-virtual # warn if you overload (not override) a virtual function
    -Wpedantic # warn if non-standard C++ is used
    -Wconversion # warn on type conversions that may lose data
    -Wsign-conversion # warn on sign conversions
    -Wnull-dereference # warn if a null dereference is detected
    -Wdouble-promotion # warn if float is implicit promoted to double
    -Wformat=2 # warn on security issues around functions that format output (ie printf)
    -Wimplicit-fallthrough # warn on statements that fallthrough without an explicit annotation
)

add_subdirectory(examples)

find_package(fmt REQUIRED)
find_package(argparse REQUIRED)

add_executable(run-example main.cpp)
target_compile_options(run-example PRIVATE ${CLANG_WARNINGS})
target_link_libraries(run-example PRIVATE examples fmt::fmt argparse::argparse)

install(TARGETS run-example)
