import java.lang.reflect.Method;

class Foo {
    public int succ(int num) {
        return num + 1;
    }
}

class Main {
    public static void main(String[] args) {
        Class<?> cls = Foo.class;
        Method[] methods = cls.getMethods();

        for (Method m : methods) {
            System.out.println(m);
        }
    }
}
