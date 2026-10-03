package cn.thinkingdata.android.utils;

import android.os.SystemClock;
import java.util.Date;

public final class C0759j implements InterfaceC0753d {

    private final long f249a;

    private final long f250b = SystemClock.elapsedRealtime();

    public C0759j(long j) {
        this.f249a = j;
    }

    @Override
    public Date mo697a(long j) {
        return new Date((j - this.f250b) + this.f249a);
    }
}
