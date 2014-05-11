# include <stdio.h>

enum Kind { CAT, DOG };

struct Cat {
  float weight_kg;  // カプセル化: 構造体中のメンバには、
                    // オブジェクトの使用者はアクセスしない、という規約を守る
  enum Kind kind;
};

struct Dog {
  float weight_kg;  // カプセル化: 構造体中のメンバには、
                    // オブジェクトの使用者はアクセスしない、という規約を守る
  enum Kind kind;
};

struct Cat cat_initialize() {
  struct Cat instance;
  instance.kind = CAT;
  instance.weight_kg = 1.5;
  return instance;
}

struct Dog dog_initialize() {
  struct Dog instance;
  instance.kind = DOG;
  instance.weight_kg = 2.5;
  return instance;
}

void eat(void *animal) {
  enum Kind k = ((struct Cat *) animal)->kind;

  if (k == CAT)      ((struct Cat *) animal)->weight_kg += 1.0;
  else if (k == DOG) ((struct Dog *) animal)->weight_kg += 1.0;
}

void say_condition(void *animal) {
  enum Kind k = ((struct Cat *) animal)->kind;

  if (k == CAT) {
    if (((struct Cat *) animal)->weight_kg < 3.0)
      printf("Meow :)\n");
    else
      printf("Meow... Feeling too heavy...\n");
  }
  else if (k == DOG) {
    if (((struct Dog *) animal)->weight_kg < 5.0)
      printf("Bow :)\n");
    else
      printf("Bow... Feeling too heavy...\n");
  }
}

int main() {
  // ポリモフィズム: CatのインスタンスもDogのインスタンスも、
  // 共にeatしてsay_conditionすることができる
  struct Cat animal1 = cat_initialize();
  eat(&animal1); say_condition(&animal1);
  eat(&animal1); say_condition(&animal1);

  struct Dog animal2 = dog_initialize();
  eat(&animal2); say_condition(&animal2);
  eat(&animal2); say_condition(&animal2);
  eat(&animal2); say_condition(&animal2);

  return 0;
}
