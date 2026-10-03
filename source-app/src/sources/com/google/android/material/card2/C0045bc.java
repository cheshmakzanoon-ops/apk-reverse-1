package com.google.android.material.card2;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

class C0045bc<T> implements InterfaceC0065bw<T> {

    final C0035au f58ao;

    final Constructor f59ap;

    C0045bc(C0035au c0035au, Constructor constructor) {
        this.f58ao = c0035au;
        this.f59ap = constructor;
    }

    public static Constructor m2988(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return ((C0045bc) obj).f59ap;
        }
        return null;
    }

    public static Constructor m2989(Object obj) {
        if (abc.m1845() < 0) {
            return m2990(obj);
        }
        return null;
    }

    public static Constructor m2990(Object obj) {
        if (C0448yd.m9015() < 0) {
            return m2988((C0045bc) obj);
        }
        return null;
    }

    @Override
    public T mo265y() {
        try {
            return (T) C0461zs.m11478(m2989(this), null);
        } catch (IllegalAccessException e) {
            throw new AssertionError(e);
        } catch (InstantiationException e2) {
            throw new RuntimeException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0458ze.m10944()), m2989(this)), C0450yf.m9412())), e2);
        } catch (InvocationTargetException e3) {
            throw new RuntimeException(abc.m1925(C0460zg.m11407(abd.m2090(C0460zg.m11407(new StringBuilder(), C0458ze.m10944()), m2989(this)), C0450yf.m9412())), C0450yf.m9559(e3));
        }
    }
}
