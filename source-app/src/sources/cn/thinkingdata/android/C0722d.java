package cn.thinkingdata.android;

import android.os.SystemClock;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

class C0722d {

    private final TimeUnit f179a;

    private long f180b = SystemClock.elapsedRealtime();

    private long f181c = 0;

    private long f182d;

    C0722d(TimeUnit timeUnit) {
        this.f179a = timeUnit;
    }

    String m499a() {
        return m500a(this.f182d);
    }

    String m500a(long j) {
        float f;
        float f2;
        try {
            if (j < 0) {
                return String.valueOf(0);
            }
            if (j > 86400000) {
                return m500a(86400000L);
            }
            if (this.f179a != TimeUnit.MILLISECONDS) {
                if (this.f179a == TimeUnit.SECONDS) {
                    f2 = j / 1000.0f;
                } else {
                    if (this.f179a == TimeUnit.MINUTES) {
                        f = j / 1000.0f;
                    } else if (this.f179a == TimeUnit.HOURS) {
                        f = (j / 1000.0f) / 60.0f;
                    }
                    f2 = f / 60.0f;
                }
                return f2 < 0.0f ? String.valueOf(0) : String.format(Locale.CHINA, "%.3f", Float.valueOf(f2));
            }
            f2 = j;
            if (f2 < 0.0f) {
            }
        } catch (Exception e) {
            e.printStackTrace();
            return String.valueOf(0);
        }
    }

    String m501b() {
        return m500a((SystemClock.elapsedRealtime() - this.f180b) + this.f181c);
    }

    void m502b(long j) {
        this.f182d = j;
    }

    long m503c() {
        return this.f182d;
    }

    void m504c(long j) {
        this.f181c = j;
    }

    long m505d() {
        return this.f181c;
    }

    void m506d(long j) {
        this.f180b = j;
    }

    long m507e() {
        return this.f180b;
    }
}
