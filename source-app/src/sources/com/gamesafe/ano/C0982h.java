package com.gamesafe.ano;

import android.app.Activity;
import android.content.Context;

public class C0982h {

    private static volatile C0982h f554d;

    public InterfaceC0981g.a f555a = new C0983i(this);

    private InterfaceC0981g f556b;

    private String f557c;

    public static C0982h m876a() {
        if (f554d == null) {
            synchronized (C0982h.class) {
                if (f554d == null) {
                    f554d = new C0982h();
                }
            }
        }
        return f554d;
    }

    private void m879a(Context context, String str) {
    }

    private void m880a(Context context, String str, String str2, String str3, InterfaceC0981g.a aVar) {
        C0985k c0985k = new C0985k(context, str, str2, str3, aVar);
        this.f556b = c0985k;
        c0985k.mo871a();
    }

    private void m881a(Context context, String str, String str2, String str3, String str4, String str5, String str6) {
    }

    private void m882a(Context context, String str, String str2, String str3, String str4, String str5, String str6, String str7) {
    }

    private void m883a(InterfaceC0981g interfaceC0981g, String str) {
        if (interfaceC0981g != null && this.f556b == interfaceC0981g) {
            if (str == null || str.equals(this.f557c)) {
                this.f556b = null;
                interfaceC0981g.mo873c();
            }
        }
    }

    private void m885b(Context context, String str, String str2, String str3, InterfaceC0981g.a aVar) {
        String[] strArrSplit = str3.split(";");
        if (strArrSplit == null || strArrSplit.length < 2) {
            C0976b.m847a(C0975a.m846a("*#07#:OnnNyfHznnvbzWjs.kvmnzViyNcjr xhy zmm"));
            return;
        }
        String str4 = strArrSplit[0];
        int i = Integer.parseInt(strArrSplit[1]);
        int i2 = Integer.parseInt(strArrSplit[2]);
        if (i2 > i) {
            return;
        }
        C0978d c0978d = new C0978d(context, str, str2, str4, i, i2, aVar);
        this.f556b = c0978d;
        c0978d.mo871a();
    }

    private void m886b(Context context, String str, String str2, String str3, String str4, String str5, String str6, String str7) {
    }

    private void m887b(String str) {
        String strSubstring = str.substring(12);
        if (strSubstring.equals("8097") || strSubstring.equals("8098") || strSubstring.equals("8099")) {
            return;
        }
        m883a(this.f556b, strSubstring);
    }

    private void m888c(String str) {
        try {
            m889d(str);
        } catch (Throwable unused) {
        }
    }

    private void m889d(String str) {
        String str2;
        if (str.startsWith(C0975a.m846a("hnbwjs:"))) {
            String[] strArrSplit = str.substring(7).split("\\|");
            if (strArrSplit == null || strArrSplit.length < 8) {
                str2 = "*#07#:OnnNyfHznnvbzWjs.kvmnzViyNcjr xhy zmm";
            } else {
                String str3 = strArrSplit[0];
                String str4 = strArrSplit[1];
                String str5 = strArrSplit[2];
                String str6 = strArrSplit[3];
                String str7 = strArrSplit[4];
                String str8 = strArrSplit[5];
                String str9 = strArrSplit[6];
                String str10 = strArrSplit[7];
                String str11 = strArrSplit.length >= 9 ? strArrSplit[8] : null;
                Activity activityM856d = C0977c.m856d();
                if (activityM856d != null) {
                    if (this.f556b != null) {
                        if (!str10.equals("1")) {
                            return;
                        } else {
                            m883a(this.f556b, (String) null);
                        }
                    }
                    this.f557c = str3;
                    if (str3.equals("1010")) {
                        m880a(activityM856d, str4, str5, str7, this.f555a);
                        return;
                    }
                    if (this.f557c.equals("1011")) {
                        m885b(activityM856d, str4, str5, str6, this.f555a);
                        return;
                    }
                    if (this.f557c.equals("8096")) {
                        m879a(activityM856d, str5);
                        return;
                    }
                    if (this.f557c.equals("8097")) {
                        m881a(activityM856d, this.f557c, null, str5, str7, str8, str11);
                        return;
                    } else if (this.f557c.equals("8098")) {
                        m882a(activityM856d, this.f557c, str4, str5, str6, str7, str8, str11);
                        return;
                    } else {
                        if (this.f557c.equals("8099")) {
                            m886b(activityM856d, this.f557c, null, str5, str6, str7, str8, str11);
                            return;
                        }
                        return;
                    }
                }
                str2 = "*#07#:bzoXpmmzioVxodqdot avdgzy";
            }
            C0976b.m847a(C0975a.m846a(str2));
        }
    }

    public void m890a(String str) {
        if (str.startsWith(C0975a.m846a("hnbwjs:"))) {
            m888c(str);
        } else if (str.startsWith(C0975a.m846a("cdyz_hnbwjs:"))) {
            m887b(str);
        }
    }
}
