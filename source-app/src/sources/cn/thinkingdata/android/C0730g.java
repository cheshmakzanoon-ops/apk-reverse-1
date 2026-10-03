package cn.thinkingdata.android;

public class C0730g {
    public static boolean m526a(Object obj, String str) {
        for (Class<?> superclass = obj.getClass(); superclass.getCanonicalName() != null; superclass = superclass.getSuperclass()) {
            if (superclass.getCanonicalName().equals(str)) {
                return true;
            }
            if (superclass == Object.class) {
                return false;
            }
        }
        return false;
    }
}
