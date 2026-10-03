package com.google.android.material.card2;

public abstract class AbstractRunnableC0297kl implements Runnable {

    protected final String f885nT;

    public AbstractRunnableC0297kl(String str, Object... objArr) {
        this.f885nT = gggy.m4389(str, objArr);
    }

    public static void m5747(Object obj) {
        if (C0445ya.m8222() > 0) {
            ((AbstractRunnableC0297kl) obj).mo844dd();
        }
    }

    public static String m5748(Object obj) {
        if (C0446yb.m8415() <= 0) {
            return ((AbstractRunnableC0297kl) obj).f885nT;
        }
        return null;
    }

    public static String m5749(Object obj) {
        if (gggy.m4365() >= 0) {
            return m5748((AbstractRunnableC0297kl) obj);
        }
        return null;
    }

    public static void m927(Object obj) {
        if (abe.m2321() < 0) {
            m5747((AbstractRunnableC0297kl) obj);
        }
    }

    protected abstract void mo844dd();

    @Override
    public final void run() {
        String strM2878 = adds.m2878(C0457zc.m10701());
        C0447yc.m8842(C0457zc.m10701(), C0450yf.m9526(this));
        try {
            adds.m2834(this);
        } finally {
            C0447yc.m8842(C0457zc.m10701(), strM2878);
        }
    }
}
