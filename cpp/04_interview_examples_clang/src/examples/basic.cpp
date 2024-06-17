module;
#include <string> // std::getline
#include <istream> // required
#include <vector>

export module examples;

namespace examples {
export [[nodiscard]] auto read_lines(std::istream &input) -> std::vector<std::string> {
  auto lines = std::vector<std::string>{};
  for (std::string line; std::getline(input, line /* ,'\n' */);) {
    lines.emplace_back(std::move(line));
  }
  return lines;
}
} // namespace example
