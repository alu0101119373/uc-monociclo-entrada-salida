#include <iostream>

int main (void) {
    int sum = 0;

    for (int i = 0; i != 4; i++) {
        sum += (10 - i) + 1;
    }
    std::cout << sum << '\n';
}