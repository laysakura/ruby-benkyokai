import java.lang.reflect.Method;

class Foo {
    public int succ(int num) {
        return num + 1;
    }
}

class Main {
    public static void main(String[] args) {
        try {
            Class<?> cls = Foo.class;
            Method[] methods = cls.getMethods();

            Foo foo = new Foo();
            for (Method m : methods) {
                System.out.println(m.getName());

                if (m.getName().equals("succ")) {
                    int res = (Integer)m.invoke(foo, Integer.valueOf(10));
                    System.out.println("result: " + res);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
