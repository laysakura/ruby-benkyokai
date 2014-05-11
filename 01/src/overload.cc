#include <string>
#include <iostream>

using namespace std;

class C {
public:
  void f(int v) {
    cout << "Integer: " << v << endl;
  }

  void f(string v) {
    cout << "String: " << v << endl;
  }
};


int main() {
  C c = C();

  c.f(777);      // => Integer: 777
  c.f("hello");  // => String: hello

  return 0;
}
