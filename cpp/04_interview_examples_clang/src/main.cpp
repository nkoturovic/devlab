import examples;

#include <iostream>

#include <fmt/core.h>
#include <fmt/ranges.h>

auto main(int /*argc*/, char * /*argv*/[]) -> int {

  auto lines = examples::read_lines(std::cin);
  fmt::println("{}", lines);

  return 0;
}
