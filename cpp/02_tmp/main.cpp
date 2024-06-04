#include <cuchar>
#include <array>
#include <string>
#include <expected>
#include <variant>

#include "fmt/core.h"


struct Length {
    size_t from = 0;
    size_t to = 0;

    constexpr auto validate(auto const& val) const -> bool {
        return val >= from && val <= to;
    }

    constexpr auto message() const -> std::string {
        return fmt::format("Length needs to be between {} and {}", from, to);
    }
};

template <typename T, auto V>
class Valid {
    T m_value;

public:
    Valid(T t) : m_value(std::move(t)) {}

    constexpr auto value() -> T {
        return m_value;
    }

    constexpr auto validate() const -> std::expected<std::monostate, std::string> {
        if (!V.validate(m_value)) {
            return std::unexpected{V.message()};
        }
        return {};
    }

};

auto main() -> int {

    auto x = Valid<int, Length{.from=1, .to=2}>{4};
    if (auto val = x.validate(); val.has_value()) {
        fmt::println("Got value: {}", x.value());
    } else {
        fmt::println("Unexpected: {}", val.error());
    }

    return 0;
}
