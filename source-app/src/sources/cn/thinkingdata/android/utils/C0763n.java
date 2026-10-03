package cn.thinkingdata.android.utils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class C0763n implements InterfaceC0754e {

    private final TimeZone f271a;

    private final Date f272b;

    private boolean f273c = true;

    public C0763n(Date date, TimeZone timeZone) {
        this.f272b = date == null ? new Date() : date;
        this.f271a = timeZone;
    }

    @Override
    public Double mo698a() {
        if (!this.f273c || this.f271a == null) {
            return null;
        }
        return Double.valueOf(C0766q.m725a(this.f272b.getTime(), this.f271a));
    }

    @Override
    public String mo699b() {
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.CHINA);
            TimeZone timeZone = this.f271a;
            if (timeZone != null) {
                simpleDateFormat.setTimeZone(timeZone);
            }
            return simpleDateFormat.format(this.f272b);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void m722c() {
        this.f273c = false;
    }
}
