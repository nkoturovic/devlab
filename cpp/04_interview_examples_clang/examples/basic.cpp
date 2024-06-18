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

auto read_lines() -> void {
  auto lines = ::read_lines(std::cin);
  for (auto &&[i, line] : std::views::enumerate(lines)) {
    fmt::println("  {}. {}", i, line);
  }
  // use std::cin.rdbuf(); to read the intire buffer until eof
}

auto read_ints() -> void {
  // true if read was successfull
  std::vector<int> nums;
  for (int num; std::cin >> num;) {
    nums.push_back(num);
  }
  fmt::println("{}", nums);
  // to read a single charcter use: char c; cin.get(c);
}

auto weak_ptr() -> void {

  auto shared_ptr = std::make_shared<double>(1.0);
  auto weak1 = std::weak_ptr(shared_ptr); // not incrementing shared counter

  auto weak2 = [] {
    auto shared = std::make_shared<double>(2.0);
    // good for preventing dangling reference
    return std::weak_ptr(shared);
  }();

  // helper function for checking wether a weak_ptr has been expired
  auto check_expired = [](const std::weak_ptr<double> &weak_ptr) {
    // if expired => returns default-constructed shared_ptr of type T
    if (auto new_sp = weak_ptr.lock(); new_sp != nullptr) {
      fmt::println("{}", *new_sp);
    } else {
      fmt::println("Weak pointer has been expired");
    }
  };

  check_expired(weak1);
  check_expired(weak2);
};

} // namespace examples
