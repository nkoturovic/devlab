module;
#include <iostream>
#include <istream> // required
#include <ranges>
#include <string> // std::getline
#include <vector>

#include <fmt/core.h>
#include <fmt/ranges.h>

export module examples;

[[nodiscard]] static auto read_lines(std::istream &input) -> std::vector<std::string> {
  auto lines = std::vector<std::string>{};
  for (std::string line; std::getline(input, line /* ,'\n' */);) {
    lines.emplace_back(std::move(line));
  }
  return lines;
}

export namespace examples {
void read_lines() {
  auto lines = ::read_lines(std::cin);
  for (auto &&[i, line] : std::views::enumerate(lines)) {
    fmt::println("  {}. {}", i, line);
  }
}
} // namespace examples
