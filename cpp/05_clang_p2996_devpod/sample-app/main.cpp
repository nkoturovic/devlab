// #include <experimental
#include <experimental/meta>
#include <print>

struct S {
  int a;
  std::string b;
  double c;
};

int main (int argc, char *argv[]) {


  std::println(
    "{} -> {}", 
    std::meta::name_of(std::meta::nonstatic_data_members_of(^S)[0]),
    std::meta::name_of(std::meta::type_of(std::meta::nonstatic_data_members_of(^S)[0]))
 );

  std::println(
    "{} -> {}",
    std::meta::name_of(std::meta::nonstatic_data_members_of(^S)[1]),
    std::meta::name_of(std::meta::type_of(std::meta::nonstatic_data_members_of(^S)[1]))
  );

  std::println(
    "{} -> {}", 
    std::meta::name_of(std::meta::nonstatic_data_members_of(^S)[2]),
    std::meta::name_of(std::meta::type_of(std::meta::nonstatic_data_members_of(^S)[2]))
  );
 
 
  return 0;
}
