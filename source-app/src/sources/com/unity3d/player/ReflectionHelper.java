package com.unity3d.player;

import cn.thinkingdata.android.j$;
import com.ishumei.smantifraud.l111l11l11Ill;
import java.lang.reflect.Array;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Member;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.Proxy;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;

final class ReflectionHelper {
    protected static boolean LOG;
    protected static final boolean LOGV = false;

    private static C1089a[] f265a = new C1089a[l111l11l11Ill.l111l11111lIl];

    private static long f266b = 0;

    private static class C1089a {

        public volatile Member f272a;

        private final Class f273b;

        private final String f274c;

        private final String f275d;

        private final int f276e;

        C1089a(Class cls, String str, String str2) {
            this.f273b = cls;
            this.f274c = str;
            this.f275d = str2;
            this.f276e = ((((cls.hashCode() + 527) * 31) + str.hashCode()) * 31) + str2.hashCode();
        }

        public final boolean equals(Object obj) {
            if (obj == this) {
                return true;
            }
            if (obj instanceof C1089a) {
                C1089a c1089a = (C1089a) obj;
                if (this.f276e == c1089a.f276e && this.f275d.equals(c1089a.f275d) && this.f274c.equals(c1089a.f274c) && this.f273b.equals(c1089a.f273b)) {
                    return true;
                }
            }
            return false;
        }

        public final int hashCode() {
            return this.f276e;
        }
    }

    protected interface InterfaceC1090b extends InvocationHandler {
        void mo490a(long j, boolean z);
    }

    ReflectionHelper() {
    }

    private static float m479a(Class cls, Class cls2) {
        if (cls.equals(cls2)) {
            return 1.0f;
        }
        if (cls.isPrimitive() || cls2.isPrimitive()) {
            return 0.0f;
        }
        try {
            if (cls.asSubclass(cls2) != null) {
                return 0.5f;
            }
        } catch (ClassCastException unused) {
        }
        try {
            return cls2.asSubclass(cls) != null ? 0.1f : 0.0f;
        } catch (ClassCastException unused2) {
            return 0.0f;
        }
    }

    private static float m480a(Class cls, Class[] clsArr, Class[] clsArr2) {
        if (clsArr2.length == 0) {
            return 0.1f;
        }
        int i = 0;
        if ((clsArr == null ? 0 : clsArr.length) + 1 != clsArr2.length) {
            return 0.0f;
        }
        float f = 1.0f;
        if (clsArr != null) {
            int length = clsArr.length;
            float fM479a = 1.0f;
            int i2 = 0;
            while (i < length) {
                fM479a *= m479a(clsArr[i], clsArr2[i2]);
                i++;
                i2++;
            }
            f = fM479a;
        }
        return f * m479a(cls, clsArr2[clsArr2.length - 1]);
    }

    private static Class m482a(String str, int[] iArr) {
        while (iArr[0] < str.length()) {
            int i = iArr[0];
            iArr[0] = i + 1;
            char cCharAt = str.charAt(i);
            if (cCharAt != '(' && cCharAt != ')') {
                if (cCharAt == 'L') {
                    int iIndexOf = str.indexOf(59, iArr[0]);
                    if (iIndexOf == -1) {
                        return null;
                    }
                    String strSubstring = str.substring(iArr[0], iIndexOf);
                    iArr[0] = iIndexOf + 1;
                    try {
                        return Class.forName(strSubstring.replace('/', '.'));
                    } catch (ClassNotFoundException unused) {
                        return null;
                    }
                }
                if (cCharAt == 'Z') {
                    return Boolean.TYPE;
                }
                if (cCharAt == 'I') {
                    return Integer.TYPE;
                }
                if (cCharAt == 'F') {
                    return Float.TYPE;
                }
                if (cCharAt == 'V') {
                    return Void.TYPE;
                }
                if (cCharAt == 'B') {
                    return Byte.TYPE;
                }
                if (cCharAt == 'C') {
                    return Character.TYPE;
                }
                if (cCharAt == 'S') {
                    return Short.TYPE;
                }
                if (cCharAt == 'J') {
                    return Long.TYPE;
                }
                if (cCharAt == 'D') {
                    return Double.TYPE;
                }
                if (cCharAt == '[') {
                    return Array.newInstance((Class<?>) m482a(str, iArr), 0).getClass();
                }
                C1134i.Log(5, "! parseType; " + cCharAt + " is not known!");
                return null;
            }
        }
        return null;
    }

