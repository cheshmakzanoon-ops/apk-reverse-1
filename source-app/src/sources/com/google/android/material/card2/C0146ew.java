package com.google.android.material.card2;

import java.text.ParseException;
import java.text.ParsePosition;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.TimeZone;

public class C0146ew {

    private static final TimeZone f253dQ = m3743(C0455za.m10105());

    private static int m423a(String str, int i) {
        int i2 = i;
        while (i2 < gggy.m4397(str)) {
            char cM8419 = C0446yb.m8419(str, i2);
            if (cM8419 < '0' || cM8419 > '9') {
                return i2;
            }
            i2++;
        }
        return gggy.m4397(str);
    }

    private static int m424a(String str, int i, int i2) {
        int i3;
        if (i < 0 || i2 > gggy.m4397(str) || i > i2) {
            throw new NumberFormatException(str);
        }
        int i4 = 0;
        if (i < i2) {
            i3 = i + 1;
            int iM1766 = abc.m1766(C0446yb.m8419(str, i), 10);
            if (iM1766 < 0) {
                throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0453yj.m9928()), C0447yc.m8745(str, i, i2))));
            }
            i4 = -iM1766;
        } else {
            i3 = i;
        }
        while (i3 < i2) {
            int iM1767 = abc.m1766(C0446yb.m8419(str, i3), 10);
            if (iM1767 < 0) {
                throw new NumberFormatException(abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0453yj.m9928()), C0447yc.m8745(str, i, i2))));
            }
            i4 = (i4 * 10) - iM1767;
            i3++;
        }
        return -i4;
    }

    public static Date m425a(String str, ParsePosition parsePosition) throws ParseException {
        Object obj;
        String strM1925;
        String strM9396;
        int iM2146;
        int i;
        int iM4397;
        TimeZone timeZoneM10502;
        char cM8419;
        try {
            int iM3739 = m3739(parsePosition);
            int i2 = iM3739 + 4;
            int iM2147 = abd.m2146(str, iM3739, i2);
            if (abd.m2015(str, i2, '-')) {
                i2++;
            }
            int i3 = i2 + 2;
            int iM2148 = abd.m2146(str, i2, i3);
            int i4 = abd.m2015(str, i3, '-') ? i3 + 1 : i3;
            int iM10662 = i4 + 2;
            int iM2149 = abd.m2146(str, i4, iM10662);
            int iM21410 = 0;
            int i5 = 0;
            boolean zM2015 = abd.m2015(str, iM10662, 'T');
            if (!zM2015 && gggy.m4397(str) <= iM10662) {
                GregorianCalendar gregorianCalendar = new GregorianCalendar(iM2147, iM2148 - 1, iM2149);
                C0450yf.m9450(parsePosition, iM10662);
                return C0460zg.m11313(gregorianCalendar);
            }
            if (zM2015) {
                int i6 = iM10662 + 1;
                int i7 = i6 + 2;
                iM21410 = abd.m2146(str, i6, i7);
                if (abd.m2015(str, i7, ':')) {
                    i7++;
                }
                int i8 = i7 + 2;
                iM2146 = abd.m2146(str, i7, i8);
                int i9 = abd.m2015(str, i8, ':') ? i8 + 1 : i8;
                if (gggy.m4397(str) <= i9 || (cM8419 = C0446yb.m8419(str, i9)) == 'Z' || cM8419 == '+' || cM8419 == '-') {
                    i = 0;
                    iM10662 = i9;
                } else {
                    int i10 = i9 + 2;
                    int iM21411 = abd.m2146(str, i9, i10);
                    if (iM21411 > 59 && iM21411 < 63) {
                        iM21411 = 59;
                    }
                    if (abd.m2015(str, i10, '.')) {
                        int i11 = i10 + 1;
                        iM10662 = C0457zc.m10662(str, i11 + 1);
                        int iM10520 = C0456zb.m10520(iM10662, i11 + 3);
                        int iM21412 = abd.m2146(str, i11, iM10520);
                        switch (iM10520 - i11) {
                            case 1:
                                iM21412 *= 100;
                                break;
                            case 2:
                                iM21412 *= 10;
                                break;
                        }
                        i = iM21411;
                        i5 = iM21412;
                    } else {
                        i = iM21411;
                        iM10662 = i10;
                    }
                }
            } else {
                iM2146 = 0;
                i = 0;
            }
            if (gggy.m4397(str) <= iM10662) {
                throw new IllegalArgumentException(abf.m2504());
            }
            char cM84110 = C0446yb.m8419(str, iM10662);
            if (cM84110 == 'Z') {
                timeZoneM10502 = C0456zb.m10502();
                iM4397 = iM10662 + 1;
            } else {
                if (cM84110 != '+' && cM84110 != '-') {
                    throw new IndexOutOfBoundsException(abc.m1925(C0460zg.m11407(abe.m2346(C0460zg.m11407(new StringBuilder(), C0446yb.m8413()), cM84110), C0459zf.m11010())));
                }
                String strM1972 = abc.m1972(str, iM10662);
                if (gggy.m4397(strM1972) < 5) {
                    strM1972 = abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), strM1972), abf.m2445()));
                }
                iM4397 = gggy.m4397(strM1972) + iM10662;
                if (C0452yh.m9583(C0448yd.m9014(), strM1972) || C0452yh.m9583(C0450yf.m9389(), strM1972)) {
                    timeZoneM10502 = C0456zb.m10502();
                } else {
                    String strM1926 = abc.m1925(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0461zs.m11649()), strM1972));
                    timeZoneM10502 = m3743(strM1926);
                    String strM9725 = C0452yh.m9725(timeZoneM10502);
                    if (!C0452yh.m9583(strM9725, strM1926) && !C0452yh.m9583(C0452yh.m9597(strM9725, C0449ye.m9248(), gggy.m4277()), strM1926)) {
                        throw new IndexOutOfBoundsException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), abd.m2118()), strM1926), C0461zs.m11446()), C0452yh.m9725(timeZoneM10502))));
                    }
                }
            }
            GregorianCalendar gregorianCalendar2 = new GregorianCalendar(timeZoneM10502);
            C0460zg.m11316(gregorianCalendar2, false);
            m3745(gregorianCalendar2, 1, iM2147);
            m3745(gregorianCalendar2, 2, iM2148 - 1);
            m3745(gregorianCalendar2, 5, iM2149);
            m3745(gregorianCalendar2, 11, iM21410);
            m3745(gregorianCalendar2, 12, iM2146);
            m3745(gregorianCalendar2, 13, i);
            m3745(gregorianCalendar2, 14, i5);
            C0450yf.m9450(parsePosition, iM4397);
            return C0460zg.m11313(gregorianCalendar2);
        } catch (IndexOutOfBoundsException e) {
            obj = e;
            if (str == null) {
                strM1925 = null;
            } else {
                strM1925 = abc.m1925(abe.m2346(C0460zg.m11407(abe.m2346(new StringBuilder(), '\"'), str), '\"'));
            }
            strM9396 = C0450yf.m9396(obj);
            if (strM9396 != null || C0460zg.m11421(strM9396)) {
                strM9396 = abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0445ya.m8400()), C0456zb.m10455(gggy.m4399(obj))), C0457zc.m10722()));
            }
            ParseException parseException = new ParseException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0449ye.m9180()), strM1925), gggy.m4305()), strM9396)), m3739(parsePosition));
            C0450yf.m9362(parseException, obj);
            throw parseException;
        } catch (NumberFormatException e2) {
            obj = e2;
            if (str == null) {
                strM1925 = null;
            } else {
                strM1925 = abc.m1925(abe.m2346(C0460zg.m11407(abe.m2346(new StringBuilder(), '\"'), str), '\"'));
            }
            strM9396 = C0450yf.m9396(obj);
            if (strM9396 != null) {
                strM9396 = abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0445ya.m8400()), C0456zb.m10455(gggy.m4399(obj))), C0457zc.m10722()));
            } else {
                strM9396 = abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0445ya.m8400()), C0456zb.m10455(gggy.m4399(obj))), C0457zc.m10722()));
            }
            ParseException parseException2 = new ParseException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0449ye.m9180()), strM1925), gggy.m4305()), strM9396)), m3739(parsePosition));
            C0450yf.m9362(parseException2, obj);
            throw parseException2;
        } catch (IllegalArgumentException e3) {
            obj = e3;
            if (str == null) {
                strM1925 = null;
            } else {
                strM1925 = abc.m1925(abe.m2346(C0460zg.m11407(abe.m2346(new StringBuilder(), '\"'), str), '\"'));
            }
            strM9396 = C0450yf.m9396(obj);
            if (strM9396 != null) {
                strM9396 = abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0445ya.m8400()), C0456zb.m10455(gggy.m4399(obj))), C0457zc.m10722()));
            } else {
                strM9396 = abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0445ya.m8400()), C0456zb.m10455(gggy.m4399(obj))), C0457zc.m10722()));
            }
            ParseException parseException3 = new ParseException(abc.m1925(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(C0460zg.m11407(new StringBuilder(), C0449ye.m9180()), strM1925), gggy.m4305()), strM9396)), m3739(parsePosition));
            C0450yf.m9362(parseException3, obj);
            throw parseException3;
        }
    }

    private static boolean m426a(String str, int i, char c) {
        return i < gggy.m4397(str) && C0446yb.m8419(str, i) == c;
    }

    public static int m3739(Object obj) {
        if (C0456zb.m10326() <= 0) {
            return C0598.m11898(obj);
        }
        return 0;
    }

    public static int m3740(Object obj, int i) {
        if (C0446yb.m8415() <= 0) {
            return m423a((String) obj, i);
        }
        return 0;
    }

    public static boolean m3741(Object obj, int i, char c) {
        if (C0445ya.m8222() > 0) {
            return m426a((String) obj, i, c);
        }
        return false;
    }

    public static int m3742(Object obj, int i, int i2) {
        if (C0446yb.m8415() < 0) {
            return m424a((String) obj, i, i2);
        }
        return 0;
    }

    public static TimeZone m3743(Object obj) {
        if (C0456zb.m10326() < 0) {
            return C0598.m11796(obj);
        }
        return null;
    }

    public static TimeZone m3744() {
        if (C0461zs.m11510() < 0) {
            return f253dQ;
        }
        return null;
    }

    public static void m3745(Object obj, int i, int i2) {
        if (C0446yb.m8415() < 0) {
            C0598.m11908(obj, i, i2);
        }
    }

    public static int m3746(Object obj, int i) {
        if (C0453yj.m9996() <= 0) {
            return m3740((String) obj, i);
        }
        return 0;
    }

    public static TimeZone m3747() {
        if (abf.m2500() > 0) {
            return m3744();
        }
        return null;
    }

    public static int m3748(Object obj, int i, int i2) {
        if (C0448yd.m9074() <= 0) {
            return m3742((String) obj, i, i2);
        }
        return 0;
    }

    public static boolean m3749(Object obj, int i, char c) {
        if (C0453yj.m9966() > 0) {
            return m3741((String) obj, i, c);
        }
        return false;
    }
}
