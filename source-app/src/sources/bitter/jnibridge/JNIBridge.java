package bitter.jnibridge;

import cn.thinkingdata.android.j$$ExternalSyntheticApiModelOutline0;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class JNIBridge {

    private static class C0701a implements InvocationHandler {

        private Object f110a = new Object[0];

        private long f111b;

        private Constructor f112c;

        public C0701a(long j) {
            this.f111b = j;
            try {
                Constructor declaredConstructor = j$$ExternalSyntheticApiModelOutline0.m600m().getDeclaredConstructor(Class.class, Integer.TYPE);
                this.f112c = declaredConstructor;
                declaredConstructor.setAccessible(true);
            } catch (NoClassDefFoundError unused) {
                this.f112c = null;
            } catch (NoSuchMethodException unused2) {
                this.f112c = null;
            }
        }

        private Object m431a(Object obj, Method method, Object[] objArr) {
            if (objArr == null) {
                objArr = new Object[0];
            }
            Class<?> declaringClass = method.getDeclaringClass();
            return j$$ExternalSyntheticApiModelOutline0.m609m(this.f112c.newInstance(declaringClass, 2)).in(declaringClass).unreflectSpecial(method, declaringClass).bindTo(obj).invokeWithArguments(objArr);
        }

        public final void m432a() {
            synchronized (this.f110a) {
                this.f111b = 0L;
            }
        }

        public final void finalize() {
            synchronized (this.f110a) {
                long j = this.f111b;
                if (j == 0) {
                    return;
                }
                JNIBridge.delete(j);
            }
        }

        @Override
        public final Object invoke(Object obj, Method method, Object[] objArr) {
            synchronized (this.f110a) {
                long j = this.f111b;
                if (j == 0) {
                    return null;
                }
                try {
                    return JNIBridge.invoke(j, method.getDeclaringClass(), method, objArr);
                } catch (NoSuchMethodError e) {
                    if (this.f112c == null) {
                        System.err.println("JNIBridge error: Java interface default methods are only supported since Android Oreo");
                        throw e;
                    }
                    if ((method.getModifiers() & 1024) == 0) {
                        return m431a(obj, method, objArr);
                    }
                    throw e;
                }
            }
        }
    }

    static native void delete(long j);

    static void disableInterfaceProxy(Object obj) {
        if (obj != null) {
            ((C0701a) Proxy.getInvocationHandler(obj)).m432a();
        }
    }

    static native Object invoke(long j, Class cls, Method method, Object[] objArr);

    static Object newInterfaceProxy(long j, Class[] clsArr) {
        return Proxy.newProxyInstance(JNIBridge.class.getClassLoader(), clsArr, new C0701a(j));
    }
}
