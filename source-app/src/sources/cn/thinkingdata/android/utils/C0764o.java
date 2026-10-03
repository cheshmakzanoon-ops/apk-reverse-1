package cn.thinkingdata.android.utils;

import android.os.SystemClock;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class C0764o implements InterfaceC0754e {

    private final long f274a = SystemClock.elapsedRealtime();

    private final TimeZone f275b;

    private final InterfaceC0753d f276c;

    private Date f277d;

    public C0764o(InterfaceC0753d interfaceC0753d, TimeZone timeZone) {
        this.f276c = interfaceC0753d;
        this.f275b = timeZone;
    }

    private synchronized Date m723c() {
        if (this.f277d == null) {
            this.f277d = this.f276c.mo697a(this.f274a);
        }
        return this.f277d;
    }

    @Override
    public Double mo698a() {
        return Double.valueOf(C0766q.m725a(m723c().getTime(), this.f275b));
    }

    @Override
    public String mo699b() {
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.CHINA);
            simpleDateFormat.setTimeZone(this.f275b);
            return simpleDateFormat.format(m723c());
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
