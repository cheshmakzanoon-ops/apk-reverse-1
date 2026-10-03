package com.google.android.material.card2;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public final class C0316ld extends RuntimeException {

    private static final Method f973pA;

    private IOException f974pB;

    static {
        Method methodM6012;
        try {
            methodM6012 = m6012(Throwable.class, C0457zc.m10681(), new Class[]{Throwable.class});
        } catch (Exception e) {
            methodM6012 = null;
        }
        f973pA = methodM6012;
    }

    public C0316ld(IOException iOException) {
        super(iOException);
        this.f974pB = iOException;
    }

    private void m1016a(IOException iOException, IOException iOException2) {
        if (C0446yb.m8497() != null) {
            try {
                C0446yb.m8446(C0446yb.m8497(), iOException, new Object[]{iOException2});
            } catch (IllegalAccessException e) {
            } catch (InvocationTargetException e2) {
            }
        }
    }

    public static IOException m6009(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return ((C0316ld) obj).f974pB;
        }
        return null;
    }

    public static Method m6010() {
        if (C0459zf.m11062() > 0) {
            return f973pA;
        }
        return null;
    }

    public static void m6011(Object obj, Object obj2, Object obj3) {
        if (C0457zc.m10735() <= 0) {
            ((C0316ld) obj).m1016a((IOException) obj2, (IOException) obj3);
        }
    }

    public static Method m6012(Object obj, Object obj2, Object obj3) {
        if (C0460zg.m11287() >= 0) {
            return C0598.m11845(obj, obj2, obj3);
        }
        return null;
    }

    public static void m6013(Object obj, Object obj2, Object obj3) {
        if (C0453yj.m9945() <= 0) {
            m6011((C0316ld) obj, (IOException) obj2, (IOException) obj3);
        }
    }

    public static Method m6014() {
        if (C0458ze.m10926() <= 0) {
            return m6010();
        }
        return null;
    }

    public static IOException m6015(Object obj) {
        if (C0453yj.m9966() >= 0) {
            return m6009((C0316ld) obj);
        }
        return null;
    }

    public void m1017b(IOException iOException) {
        C0457zc.m10714(this, iOException, abf.m2521(this));
        this.f974pB = iOException;
    }

    public IOException m1018dQ() {
        return abf.m2521(this);
    }
}
