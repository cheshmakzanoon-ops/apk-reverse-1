package com.ishumei.smantifraud;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class l1l11lI1lIl {
    public static Object l1111l111111Il(Object obj, String str) throws IllegalAccessException, NoSuchFieldException {
        return l1111l111111Il(obj, l1111l111111Il(obj.getClass(), str));
    }

    public static Object l1111l111111Il(Object obj, String str, Class[] clsArr, Object[] objArr) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        return l1111l111111Il(obj, l1111l111111Il(obj.getClass(), str, clsArr), objArr);
    }

    public static Object l1111l111111Il(Object obj, Field field) throws IllegalAccessException {
        field.setAccessible(true);
        return field.get(obj);
    }

    public static Object l1111l111111Il(Object obj, Method method, Object... objArr) throws IllegalAccessException, InvocationTargetException {
        method.setAccessible(true);
        return method.invoke(obj, objArr);
    }

    public static Object l1111l111111Il(String str, String str2) throws IllegalAccessException, NoSuchFieldException, ClassNotFoundException {
        return l1111l111111Il((Object) null, l1111l111111Il(Class.forName(str), str2));
    }

    public static Object l1111l111111Il(String str, String str2, Class[] clsArr, Object[] objArr) throws IllegalAccessException, NoSuchMethodException, ClassNotFoundException, InvocationTargetException {
        return l1111l111111Il((Object) null, l1111l111111Il(Class.forName(str), str2, clsArr), objArr);
    }

    public static Field l1111l111111Il(Class<?> cls, String str) throws NoSuchFieldException {
        try {
            try {
                return cls.getField(str);
            } catch (NoSuchFieldException e) {
                if (cls.getSuperclass() != null) {
                    return l1111l111111Il((Class<?>) cls.getSuperclass(), str);
                }
                throw e;
            }
        } catch (NoSuchFieldException unused) {
            return cls.getDeclaredField(str);
        }
    }

    public static Method l1111l111111Il(Class<?> cls, String str, Class[] clsArr) throws NoSuchMethodException {
        try {
            try {
                return cls.getMethod(str, clsArr);
            } catch (NoSuchMethodException e) {
                if (cls.getSuperclass() != null) {
                    return l1111l111111Il(cls.getSuperclass(), str, clsArr);
                }
                throw e;
            }
        } catch (NoSuchMethodException unused) {
            return cls.getDeclaredMethod(str, clsArr);
        }
    }

    public static Field[] l1111l111111Il(Class cls) {
        return cls.getDeclaredFields();
    }

    public static Field[] l1111l111111Il(Object obj) {
        return obj.getClass().getDeclaredFields();
    }

    public static Object l111l11111lIl(Object obj, String str) throws IllegalAccessException, NoSuchMethodException, InvocationTargetException {
        return l1111l111111Il(obj, l1111l111111Il(obj.getClass(), str, (Class[]) null), new Object[0]);
    }

    public static Object l111l11111lIl(String str, String str2) throws IllegalAccessException, NoSuchMethodException, ClassNotFoundException, InvocationTargetException {
        return l1111l111111Il((Object) null, l1111l111111Il(Class.forName(str), str2, (Class[]) null), new Object[0]);
    }

    public static Field[] l1111l111111Il(String str) throws ClassNotFoundException {
        return Class.forName(str).getDeclaredFields();
    }
}
