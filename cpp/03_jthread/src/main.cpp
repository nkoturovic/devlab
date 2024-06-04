#include <array>
#include <iostream>
#include <mutex>
#include <thread>

#include <fmt/format.h>

template <typename T, std::size_t N, typename F, std::size_t... I>
constexpr auto make_array_impl(F &&func, std::index_sequence<I...>) {
  return std::array<T, N>{{func(I)...}};
}

template <typename T, std::size_t N, typename F>
constexpr auto make_array(F &&func) {
  return make_array_impl<T, N>(std::forward<F>(func),
                               std::make_index_sequence<N>{});
}
int main(int argc, char *argv[]) {

  using namespace std::literals::chrono_literals;

  std::mutex print_mutex;
  auto thread_pool = make_array<std::jthread, 8>(
      [print_mutex = std::ref(print_mutex)](auto idx) {
        return std::jthread(
            [idx](std::stop_token stop_token, std::mutex &print_mutex) {
              while (true) {
                {
                  if (auto lock = std::scoped_lock{print_mutex};
                      !stop_token.stop_requested()) [[likely]] {
                    fmt::println("thread {}: sleeping for 200ms", idx);
                  } else {
                    fmt::println("thread {}: Stop token received", idx);
                    return;
                  }
                }
                std::this_thread::sleep_for(200ms);
              }
            },
            std::ref(print_mutex));
      });

  auto yn = 'y';
  while (true) {
    if (auto lock = std::scoped_lock{print_mutex}; std::cin >> yn) {
      if (yn != 'y') {
        fmt::println("main: finishing execution");
        for (auto &jt : thread_pool) {
          jt.request_stop();
        }
        break;
      } else [[likely]] {
        fmt::println("main: sleeping 200ms");
      }
    }
    std::this_thread::sleep_for(200ms);
  }

  return 0;
}