    private static synchronized void m485a(C1089a c1089a, Member member) {
        c1089a.f272a = member;
        f265a[c1089a.hashCode() & (f265a.length - 1)] = c1089a;
    }

    private static synchronized boolean m486a(C1089a c1089a) {
        C1089a c1089a2 = f265a[c1089a.hashCode() & (f265a.length - 1)];
        if (!c1089a.equals(c1089a2)) {
            return false;
        }
        c1089a.f272a = c1089a2.f272a;
        return true;
    }

    private static Class[] m487a(String str) {
        Class clsM482a;
        int i = 0;
        int[] iArr = {0};
        ArrayList arrayList = new ArrayList();
        while (iArr[0] < str.length() && (clsM482a = m482a(str, iArr)) != null) {
            arrayList.add(clsM482a);
        }
        Class[] clsArr = new Class[arrayList.size()];
        Iterator it = arrayList.iterator();
        while (it.hasNext()) {
            clsArr[i] = (Class) it.next();
            i++;
        }
        return clsArr;
    }

    protected static void endUnityLaunch() {
        f266b++;
    }

    protected static Constructor getConstructorID(Class cls, String str) {
        Constructor<?> constructor;
        if (LOG) {
            C1134i.Log(3, "? getConstructorID(\"" + cls.getName() + "\", \"" + str + "\")");
        }
        C1089a c1089a = new C1089a(cls, "", str);
        if (m486a(c1089a)) {
            constructor = (Constructor) c1089a.f272a;
        } else {
            Class[] clsArrM487a = m487a(str);
            Constructor<?> constructor2 = null;
            float f = 0.0f;
            for (Constructor<?> constructor3 : cls.getConstructors()) {
                float fM480a = m480a(Void.TYPE, constructor3.getParameterTypes(), clsArrM487a);
                if (fM480a > f) {
                    if (fM480a == 1.0f) {
                        constructor2 = constructor3;
                        break;
                    }
                    constructor2 = constructor3;
                    f = fM480a;
                }
            }
            m485a(c1089a, constructor2);
            constructor = constructor2;
        }
        if (constructor == null) {
            throw new NoSuchMethodError("<init>" + str + " in class " + cls.getName());
        }
        if (LOG) {
            StringBuilder sb = new StringBuilder();
            for (Class<?> cls2 : constructor.getParameterTypes()) {
                if (sb.length() != 0) {
                    sb.append(", ");
                }
                sb.append(cls2.getSimpleName());
            }
            C1134i.Log(3, "! " + constructor.getName() + "(" + sb.toString() + ");");
        }
        return constructor;
    }

