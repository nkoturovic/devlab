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

[[nodiscard]] static auto static_variables_impl() -> std::pair<int, int> {
  // global and static variables with predefined initial values.
  static int y; // .bss section
  y = 0;
  y++;

  static auto x = 0; // .data section
  x++;

  return {x, y};
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

// https : // downloads.ti.com/docs/esd/SPRUIG8/introduction-to-sections-stdz0691509.html
// The smallest unit of an object file is a section. A section is a block of code or data
// that occupies contiguous space in the memory map. Each section of an object file is
// separate and distinct.

// ELF format executable object files contain segments. An ELF segment is a meta-section. It
// represents a contiguous region of target memory. It is a collection of sections that have
// the same property, such as writeable or readable. An ELF loader needs the segment
// information, but does not need the section information. The ELF standard allows the
// linker to omit ELF section information entirely from the executable object file.

// Object files usually contain three default sections:
// .text section 	Contains executable code (1)
// .data section 	Usually contains initialized data
// .bss 	Usually reserves space for uninitialized variables
// 1. Some targets allow content other than text, such as constants, in .text sections.
//
// The linker allows you to create, name, and link other kinds of sections. The .text,
// .data, and .bss sections are archetypes for how sections are handled.
//
// There are two basic types of sections:
// Initialized sections 	Contain data or code. The .text and .data sections are
// initialized. Uninitialized sections 	Reserve space in the memory map for uninitialized
// data. The .bss section is uninitialized.

auto static_variables() {
  for (auto i : std::ranges::views::iota(1, 6)) {
    auto [x, y] = static_variables_impl();
    fmt::println("{}. iteration: (x = {}, y = {})", i, x, y);
  }
}

// TODO:
// * https://en.cppreference.com/w/cpp/language/aggregate_initialization
// * https://en.cppreference.com/w/cpp/language/structured_binding

} // namespace examples
