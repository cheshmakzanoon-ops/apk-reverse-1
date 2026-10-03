package com.google.android.material.card2;

import java.sql.Time;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public final class C0100dd extends AbstractC0022ah<Time> {

    public static final InterfaceC0024aj f171cn = new C0101de();

    private final DateFormat f172co = new SimpleDateFormat(C0457zc.m10664());

    public static DateFormat m3439(Object obj) {
        if (C0459zf.m11062() >= 0) {
            return ((C0100dd) obj).f172co;
        }
        return null;
    }

    public static DateFormat m3440(Object obj) {
        if (C0453yj.m10032() >= 0) {
            return m3439((C0100dd) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, Time time) {
        C0452yh.m9636(this, c0155fe, time);
    }

    public void a2(C0155fe c0155fe, Time time) {
        synchronized (this) {
            C0457zc.m10576(c0155fe, time == null ? null : abd.m2048(C0455za.m10249(this), time));
        }
    }

    @Override
    public Time mo227b(C0152fb c0152fb) {
        return C0450yf.m9343(this, c0152fb);
    }

    public Time m384m(C0152fb c0152fb) {
        Time time;
        synchronized (this) {
            if (abe.m2401(c0152fb) == C0452yh.m9757()) {
                C0459zf.m11132(c0152fb);
                time = null;
            } else {
                try {
                    time = new Time(C0461zs.m11479(C0447yc.m8780(C0455za.m10249(this), C0460zg.m11347(c0152fb))));
                } catch (ParseException e) {
                    throw new C0018ad(e);
                }
            }
        }
        return time;
    }
}