    protected static Field getFieldID(Class cls, String str, String str2, boolean z) {
        Field field;
        if (LOG) {
            StringBuilder sb = new StringBuilder("? getFieldID(\"");
            sb.append(cls.getName());
            sb.append("\", \"");
            sb.append(str);
            sb.append("\", \"");
            sb.append(str2);
            sb.append("\", ");
            sb.append(z ? "static)" : "non-static)");
            C1134i.Log(3, sb.toString());
        }
        Class superclass = cls;
        C1089a c1089a = new C1089a(superclass, str, str2);
        if (m486a(c1089a)) {
            field = (Field) c1089a.f272a;
        } else {
            Class[] clsArrM487a = m487a(str2);
            float f = 0.0f;
            Field field2 = null;
            while (superclass != null) {
                for (Field field3 : superclass.getDeclaredFields()) {
                    if (z == Modifier.isStatic(field3.getModifiers()) && field3.getName().compareTo(str) == 0) {
                        float fM480a = m480a(field3.getType(), (Class[]) null, clsArrM487a);
                        if (fM480a > f) {
                            if (fM480a == 1.0f) {
                                f = fM480a;
                                field2 = field3;
                                break;
                            }
                            f = fM480a;
                            field2 = field3;
                        } else {
                            continue;
                        }
                    }
                }
                if (f == 1.0f || superclass.isPrimitive() || superclass.isInterface() || superclass.equals(Object.class) || superclass.equals(Void.TYPE)) {
                    break;
                }
                superclass = superclass.getSuperclass();
            }
            m485a(c1089a, field2);
            field = field2;
        }
        if (field == null) {
            throw new NoSuchFieldError(String.format("no %s field with name='%s' signature='%s' in class L%s;", z ? "static" : "non-static", str, str2, superclass.getName()));
        }
        if (LOG) {
            C1134i.Log(3, "! " + field.getType().getSimpleName() + " " + field.getDeclaringClass().getSimpleName() + "." + field.getName() + ";");
        }
        return field;
    }

    protected static String getFieldSignature(Field field) {
        Class<?> type = field.getType();
        if (!type.isPrimitive()) {
            if (type.isArray()) {
                return type.getName().replace('.', '/');
            }
            return "L" + type.getName().replace('.', '/') + ";";
        }
        String name = type.getName();
        if ("boolean".equals(name)) {
            return "Z";
        }
        if ("byte".equals(name)) {
            return "B";
        }
        if ("char".equals(name)) {
            return "C";
        }
        if ("double".equals(name)) {
            return "D";
        }
        if ("float".equals(name)) {
            return "F";
        }
        if ("int".equals(name)) {
            return "I";
        }
        if ("long".equals(name)) {
            return "J";
        }
        return "short".equals(name) ? "S" : name;
    }

    protected static Method getMethodID(Class cls, String str, String str2, boolean z) {
        Method method;
        if (LOG) {
            StringBuilder sb = new StringBuilder("? getMethodID(\"");
            sb.append(cls.getName());
            sb.append("\", \"");
            sb.append(str);
            sb.append("\", \"");
            sb.append(str2);
            sb.append("\", ");
            sb.append(z ? "static)" : "non-static)");
            C1134i.Log(3, sb.toString());
        }
        Class superclass = cls;
        C1089a c1089a = new C1089a(superclass, str, str2);
        if (m486a(c1089a)) {
            method = (Method) c1089a.f272a;
        } else {
            Class[] clsArrM487a = m487a(str2);
            Method method2 = null;
            float f = 0.0f;
            while (superclass != null) {
                for (Method method3 : superclass.getDeclaredMethods()) {
                    if (z == Modifier.isStatic(method3.getModifiers()) && method3.getName().compareTo(str) == 0) {
                        float fM480a = m480a(method3.getReturnType(), method3.getParameterTypes(), clsArrM487a);
                        if (fM480a > f) {
                            f = fM480a;
                            if (fM480a == 1.0f) {
                                method2 = method3;
                                break;
                            }
                            method2 = method3;
                        } else {
                            continue;
                        }
                    }
                }
                if (f == 1.0f || superclass.isPrimitive() || superclass.isInterface() || superclass.equals(Object.class) || superclass.equals(Void.TYPE)) {
                    break;
                }
                superclass = superclass.getSuperclass();
            }
            m485a(c1089a, method2);
            method = method2;
        }
        if (method == null) {
            throw new NoSuchMethodError(String.format("no %s method with name='%s' signature='%s' in class L%s;", z ? "static" : "non-static", str, str2, superclass.getName()));
        }
        if (LOG) {
            StringBuilder sb2 = new StringBuilder();
            for (Class<?> cls2 : method.getParameterTypes()) {
                if (sb2.length() != 0) {
                    sb2.append(", ");
                }
                sb2.append(cls2.getSimpleName());
            }
            C1134i.Log(3, "! " + method.getReturnType().getSimpleName() + " " + method.getDeclaringClass().getSimpleName() + "." + method.getName() + "(" + sb2.toString() + ");");
        }
        return method;
    }

