cmake_minimum_required(VERSION 3.29)

# Listing the version is nice here since it sets lots of useful variables
project(
  CppApp
  VERSION 0.1.0
  LANGUAGES CXX)


set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang++")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -stdlib=libc++ -lc++abi")

find_package(fmt REQUIRED)

# set(CMAKE_CXX_STANDARD 26)
add_compile_options(-std=c++2c -freflection -fparameter-reflection -fexpansion-statements -nostdinc++ -cxx-isystem /usr/local/include/c++/v1)
# set(CMAKE_AR      "/usr/local/bin/llvm-ar")
# set(CMAKE_LINKER  "/usr/local/bin/llvm-ld")
# set(CMAKE_NM      "/usr/local/bin/llvm-nm")
# set(CMAKE_OBJDUMP "/usr/local/bin/llvm-objdump")
# set(CMAKE_RANLIB  "/usr/local/bin/llvm-ranlib")

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_executable(cpp-app main.cpp)
target_link_libraries(cpp-app PRIVATE fmt::fmt)
