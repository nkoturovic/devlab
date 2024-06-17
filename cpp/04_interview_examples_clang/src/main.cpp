import examples;

#include <cstdlib>
#include <algorithm>

#include <argparse/argparse.hpp>
#include <fmt/core.h>
#include <fmt/ranges.h>

auto main(int argc, char *argv[]) -> int {
  auto arg_parser = argparse::ArgumentParser("run-example");
  arg_parser.add_argument("-e", "--example").help("runs the specified example");
  arg_parser.add_argument("-l", "--list")
      .help("prints list of all examples")
      .implicit_value(true)
      .default_value(false);

  try {
    arg_parser.parse_args(argc, argv);
  } catch (const std::exception &err) {
    fmt::println("Error: {}", err.what());
    fmt::println("{}", arg_parser.help().str());
    return EXIT_FAILURE;
  }

  // a helper struct for stroing example information
  struct Example {
    using function_type = void (*)();
    std::string_view name;
    function_type example;
  };

  constexpr auto examples_list =
      std::array{Example{.name = "read_lines", .example = examples::read_lines}};

  if (arg_parser.is_used("--list")) {
    fmt::println("List of examples: ");
    for (auto &&[name, _] : examples_list) {
      fmt::println("  - {}", name);
    }
  } else if (arg_parser.is_used("--example")) {
    auto target_example_name = arg_parser.get("--example");
    const auto *example = std::ranges::find(examples_list, target_example_name, &Example::name);
    if (example == std::cend(examples_list)) {
      fmt::println(stderr, "Example '{}' doesn't exist", target_example_name);
      return EXIT_FAILURE;
    }
    fmt::println("Running '{}' example ...", target_example_name);
    example->example();
  }
}