    public static native void nativeProxyFinalize(long j);

    public static native Object nativeProxyInvoke(long j, String str, Object[] objArr);

    public static native void nativeProxyLogJNIInvokeException(long j);

    protected static Object newProxyInstance(long j, Class cls) {
        return newProxyInstance(j, new Class[]{cls});
    }

    protected static Object newProxyInstance(final long j, final Class[] clsArr) {
        if (LOG) {
            C1134i.Log(3, String.format("ReflectionHelper.Proxy(%d,%s)", Long.valueOf(j), Arrays.asList(clsArr)));
        }
        return Proxy.newProxyInstance(ReflectionHelper.class.getClassLoader(), clsArr, new InterfaceC1090b() {

            private long f269c = ReflectionHelper.f266b;

            private long f270d;

            private boolean f271e;

            private Object m489a(Object obj, Method method, Object[] objArr) throws NoSuchMethodException {
                if (objArr == null) {
                    try {
                        objArr = new Object[0];
                    } catch (NoClassDefFoundError unused) {
                        C1134i.Log(6, String.format("Java interface default methods are only supported since Android Oreo", new Object[0]));
                        ReflectionHelper.nativeProxyLogJNIInvokeException(this.f270d);
                        return null;
                    }
                }
                Class<?> declaringClass = method.getDeclaringClass();
                Constructor declaredConstructor = j$.ExternalSyntheticApiModelOutline0.m().getDeclaredConstructor(Class.class, Integer.TYPE);
                declaredConstructor.setAccessible(true);
                return j$.ExternalSyntheticApiModelOutline0.m(j$.ExternalSyntheticApiModelOutline0.m(j$.ExternalSyntheticApiModelOutline0.m(j$.ExternalSyntheticApiModelOutline0.m(j$.ExternalSyntheticApiModelOutline0.m(declaredConstructor.newInstance(declaringClass, 2)), declaringClass), method, declaringClass), obj), objArr);
            }

            @Override
            public final void mo490a(long j2, boolean z) {
                this.f270d = j2;
                this.f271e = z;
            }

            protected final void finalize() throws Throwable {
                try {
                    if (ReflectionHelper.LOG) {
                        C1134i.Log(3, String.format("ReflectionHelper.Proxy.finalize(%d, %s)", Long.valueOf(j), Arrays.asList(clsArr)));
                    }
                    if (this.f269c == ReflectionHelper.f266b) {
                        ReflectionHelper.nativeProxyFinalize(j);
                    }
                } finally {
                    super.finalize();
                }
            }

            @Override
            public final Object invoke(Object obj, Method method, Object[] objArr) {
                long j2;
                if (ReflectionHelper.LOG) {
                    C1134i.Log(3, String.format("ReflectionHelper.Proxy.invoke(%d, %s, %s, %s)", Long.valueOf(j), Arrays.asList(clsArr), method.getName(), objArr == null ? "<null>" : Arrays.asList(objArr)));
                }
                if (this.f269c != ReflectionHelper.f266b) {
                    C1134i.Log(6, "Scripting proxy object was destroyed, because Unity player was unloaded.");
                    return null;
                }
                this.f270d = 0L;
                this.f271e = false;
                Object objNativeProxyInvoke = ReflectionHelper.nativeProxyInvoke(j, method.getName(), objArr);
                if (!this.f271e) {
                    j2 = this.f270d;
                    if (j2 != 0) {
                    }
                    return objNativeProxyInvoke;
                }
                if ((method.getModifiers() & 1024) == 0) {
                    return m489a(obj, method, objArr);
                }
                j2 = this.f270d;
                ReflectionHelper.nativeProxyLogJNIInvokeException(j2);
                return objNativeProxyInvoke;
            }
        });
    }

    protected static void setNativeExceptionOnProxy(Object obj, long j, boolean z) {
        ((InterfaceC1090b) Proxy.getInvocationHandler(obj)).mo490a(j, z);
    }
}
