package cn.thinkingdata.android.utils;

import android.os.SystemClock;
import java.util.Date;

public class C0760k implements InterfaceC0753d {

    private long f251a;

    private long f252b;

    private final String[] f253c;

    private final Thread f254d;

    class a implements Runnable {

        final C0762m f255a = new C0762m();

        a() {
        }

        @Override
        public void run() {
            for (String str : C0760k.this.f253c) {
                if (this.f255a.m721a(str, 3000)) {
                    TDLog.m682i("ThinkingAnalytics.NTP", "NTP offset from " + str + " is: " + this.f255a.m720a());
                    C0760k.this.f251a = System.currentTimeMillis() + this.f255a.m720a();
                    C0760k.this.f252b = SystemClock.elapsedRealtime();
                    return;
                }
            }
        }
    }

    public C0760k(String... strArr) {
        Thread thread = new Thread(new a());
        this.f254d = thread;
        this.f253c = strArr;
        thread.start();
    }

    @Override
    public Date mo697a(long j) {
        try {
            this.f254d.join(3000L);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return this.f252b == 0 ? new Date((System.currentTimeMillis() - SystemClock.elapsedRealtime()) + j) : new Date((j - this.f252b) + this.f251a);
    }
}
