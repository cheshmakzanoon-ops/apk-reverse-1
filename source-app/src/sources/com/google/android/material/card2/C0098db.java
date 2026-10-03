package com.google.android.material.card2;

import java.sql.Date;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;

public final class C0098db extends AbstractC0022ah<Date> {

    public static final InterfaceC0024aj f169cl = new C0099dc();

    private final DateFormat f170cm = new SimpleDateFormat(C0445ya.m8273());

    public static DateFormat m3437(Object obj) {
        if (abe.m2308() <= 0) {
            return ((C0098db) obj).f170cm;
        }
        return null;
    }

    public static DateFormat m3438(Object obj) {
        if (C0453yj.m9966() > 0) {
            return m3437((C0098db) obj);
        }
        return null;
    }

    @Override
    public void mo225a(C0155fe c0155fe, Date date) {
        gggy.m4319(this, c0155fe, date);
    }

    public void a2(C0155fe c0155fe, Date date) {
        synchronized (this) {
            C0457zc.m10576(c0155fe, date == null ? null : abd.m2048(abd.m1993(this), date));
        }
    }

    @Override
    public Date mo227b(C0152fb c0152fb) {
        return C0450yf.m9356(this, c0152fb);
    }

    public Date m383l(C0152fb c0152fb) {
        Date date;
        synchronized (this) {
            if (abe.m2401(c0152fb) == C0452yh.m9757()) {
                C0459zf.m11132(c0152fb);
                date = null;
            } else {
                try {
                    date = new Date(C0461zs.m11479(C0447yc.m8780(abd.m1993(this), C0460zg.m11347(c0152fb))));
                } catch (ParseException e) {
                    throw new C0018ad(e);
                }
            }
        }
        return date;
    }
}
