package com.ishumei.smantifraud;

import android.util.Log;
import com.google.firebase.analytics.FirebaseAnalytics;

public class l11l111lll {
    public static l11l111lll l111l11111I1l = null;
    public static final String l111l11111lIl = "Smlog";
    public String l1111l111111Il;

    public class l1111l111111Il implements l1l11lIl.l111l11111lIl<l11l111llI1l> {
        public l1111l111111Il() {
        }

        @Override
        public void l1111l111111Il(l11l111llI1l l11l111lli1l) {
            l11l111lll.this.l1111l111111Il(l11l111lli1l);
        }
    }

    public class l111l11111I1l extends l1l11I11lll<Object> {
        public l111l11111I1l(String str, String str2, String str3) {
            super(str, str2, str3);
        }

        @Override
        public l1l11lIl<Object> l1111l111111Il(l1l11ll1Il l1l11ll1il) {
            return new l1l11lIl<>(new Object());
        }
    }

    public class l111l11111lIl extends l11l111lllIl {
        public l111l11111lIl(String str, String str2, l1l11lIl.l111l11111lIl l111l11111lil, l1l11lIl.l1111l111111Il l1111l111111il) {
            super(str, str2, l111l11111lil, l1111l111111il);
        }

        @Override
        public byte[] l111l11111lIl() {
            try {
                if (this.l11l111ll11l == null) {
                    String strL1111l111111Il = l11l111lll.this.l1111l111111Il();
                    this.l11l111ll11l = strL1111l111111Il;
                    l11l111lll.this.l1111l111111Il = strL1111l111111Il;
                }
            } catch (Throwable th) {
                this.l11l111ll11l = null;
                l11l111lll.this.l1111l111111Il(th);
            }
            return super.l111l11111lIl();
        }
    }

    public static synchronized l11l111lll l111l11111lIl() {
        if (l111l11111I1l == null) {
            l111l11111I1l = new l11l111lll();
        }
        return l111l11111I1l;
    }

    public final String l1111l111111Il() throws Exception {
        l11l111l11Il l11l111l11ilL111l11111lIl = l11l111l1lll.l1111l111111Il().l111l11111lIl();
        return l111l1111llIl.l111l11111lIl().l1111l111111Il((l11l111l11ilL111l11111lIl == null || l11l111l11ilL111l11111lIl.l11l111l11Il() ? 2 : 0) | (SmAntiFraud.option.needUsingMD5() ? 1 : 0), false);
    }

    public final void l1111l111111Il(l11l111llI1l l11l111lli1l) {
        Log.i("Smlog", FirebaseAnalytics.Param.SUCCESS);
        l11IIIlIll.l111l11111lIl().l1111l111111Il(l11l111lli1l.l11l1111Ill, l11l111lli1l.l11l11IlIIll);
        l111l11I1IIIl.l111l1111l1Il().l1111l111111Il(l11l111lli1l.l111l11111Il(), true);
        l11l11ll1ll.l1111l111111Il().l111l11111lIl();
    }

    public final void l1111l111111Il(l1l11I11ll l1l11i11ll, String str) {
        int i = l1l11i11ll.l111l11111lIl;
        if (i != 1902) {
            l11l11l1l1Il.l1111l111111Il(str, this.l1111l111111Il, l11l111l1lll.l1111l111111Il().l111l11111lIl());
        }
        if (i > 0) {
            i = -3;
        }
        if (SmAntiFraud.getServerIdCallback() != null) {
            SmAntiFraud.getServerIdCallback().onError(i);
        }
        this.l1111l111111Il = null;
    }

    public void l1111l111111Il(String str, final String str2) {
        l111l11111lIl l111l11111lil = new l111l11111lIl(str, str2, new l1111l111111Il(), new l1l11lIl.l1111l111111Il() {
            @Override
            public final void l1111l111111Il(l1l11I11ll l1l11i11ll) {
                this.f$0.l1111l111111Il(str2, l1l11i11ll);
            }
        });
        l111l11111lil.l11l11IlIIll = new l11l111lI1l(30000, 0, 0.0f);
        l11l11ll1ll.l1111l111111Il().l1111l111111Il(l111l11111lil);
    }

    public final void l1111l111111Il(Throwable th) {
        l11l11ll1ll.l1111l111111Il().l1111l111111Il(new l111l11111I1l(SmAntiFraud.option.getUrl(), SmAntiFraud.option.getRetryUrl(), l111l111I1l.l111l11111lIl.l1111l111111Il.l1111l111111Il(th)));
    }
}
