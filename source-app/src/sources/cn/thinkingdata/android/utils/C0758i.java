package cn.thinkingdata.android.utils;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class C0758i {

    static String f248a = "ThinkingAnalytics.TAReflectUtils";

    public static Object m707a(Object obj, String str, Object[] objArr, Class<?>... clsArr) {
        Method methodM709a = m709a(obj, str, clsArr);
        if (methodM709a != null) {
            try {
                return methodM709a.invoke(obj, objArr);
            } catch (Exception e) {
                TDLog.m680e(f248a, e.getMessage());
                return null;
            }
        }
        TDLog.m682i(f248a, "Could not find method [" + str + "] on target [" + obj + "]");
        return null;
    }

    public static Object m708a(String str) {
        Exception e;
        Class<?> cls;
        try {
            cls = Class.forName(str);
            try {
                return cls.getDeclaredConstructor(null).newInstance(null);
            } catch (Exception e2) {
                e = e2;
                e.printStackTrace();
                return cls;
            }
        } catch (Exception e3) {
            e = e3;
            cls = null;
        }
    }

    public static Method m709a(Object obj, String str, Class<?>... clsArr) {
        if (obj == null) {
            TDLog.m682i(f248a, "obj is null!");
            return null;
        }
        for (Class<?> superclass = obj.getClass(); superclass != Object.class; superclass = superclass.getSuperclass()) {
            try {
                Method declaredMethod = superclass.getDeclaredMethod(str, clsArr);
                declaredMethod.setAccessible(true);
                return declaredMethod;
            } catch (NoSuchMethodException unused) {
            }
        }
        return null;
    }

    public static void m710a(String str, String str2, Object[] objArr, Class<?>... clsArr) throws IllegalAccessException, InvocationTargetException {
        Class.forName(str).getDeclaredMethod(str2, clsArr).invoke(null, objArr);
    }
}
