// sample.cpp
#include <iostream>
#include <vector>

struct User {
    int id;
    std::string name;
};

int add(int a, int b) {
    return a + b;
}

int main() {
    std::vector<User> users{{1, "Ada"}, {2, "Linus"}};
    std::cout << users[0].name << "\n";
    std::cout << add(2, 3) << "\n";
    return 0;
}
