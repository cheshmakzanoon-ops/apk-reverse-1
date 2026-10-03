package com.google.android.material.card2;

class RunnableC0254iw implements Runnable {

    final C0253iv f660kV;

    RunnableC0254iw(C0253iv c0253iv) {
        this.f660kV = c0253iv;
    }

    public static long m4997(Object obj, long j) {
        if (abc.m1845() <= 0) {
            return ((C0253iv) obj).m650b(j);
        }
        return 0L;
    }

    public static C0253iv m4998(Object obj) {
        if (C0452yh.m9798() > 0) {
            return m5001(obj);
        }
        return null;
    }

    public static C0253iv m4999(Object obj) {
        if (C0447yc.m8635() > 0) {
            return ((RunnableC0254iw) obj).f660kV;
        }
        return null;
    }

    public static long m5000(Object obj, long j) {
        if (C0447yc.m8635() > 0) {
            return m5002(obj, j);
        }
        return 0L;
    }

    public static C0253iv m5001(Object obj) {
        if (C0448yd.m9074() < 0) {
            return m4999((RunnableC0254iw) obj);
        }
        return null;
    }

    public static long m5002(Object obj, long j) {
        if (C0448yd.m9015() < 0) {
            return m4997((C0253iv) obj, j);
        }
        return 0L;
    }

    @Override
    public void run() {
        while (true) {
            long jM5000 = m5000(m4998(this), abc.m1830());
            if (jM5000 == -1) {
                return;
            }
            if (jM5000 > 0) {
                long j = jM5000 / 1000000;
                synchronized (m4998(this)) {
                    try {
                        C0445ya.m8265(m4998(this), j, (int) (jM5000 - (j * 1000000)));
                    } catch (InterruptedException e) {
                    }
                }
            }
        }
    }
}
