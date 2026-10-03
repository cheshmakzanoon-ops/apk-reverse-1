package com.ishumei.smantifraud;

import android.content.Context;
import android.os.Build;
import android.os.Debug;
import android.os.StatFs;
import android.os.SystemClock;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;
import com.google.android.gms.location.LocationRequest;
import com.ishumei.smantifraud.dfp.SMSDK;
import java.io.File;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.Callable;
import java.util.concurrent.atomic.AtomicLong;
import org.json.JSONObject;

public class l111l1111llIl {
    public static final String l111l1111l1Il = "Smlog";
    public static final int l111l1111lI1l = 2;
    public static final String l111l1111lIl = "network";
    public static final int l111l1111llIl = 1;
    public static final String l111l111lIlll = "mounts";
    public static final String l111l111llIl = "input";
    public static final String l111l11IlIlIl = "oaidCheck";
    public static final String l11l1111I11l = "operator";
    public static final String l11l1111I1l = "ssid";
    public static final String l11l1111I1ll = "bssid";
    public static final String l11l1111Il = "wifiip";
    public static final String l11l1111Il1l = "adid";
    public static final String l11l1111Ill = "props_sn";
    public static final String l11l1111lIIl = "battery";
    public static l111l1111llIl l11l111I111l = null;
    public static final String l11l111l11Il = "networkCountryIso";
    public static final String l11l111l1I1l = "launcherInfo";
    public static final String l11l111l1Il = "screenRecord";
    public static final String l11l111l1lll = "oaid";
    public static final String l11l111lI1l = "virtualUid";
    public static final String l11l111lIll = "cpuinfo";
    public static final String l11l111ll11l = "sensor";
    public static final String l11l111ll1Il = "hookJava";
    public static final String l11l111llI1l = "drmId";
    public static final String l11l111lll = "sysEnv";
    public static final String l11l111lllIl = "xpApp";
    public static final String l11l11IlIIll = "simCountryISO";
    public static final String l11l11l1lIl = "locationCls";
    public String l1111l111111Il;
    public final AtomicLong l111l11111I1l = new AtomicLong(-1);
    public long l111l11111Il;
    public String l111l11111lIl;

    public static void l1111l111111Il(l11l11IIII1l l11l11iiii1l, Set set, l11l1111lIIl l11l1111liil, l11l11IIII1l l11l11iiii1l2, l11l111l11Il l11l111l11il, int i, l11l11IIII1l l11l11iiii1l3) {
        l11l11iiii1l.l111l11111I1l();
        l1l11l1Illl l1l11l1illl = new l1l11l1Illl();
        if (!set.contains(l11l111l1lll) && !set.contains(l111l1111lI1l.l11l11Il)) {
            l11l1111liil.l11l111ll11l(new l1l11llIl(l11l11l111Il.l1111l111111Il).l1111l111111Il());
        }
        l11l11iiii1l.l1111l111111Il(103);
        l11l11iiii1l2.l111l11111I1l();
        if (!set.contains(l11l111llI1l) && !set.contains(l111l1111lI1l.l1l11lII11l)) {
            final String strL111l11111lIl = l111l11111I1l.l111l11111lIl(l11l11l111Il.l1111l111111Il);
            l1l11I1l1l.l1111l111111Il.execute(new Runnable() {
                @Override
                public final void run() {
                    l111l1111llIl.l1111l111111Il(strL111l11111lIl);
                }
            });
            if (TextUtils.isEmpty(strL111l11111lIl)) {
                String strL111l1111lIl = l1111l111111Il.l111l1111lIl();
                l11l1111liil.l11l1111Il1l(strL111l1111lIl);
                l111l11111I1l.l1111l111111Il(l11l11l111Il.l1111l111111Il, strL111l1111lIl);
            } else {
                l11l1111liil.l11l1111Il1l(strL111l11111lIl);
            }
        }
        l11l11iiii1l2.l1111l111111Il(84);
        l11l11iiii1l.l111l11111I1l();
        if (!set.contains(l11l111lllIl) && !set.contains(l111l1111lI1l.l111l11I1IIIl)) {
            l11l1111liil.l111l1111lIl(l1111l111111Il.l111l1111llIl());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY, set, l11l111ll1Il) && !set.contains(l111l1111lI1l.l11l11Il1l1l) && l11l111l11il != null && l11l111l11il.l11l111l1lll()) {
            l11l1111liil.l111l11111Il(l1111l111111Il.l111l11111lIl());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 107, set, l11l1111I1ll) && !set.contains(l111l1111lI1l.l11l11l1lIl)) {
            l11l1111liil.l11l1111I11l((i & 1) == 1 ? l1l1l11Ill.l11l1111lIIl(l1l11l1illl.l1111l111111Il()) : l1l11l1illl.l1111l111111Il());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 19, set, l11l1111I1l) && !set.contains(l111l1111lI1l.l11l111I11l)) {
            l11l1111liil.l111l11l11Ill(l1l11l1illl.l111l11111Il());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 30, set, l11l1111Il) && !set.contains(l111l1111lI1l.l111l111I1l)) {
            l11l1111liil.l11l11l1I1l(l1l11l1illl.l111l1111llIl());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 31, set, l111l1111lIl) && !set.contains(l111l1111lI1l.l111l11l11Ill)) {
            l11l1111liil.l11l111l1I1l(l1l11l1illl.l111l11111lIl());
        }
        l11l11iiii1l.l1111l111111Il(44);
        if (!set.contains(l11l1111lIIl) && !set.contains(l111l1111lI1l.l1l11lI11Il)) {
            l11l1111liil.l111l11111I1l(l11l1111Il.l1111l111111Il());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 72, set, l111l1111lI1l.l1l11lI1l)) {
            l11l1111liil.l111l1111llIl(Integer.valueOf(l1l11I111ll.l111l1111llIl()));
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 73, set, l111l1111lI1l.l11l11lI1lll)) {
            l11l1111liil.l111l1111l1Il(Integer.valueOf(Debug.isDebuggerConnected() ? 1 : 0));
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 74, set, l111l1111lI1l.l1l11lI1lIl)) {
            l11l1111liil.l111l11111Il(Integer.valueOf(l111l11111lIl.l1111l111111Il()));
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 75, set, l111l1111lI1l.l1l11lI1I1l)) {
            l11l1111liil.l11l111lIll(l1l11l1Illl.l111l11111I1l());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 76, set, l111l1111lI1l.l1l11lIIlll)) {
            l11l1111liil.l11l1111Il(l1111l111111Il.l111l11111Il());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 77, set, l111l1111lI1l.l1l11lIl)) {
            l11l1111liil.l111l11111lIl(l1111l111111Il.l111l1111l1Il());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 78, set, l111l1111lI1l.l1l11lIll1l)) {
            l11l1111liil.l11l11l1lIl(l1111l111111Il.l11l1111Il1l());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 83, set, l111l1111lI1l.l1ll1Ill)) {
            String strL1111l111111Il = l1l1l11Ill.l1111l111111Il(new String[]{"sh", "-c", "ls /system/usr/app"});
            if (!TextUtils.isEmpty(strL1111l111111Il) && strL1111l111111Il.contains(".apk")) {
                l11l1111liil.l11l11l1l1Il(strL1111l111111Il);
            }
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 159, set, l111l11IlIlIl) && !set.contains(l111l1111lI1l.l1l1lllI1l) && !set.contains(l111l1111lI1l.l11l11Il)) {
            l11l1111liil.l111l1111l1Il(l1l11llIl.l1111l111111Il(l11l11l111Il.l1111l111111Il));
        }
        l11l11iiii1l.l1111l111111Il(162);
        if (!set.contains(l111l1111lI1l.l1lIIlll)) {
            Map<String, String> mapL1111l111111Il = l11l111lIll.l1111l111111Il(l11l11l111Il.l1111l111111Il);
            if (!mapL1111l111111Il.isEmpty()) {
                l11l1111liil.l111l1111l1Il(mapL1111l111111Il);
            }
        }
        l11l11iiii1l3.l1111l111111Il(172);
    }

    public static void l1111l111111Il(String str) {
        if (TextUtils.isEmpty(str)) {
            return;
        }
        l111l11111I1l.l1111l111111Il(l11l11l111Il.l1111l111111Il, l1111l111111Il.l111l1111lIl());
    }

    public static void l111l11111Il() {
        ArrayList arrayList = new ArrayList();
        l1l11I11l.l111l11111Il().l1111l111111Il(arrayList, l111l11111lIl.l1111l111111Il(l11l11l111Il.l1111l111111Il, arrayList));
    }

    public static synchronized l111l1111llIl l111l11111lIl() {
        if (l11l111I111l == null) {
            l11l111I111l = new l111l1111llIl();
        }
        return l11l111I111l;
    }

    public synchronized String l1111l111111Il() {
        return this.l111l11111lIl;
    }

    public synchronized String l1111l111111Il(final int i, boolean z) throws Exception {
        final SmAntiFraud.SmOption smOption;
        l11l11l1llIl l11l11l1llil;
        boolean z2;
        int i2;
        l1l1l1llll l1l1l1llllVar;
        l111l111III1l l111l111iii1l;
        Throwable th;
        int i3;
        JSONObject jSONObjectL1111l111111Il;
        JSONObject jSONObjectL1111l111111Il2;
        String string;
        String strM374v1;
        SubCollector[] subCollectors;
        int length;
        int i4;
        final SubCollector subCollector;
        Map<String, Object> mapCollect;
        Object obj;
        boolean z3;
        boolean z4;
        Throwable th2;
        boolean z5;
        Map<String, String> mapL111l1111l1Il;
        File parentFile;
        String deviceId;
        Map<String, Long> mapL111l11111I1l;
        Map<String, Object> mapL11l1111Il;
        StatFs statFsL111l1111llIl;
        Object objL111l1111llIl;
        String strL1111l111111Il;
        l11l11Il1l l11l11il1l;
        if (l11l11l111Il.l111l1111l1Il) {
            return null;
        }
        if (this.l1111l111111Il != null && this.l111l11111lIl != null && System.currentTimeMillis() - this.l111l11111Il < 1000) {
            return z ? this.l111l11111lIl : this.l1111l111111Il;
        }
        SmAntiFraud.SmOption smOption2 = SmAntiFraud.option;
        final l11l111l11Il l11l111l11ilL111l11111lIl = l11l111l1lll.l1111l111111Il().l111l11111lIl();
        Set<String> setL111l1111lIl = (l11l111l11ilL111l11111lIl == null || l11l111l11ilL111l11111lIl.l111l1111lIl() == null) ? null : l11l111l11ilL111l11111lIl.l111l1111lIl();
        Set<String> notCollect = smOption2.getNotCollect() == null ? null : smOption2.getNotCollect();
        final HashSet hashSet = new HashSet();
        if (setL111l1111lIl != null) {
            hashSet.addAll(setL111l1111lIl);
        }
        if (notCollect != null) {
            hashSet.addAll(notCollect);
        }
        final l11l1111lIIl l11l1111liil = new l11l1111lIIl();
        long jCurrentTimeMillis = System.currentTimeMillis();
        if (!hashSet.contains(l111l1111lI1l.l11l11lIl1ll)) {
            l11l1111liil.l111l111Il1l(l11l11l111Il.l111l11111lIl);
        }
        l11l11l1llIl l11l11l1llil2 = new l11l11l1llIl(l11l11l111Il.l1111l111111Il);
        l111l111III1l l111l111iii1l2 = new l111l111III1l(l11l11l111Il.l1111l111111Il);
        l1l1l1llll l1l1l1llllVar2 = new l1l1l1llll(l11l11l111Il.l1111l111111Il);
        final ArrayList arrayList = new ArrayList();
        try {
            final l11l11IIII1l l11l11iiii1l = new l11l11IIII1l();
            final l11l11IIII1l l11l11iiii1l2 = new l11l11IIII1l();
            final l11l11IIII1l l11l11iiii1l3 = new l11l11IIII1l();
            if (!hashSet.contains(l111l111lIlll)) {
                l11l11l1llil2.l1111l111111Il();
            }
            l111l111iii1l2.l1111l111111Il();
            l1l1l1llllVar2.l1111l111111Il();
            if (!hashSet.contains(l111l1111lI1l.l11l11lII1l)) {
                l11l1111liil.l1111l111111Il(hashSet);
            }
            if (!hashSet.contains(l111l1111lI1l.l11l11I1111l)) {
                l11l1111liil.l11l111lll(smOption2.status());
            }
            if (!hashSet.contains(l111l1111lI1l.l11l11IIII1l)) {
                List<String> listL11l1111lIIl = l1111l111111Il.l11l1111lIIl();
                if (!listL11l1111lIIl.isEmpty()) {
                    l11l1111liil.l1111l111111Il(listL11l1111lIIl);
                }
            }
            if (!hashSet.contains(l111l1111lI1l.l11l111l1lll)) {
                l11l1111liil.l11l111I111l("all");
            }
            final l111l11I1IIIl l111l11i1iiilL111l1111l1Il = l111l11I1IIIl.l111l1111l1Il();
            smOption = smOption2;
            l1l1l1llllVar = l1l1l1llllVar2;
            l111l111iii1l = l111l111iii1l2;
            try {
                Thread thread = new Thread(new Runnable() {
                    @Override
                    public final void run() {
                        l111l1111llIl.l1111l111111Il(l11l11iiii1l3, hashSet, l11l1111liil, l11l11iiii1l2, l11l111l11ilL111l11111lIl, i, l11l11iiii1l);
                    }
                }, "sm-thread-gwnm3000");
                l11l11l1llil = l11l11l1llil2;
                try {
                    Thread thread2 = new Thread(new Runnable() {
                        @Override
                        public final void run() throws Throwable {
                            l111l1111llIl.l1111l111111Il(l11l11iiii1l2, hashSet, l11l1111liil, l111l11i1iiilL111l1111l1Il, smOption, arrayList, l11l11iiii1l);
                        }
                    }, "sm-thread-gwuf");
                    thread.start();
                    thread2.start();
                    l11l11iiii1l.l111l11111I1l();
                    if (hashSet.contains(l111l1111lI1l.l111l111llIl)) {
                        l11l11iiii1l.l1111l111111Il(15);
                        if (!hashSet.contains(l11l1111I11l)) {
                            l11l11iiii1l.l111l11111I1l();
                            l11l11il1l = new l11l11Il1l();
                            l11l1111liil.l11l111ll1Il(l11l11il1l.l111l11111lIl());
                            l11l11iiii1l.l1111l111111Il(45);
                            l11l11iiii1l.l111l11111I1l();
                            if (!hashSet.contains(l11l11IlIIll)) {
                                l11l1111liil.l11IIIlIll(l11l11il1l.l111l11111I1l());
                            }
                            l11l11iiii1l.l1111l111111Il(131);
                            l11l11iiii1l.l111l11111I1l();
                            if (!hashSet.contains(l11l111l11Il)) {
                                l11l1111liil.l11l111l1Il(l11l11il1l.l1111l111111Il());
                            }
                            l11l11iiii1l.l1111l111111Il(132);
                        }
                        l11l11iiii1l.l111l11111I1l();
                        if (hashSet.contains(l111l1111lI1l.l11l111lI1l)) {
                            z2 = true;
                        } else {
                            z2 = true;
                            z2 = true;
                            l11l1111liil.l11l1111I11l(l11l11Il11ll.l1111l111111Il(!hashSet.contains(l11l1111Ill)));
                        }
                        l11l11iiii1l.l1111l111111Il(18);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l11l1111Il1l)) {
                            if ((i & 1) == z2) {
                                strL1111l111111Il = l1l1l11Ill.l11l1111lIIl(l1l11I111ll.l1111l111111Il());
                            } else {
                                strL1111l111111Il = l1l11I111ll.l1111l111111Il();
                            }
                            l11l1111liil.l1111l111111Il(strL1111l111111Il);
                        }
                        l11l11iiii1l.l1111l111111Il(24);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l111I111l)) {
                            l11l1111liil.l111l1111lI1l(Build.getRadioVersion());
                        }
                        l11l11iiii1l.l1111l111111Il(29);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l11I111l)) {
                            l11l1111liil.l111l1111lIl(l1111l111111Il.l111l1111lI1l());
                        }
                        l11l11iiii1l.l1111l111111Il(88);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l11l111lIll)) {
                            l111l111llIl.l111l11111lIl l111l11111lilL111l1111l1Il = l111l111llIl.l111l1111l1Il();
                            l11l1111liil.l11l1111I1ll(l111l11111lilL111l1111l1Il.l1111l111111Il);
                            l11l1111liil.l11l1111I1l(l111l11111lilL111l1111l1Il.l111l11111lIl);
                            l11l1111liil.l111l11111I1l(Integer.valueOf(l111l111llIl.l1111l111111Il()));
                        }
                        if (!hashSet.contains(l111l1111lI1l.l11l111Il)) {
                            l11l1111liil.l111l11111lIl(Integer.valueOf(l111l111llIl.l111l11111I1l()));
                        }
                        if (!hashSet.contains(l111l1111lI1l.l11l11l1I11l)) {
                            l11l1111liil.l111l1111l1Il(Long.valueOf(l111l111llIl.l111l11111Il()));
                        }
                        l11l11iiii1l.l1111l111111Il(33);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11IIIlIll)) {
                            l11l1111liil.l11l111I11l(l11l111lIll.l111l1111l1Il());
                        }
                        if (!hashSet.contains(l111l1111lI1l.l1l11I11l1l)) {
                            l11l1111liil.l111l1111lI1l(Integer.valueOf(l11l111lIll.l111l11111Il()));
                        }
                        if (!hashSet.contains(l111l1111lI1l.l1l11I11l)) {
                            l11l1111liil.l11l1111Il(l11l111lIll.l111l11111lIl());
                        }
                        if (!hashSet.contains(l111l1111lI1l.l11l11l111Il)) {
                            l11l1111liil.l1111l111111Il(Integer.valueOf(l1l11I111ll.l111l1111l1Il()));
                        }
                        l11l11iiii1l.l1111l111111Il(36);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l11l11lIl)) {
                            l11l1111liil.l111l1111l1Il(l111l11111lIl.l111l11111Il());
                        }
                        l11l11iiii1l.l1111l111111Il(38);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l11l11I1l)) {
                            l11l1111liil.l111l11111I1l(l111l11111lIl.l111l11111lIl());
                        }
                        l11l11iiii1l.l1111l111111Il(39);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l11l11Il)) {
                            l11l1111liil.l111l11111lIl(Long.valueOf(l1l11I111ll.l111l11111I1l()));
                        }
                        l11l11iiii1l.l1111l111111Il(40);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l1l1lll)) {
                            l11l1111liil.l111l11111Il(l1l11I111ll.l111l11111lIl());
                        }
                        l11l11iiii1l.l1111l111111Il(127);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l11l111ll11l)) {
                            l11l1111liil.l111l1111llIl(l1l11I111l.l1111l111111Il());
                        }
                        l11l11iiii1l.l1111l111111Il(47);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l11l1llIl)) {
                            l11l1111liil.l11l1111I1l(l11l1111Il1l.l1111l111111Il());
                        }
                        l11l11iiii1l.l1111l111111Il(46);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l11l1I1l)) {
                            l11l1111liil.l111l111III1l(l111l11111lIl.l1111l111111Il(objL111l1111llIl));
                            l11l1111liil.l111l1111lIl(Integer.valueOf(objL111l1111llIl.hashCode()));
                        }
                        l11l11iiii1l.l1111l111111Il(56);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l111llIl)) {
                            l11l1111liil.l111l11111Il(l1111l111111Il.l11l1111I1ll());
                        }
                        l11l11iiii1l.l1111l111111Il(63);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l11lllIl)) {
                            l11l1111liil.l111l11111I1l(l11IIIlIll.l111l11111lIl().l1111l111111Il());
                        }
                        l11l11iiii1l.l1111l111111Il(68);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l11llI1l)) {
                            l11l1111liil.l1111l111111Il(Long.valueOf(statFsL111l1111llIl.getAvailableBytes()));
                            l11l1111liil.l111l11111Il(Long.valueOf(statFsL111l1111llIl.getFreeBytes()));
                            l11l1111liil.l111l1111lI1l(Long.valueOf(statFsL111l1111llIl.getTotalBytes()));
                        }
                        l11l11iiii1l.l1111l111111Il(69);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l11I1l11l)) {
                            l11l1111liil.l1l11l1Il1l(l1111l111111Il.l111l11IlIlIl());
                        }
                        l11l11iiii1l.l1111l111111Il(99);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l11I1l1l)) {
                            l11l1111liil.l1l11l1Il(l1111l111111Il.l11l111l1lll());
                        }
                        l11l11iiii1l.l1111l111111Il(100);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l11II111l)) {
                            l11l1111liil.l1l11l1I1Il(l1111l111111Il.l11l111l11Il());
                        }
                        l11l11iiii1l.l1111l111111Il(101);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l11IIl11l)) {
                            l11l1111liil.l11l1111Ill(z2 ? 1 : 0);
                        }
                        l11l11iiii1l.l1111l111111Il(113);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l1l1llll)) {
                            l11l1111liil.l111l11111lIl(l111l11111I1l.l1111l111111Il(l11l11l111Il.l1111l111111Il));
                        }
                        l11l11iiii1l.l1111l111111Il(130);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l11l11l1lIl)) {
                            l11l1111liil.l111l1111lI1l(mapL11l1111Il);
                        }
                        l11l11iiii1l.l1111l111111Il(116);
                        if (!hashSet.contains(l111l1111lI1l.l1l1l111Il)) {
                            l11l11iiii1l.l111l11111I1l();
                            if (l1111l111111Il.l11l1111I11l()) {
                                l11l1111liil.l1111l111111Il(z2);
                            }
                            l11l11iiii1l.l1111l111111Il(117);
                        }
                        if (!hashSet.contains(l111l1111lI1l.l1l1l11I1l)) {
                            l11l11iiii1l.l111l11111I1l();
                            l11l1111liil.l11l1111I1ll(l1l11l1Illl.l111l1111l1Il());
                            l11l11iiii1l.l1111l111111Il(120);
                        }
                        if (hashSet.contains(l111l1111lI1l.l1l1l11Il)) {
                            i2 = 0;
                        } else {
                            l11l11iiii1l.l111l11111I1l();
                            i2 = 0;
                            l11l1111liil.l1111l111111Il(Settings.Secure.getInt(l11l11l111Il.l1111l111111Il.getContentResolver(), "adb_enabled", 0));
                            l11l11iiii1l.l1111l111111Il(121);
                        }
                        if (!hashSet.contains(l111l1111lI1l.l11l1l1l1Il)) {
                            l11l11iiii1l.l111l11111I1l();
                            l11l1111liil.l11l11IlIIll(smOption.getExtraInfo());
                            l11l11iiii1l.l1111l111111Il(124);
                        }
                        if (!hashSet.contains(l111l1111lI1l.l1l1l1ll)) {
                            l11l11iiii1l.l111l11111I1l();
                            mapL111l11111I1l = l111l11111lIl.l111l11111I1l();
                            if (mapL111l11111I1l != null) {
                                l11l1111liil.l111l11111lIl(mapL111l11111I1l);
                            }
                            l11l11iiii1l.l1111l111111Il(125);
                        }
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l1l1ll1l)) {
                            this.l111l11111I1l.set(Thread.currentThread().getId());
                            deviceId = SmAntiFraud.getDeviceId();
                            if (deviceId != null) {
                                l11l1111liil.l11l111lI1l(deviceId);
                            }
                            this.l111l11111I1l.set(-1L);
                        }
                        l11l11iiii1l.l1111l111111Il(126);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l111l1l1IIll)) {
                            l11l1111liil.l11l1111lIIl(z2 ? 1 : 0);
                        }
                        l11l11iiii1l.l1111l111111Il(135);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l1lIlIl)) {
                            l11l1111liil.l111l1111llIl(z2 ? 1 : 0);
                        }
                        l11l11iiii1l.l1111l111111Il(139);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l11l1ll1ll)) {
                            l11l1111liil.l11l11IlIIll(l11l11Il11ll.l1111l111111Il(l11l11l111Il.l1111l111111Il));
                        }
                        l11l11iiii1l.l1111l111111Il(142);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l111l1111lI1l.l1l1ll1IIl)) {
                            l11l1111liil.l11l1111lIIl(mapL111l1111l1Il);
                        }
                        l11l11iiii1l.l1111l111111Il(153);
                        l11l11iiii1l.l111l11111I1l();
                        if (!hashSet.contains(l11l111l1I1l)) {
                            l11l1111liil.l111l1111llIl(l111l11111lIl.l1111l111111Il(l11l11l111Il.l1111l111111Il));
                        }
                        l11l11iiii1l.l1111l111111Il(154);
                        thread.join(3000L);
                        thread2.join();
                        if (!hashSet.contains(l111l1111lI1l.l111l1l1IIll)) {
                            l11l1111liil.l11l1111lIIl(l11l11l1llil.l111l11111lIl());
                        }
                        if (!hashSet.contains(l111l1111lI1l.l11l1llllll)) {
                            l11l1111liil.l111l1111lI1l(z2 ? 1 : 0);
                        }
                        if (!hashSet.contains(l111l1111lI1l.l1l1llllIl)) {
                            l11l1111liil.l11l111l11Il(z2 ? 1 : 0);
                        }
                        if (!hashSet.contains(l111l1111lI1l.l1l1l1I1ll)) {
                            l11l1111liil.l111l1111l1Il((int) (System.currentTimeMillis() - jCurrentTimeMillis));
                        }
                        if (!hashSet.contains(l111l1111lI1l.l11l1ll1lIl)) {
                            l11l1111liil.l11l111l1lll(l11l11iiii1l.l1111l111111Il() + l11l11iiii1l3.l1111l111111Il() + l11l11iiii1l2.l1111l111111Il());
                        }
                        l11l11iiii1l.l111l11111lIl();
                        l11l11iiii1l3.l111l11111lIl();
                        l11l11iiii1l2.l111l11111lIl();
                        z3 = z2;
                        i3 = z2;
                        if (!hashSet.contains(l111l111lIlll)) {
                            l11l11l1llil.l111l11111I1l();
                            i3 = z3;
                        }
                    } else {
                        try {
                            l11l1111liil.l111l1111llIl(String.valueOf(l1111l111111Il.l111l11111I1l()));
                            l11l11iiii1l.l1111l111111Il(15);
                            if (!hashSet.contains(l11l1111I11l) && !hashSet.contains(l111l1111lI1l.l11l11l1l1Il) && !hashSet.contains(l111l1111lI1l.l1l1l1I11l) && !hashSet.contains(l111l1111lI1l.l11l1l1I1l)) {
                                l11l11iiii1l.l111l11111I1l();
                                l11l11il1l = new l11l11Il1l();
                                l11l1111liil.l11l111ll1Il(l11l11il1l.l111l11111lIl());
                                l11l11iiii1l.l1111l111111Il(45);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l11l11IlIIll)) {
                                    l11l1111liil.l11IIIlIll(l11l11il1l.l111l11111I1l());
                                }
                                l11l11iiii1l.l1111l111111Il(131);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l11l111l11Il)) {
                                    l11l1111liil.l11l111l1Il(l11l11il1l.l1111l111111Il());
                                }
                                l11l11iiii1l.l1111l111111Il(132);
                            }
                            l11l11iiii1l.l111l11111I1l();
                            if (hashSet.contains(l111l1111lI1l.l11l111lI1l)) {
                                try {
                                    z2 = true;
                                    z2 = true;
                                    try {
                                        l11l1111liil.l11l1111I11l(l11l11Il11ll.l1111l111111Il(!hashSet.contains(l11l1111Ill)));
                                    } catch (Throwable th3) {
                                        th = th3;
                                        th = th;
                                        z5 = z2;
                                        i2 = 0;
                                        z4 = z5;
                                        try {
                                            if (!hashSet.contains(l111l1111lI1l.l1l11lIl1Il)) {
                                                try {
                                                    l11l1111liil.l11l1111Ill(Log.getStackTraceString(th));
                                                } catch (Throwable th4) {
                                                    th2 = th4;
                                                    if (!hashSet.contains(l111l111lIlll)) {
                                                        l11l11l1llil.l111l11111I1l();
                                                    }
                                                    l111l111iii1l.l111l11111I1l();
                                                    l1l1l1llllVar.l111l11111I1l();
                                                    throw th2;
                                                }
                                            }
                                            z3 = z4;
                                            i3 = z4;
                                            if (!hashSet.contains(l111l111lIlll)) {
                                            }
                                            l111l111iii1l.l111l11111I1l();
                                            l1l1l1llllVar.l111l11111I1l();
                                            jSONObjectL1111l111111Il = l1l1l11Ill.l1111l111111Il(l11l1111liil, (Set<String>) null);
                                            subCollectors = smOption.getSubCollectors();
                                            if (subCollectors != null) {
                                                length = subCollectors.length;
                                                for (i4 = i2; i4 < length; i4++) {
                                                    subCollector = subCollectors[i4];
                                                    if (subCollector.timeout <= 0) {
                                                        mapCollect = subCollector.collect();
                                                    } else {
                                                        mapCollect = (Map) new l1IIIIIIIl().l1111l111111Il(subCollector.timeout, new Callable() {
                                                            @Override
                                                            public final Object call() {
                                                                return subCollector.collect();
                                                            }
                                                        });
                                                    }
                                                    if (mapCollect != null) {
                                                        for (String str : mapCollect.keySet()) {
                                                            if (!jSONObjectL1111l111111Il.has(str)) {
                                                                obj = mapCollect.get(str);
                                                                if (obj instanceof Map) {
                                                                    jSONObjectL1111l111111Il.put(str, new JSONObject((Map) obj));
                                                                } else {
                                                                    jSONObjectL1111l111111Il.put(str, obj);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            if (smOption.isUsingShortBoxData()) {
                                                jSONObjectL1111l111111Il2 = null;
                                            } else {
                                                jSONObjectL1111l111111Il2 = null;
                                            }
                                            Context context = l11l11l111Il.l1111l111111Il;
                                            String string2 = jSONObjectL1111l111111Il.toString();
                                            if (jSONObjectL1111l111111Il2 == null) {
                                                string = null;
                                            } else {
                                                string = jSONObjectL1111l111111Il2.toString();
                                            }
                                            if (l11l111l11ilL111l11111lIl == null) {
                                                strM374v1 = SMSDK.m374v1(context, string2, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                                if (!TextUtils.isEmpty(strM374v1)) {
                                                }
                                                throw new Exception("error ret: " + strM374v1);
                                            }
                                            strM374v1 = SMSDK.m374v1(context, string2, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                            if (!TextUtils.isEmpty(strM374v1)) {
                                            }
                                            throw new Exception("error ret: " + strM374v1);
                                        } catch (Throwable th5) {
                                            th2 = th5;
                                        }
                                    }
                                } catch (Throwable th6) {
                                    th = th6;
                                    z2 = true;
                                    th = th;
                                    z5 = z2;
                                    i2 = 0;
                                    z4 = z5;
                                    if (!hashSet.contains(l111l1111lI1l.l1l11lIl1Il)) {
                                        l11l1111liil.l11l1111Ill(Log.getStackTraceString(th));
                                    }
                                    z3 = z4;
                                    i3 = z4;
                                    if (!hashSet.contains(l111l111lIlll)) {
                                    }
                                    l111l111iii1l.l111l11111I1l();
                                    l1l1l1llllVar.l111l11111I1l();
                                    jSONObjectL1111l111111Il = l1l1l11Ill.l1111l111111Il(l11l1111liil, (Set<String>) null);
                                    subCollectors = smOption.getSubCollectors();
                                    if (subCollectors != null) {
                                        length = subCollectors.length;
                                        while (i4 < length) {
                                            subCollector = subCollectors[i4];
                                            if (subCollector.timeout <= 0) {
                                                mapCollect = subCollector.collect();
                                            } else {
                                                mapCollect = (Map) new l1IIIIIIIl().l1111l111111Il(subCollector.timeout, new Callable() {
                                                    @Override
                                                    public final Object call() {
                                                        return subCollector.collect();
                                                    }
                                                });
                                            }
                                            if (mapCollect != null) {
                                                while (r2.hasNext()) {
                                                    if (!jSONObjectL1111l111111Il.has(str)) {
                                                        obj = mapCollect.get(str);
                                                        if (obj instanceof Map) {
                                                            jSONObjectL1111l111111Il.put(str, new JSONObject((Map) obj));
                                                        } else {
                                                            jSONObjectL1111l111111Il.put(str, obj);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    if (smOption.isUsingShortBoxData()) {
                                        jSONObjectL1111l111111Il2 = null;
                                    } else {
                                        jSONObjectL1111l111111Il2 = null;
                                    }
                                    Context context2 = l11l11l111Il.l1111l111111Il;
                                    String string3 = jSONObjectL1111l111111Il.toString();
                                    if (jSONObjectL1111l111111Il2 == null) {
                                        string = null;
                                    } else {
                                        string = jSONObjectL1111l111111Il2.toString();
                                    }
                                    if (l11l111l11ilL111l11111lIl == null) {
                                        strM374v1 = SMSDK.m374v1(context2, string3, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                        if (!TextUtils.isEmpty(strM374v1)) {
                                        }
                                        throw new Exception("error ret: " + strM374v1);
                                    }
                                    strM374v1 = SMSDK.m374v1(context2, string3, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                    if (!TextUtils.isEmpty(strM374v1)) {
                                    }
                                    throw new Exception("error ret: " + strM374v1);
                                }
                            } else {
                                z2 = true;
                            }
                            try {
                                l11l11iiii1l.l1111l111111Il(18);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l11l1111Il1l) && !hashSet.contains(l111l1111lI1l.l111l111lIlll)) {
                                    if ((i & 1) == z2) {
                                        strL1111l111111Il = l1l1l11Ill.l11l1111lIIl(l1l11I111ll.l1111l111111Il());
                                    } else {
                                        strL1111l111111Il = l1l11I111ll.l1111l111111Il();
                                    }
                                    l11l1111liil.l1111l111111Il(strL1111l111111Il);
                                }
                                l11l11iiii1l.l1111l111111Il(24);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l111I111l)) {
                                    l11l1111liil.l111l1111lI1l(Build.getRadioVersion());
                                }
                                l11l11iiii1l.l1111l111111Il(29);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l11I111l)) {
                                    l11l1111liil.l111l1111lIl(l1111l111111Il.l111l1111lI1l());
                                }
                                l11l11iiii1l.l1111l111111Il(88);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l11l111lIll) && !hashSet.contains(l111l1111lI1l.l111l111Il1l) && !hashSet.contains(l111l1111lI1l.l11l1lI1I1l) && !hashSet.contains(l111l1111lI1l.l111l111III1l)) {
                                    l111l111llIl.l111l11111lIl l111l11111lilL111l1111l1Il2 = l111l111llIl.l111l1111l1Il();
                                    l11l1111liil.l11l1111I1ll(l111l11111lilL111l1111l1Il2.l1111l111111Il);
                                    l11l1111liil.l11l1111I1l(l111l11111lilL111l1111l1Il2.l111l11111lIl);
                                    l11l1111liil.l111l11111I1l(Integer.valueOf(l111l111llIl.l1111l111111Il()));
                                }
                                if (!hashSet.contains(l111l1111lI1l.l11l111Il)) {
                                    l11l1111liil.l111l11111lIl(Integer.valueOf(l111l111llIl.l111l11111I1l()));
                                }
                                if (!hashSet.contains(l111l1111lI1l.l11l11l1I11l)) {
                                    l11l1111liil.l111l1111l1Il(Long.valueOf(l111l111llIl.l111l11111Il()));
                                }
                                l11l11iiii1l.l1111l111111Il(33);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11IIIlIll)) {
                                    l11l1111liil.l11l111I11l(l11l111lIll.l111l1111l1Il());
                                }
                                if (!hashSet.contains(l111l1111lI1l.l1l11I11l1l)) {
                                    l11l1111liil.l111l1111lI1l(Integer.valueOf(l11l111lIll.l111l11111Il()));
                                }
                                if (!hashSet.contains(l111l1111lI1l.l1l11I11l)) {
                                    l11l1111liil.l11l1111Il(l11l111lIll.l111l11111lIl());
                                }
                                if (!hashSet.contains(l111l1111lI1l.l11l11l111Il)) {
                                    l11l1111liil.l1111l111111Il(Integer.valueOf(l1l11I111ll.l111l1111l1Il()));
                                }
                                l11l11iiii1l.l1111l111111Il(36);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l11l11lIl)) {
                                    l11l1111liil.l111l1111l1Il(l111l11111lIl.l111l11111Il());
                                }
                                l11l11iiii1l.l1111l111111Il(38);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l11l11I1l)) {
                                    l11l1111liil.l111l11111I1l(l111l11111lIl.l111l11111lIl());
                                }
                                l11l11iiii1l.l1111l111111Il(39);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l11l11Il)) {
                                    l11l1111liil.l111l11111lIl(Long.valueOf(l1l11I111ll.l111l11111I1l()));
                                }
                                l11l11iiii1l.l1111l111111Il(40);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l1l1lll)) {
                                    l11l1111liil.l111l11111Il(l1l11I111ll.l111l11111lIl());
                                }
                                l11l11iiii1l.l1111l111111Il(127);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l11l111ll11l) && !hashSet.contains(l111l1111lI1l.l11l11l1lI1l)) {
                                    l11l1111liil.l111l1111llIl(l1l11I111l.l1111l111111Il());
                                }
                                l11l11iiii1l.l1111l111111Il(47);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l11l1llIl)) {
                                    l11l1111liil.l11l1111I1l(l11l1111Il1l.l1111l111111Il());
                                }
                                l11l11iiii1l.l1111l111111Il(46);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l11l1I1l) && !hashSet.contains(l111l1111lI1l.l1l11l1I1Il) && (objL111l1111llIl = l111l11111lIl.l111l1111llIl()) != null) {
                                    l11l1111liil.l111l111III1l(l111l11111lIl.l1111l111111Il(objL111l1111llIl));
                                    l11l1111liil.l111l1111lIl(Integer.valueOf(objL111l1111llIl.hashCode()));
                                }
                                l11l11iiii1l.l1111l111111Il(56);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l111llIl) && !hashSet.contains(l111l1111lI1l.l1l11l1Illl)) {
                                    l11l1111liil.l111l11111Il(l1111l111111Il.l11l1111I1ll());
                                }
                                l11l11iiii1l.l1111l111111Il(63);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l11lllIl)) {
                                    l11l1111liil.l111l11111I1l(l11IIIlIll.l111l11111lIl().l1111l111111Il());
                                }
                                l11l11iiii1l.l1111l111111Il(68);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l11llI1l) && !hashSet.contains(l111l1111lI1l.l1l11llIl) && !hashSet.contains(l111l1111lI1l.l1l11lI11l) && (statFsL111l1111llIl = l11l111lIll.l111l1111llIl()) != null) {
                                    l11l1111liil.l1111l111111Il(Long.valueOf(statFsL111l1111llIl.getAvailableBytes()));
                                    l11l1111liil.l111l11111Il(Long.valueOf(statFsL111l1111llIl.getFreeBytes()));
                                    l11l1111liil.l111l1111lI1l(Long.valueOf(statFsL111l1111llIl.getTotalBytes()));
                                }
                                l11l11iiii1l.l1111l111111Il(69);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l11I1l11l)) {
                                    l11l1111liil.l1l11l1Il1l(l1111l111111Il.l111l11IlIlIl());
                                }
                                l11l11iiii1l.l1111l111111Il(99);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l11I1l1l)) {
                                    l11l1111liil.l1l11l1Il(l1111l111111Il.l11l111l1lll());
                                }
                                l11l11iiii1l.l1111l111111Il(100);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l11II111l)) {
                                    l11l1111liil.l1l11l1I1Il(l1111l111111Il.l11l111l11Il());
                                }
                                l11l11iiii1l.l1111l111111Il(101);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l11IIl11l) && l1111l111111Il.l11l11IlIIll() == z2) {
                                    l11l1111liil.l11l1111Ill(z2 ? 1 : 0);
                                }
                                l11l11iiii1l.l1111l111111Il(113);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l1l1llll)) {
                                    l11l1111liil.l111l11111lIl(l111l11111I1l.l1111l111111Il(l11l11l111Il.l1111l111111Il));
                                }
                                l11l11iiii1l.l1111l111111Il(130);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l11l11l1lIl) && !hashSet.contains(l111l1111lI1l.l1l1l11Ill) && (mapL11l1111Il = l1111l111111Il.l11l1111Il()) != null) {
                                    l11l1111liil.l111l1111lI1l(mapL11l1111Il);
                                }
                                l11l11iiii1l.l1111l111111Il(116);
                                if (!hashSet.contains(l111l1111lI1l.l1l1l111Il)) {
                                    l11l11iiii1l.l111l11111I1l();
                                    if (l1111l111111Il.l11l1111I11l()) {
                                        l11l1111liil.l1111l111111Il(z2);
                                    }
                                    l11l11iiii1l.l1111l111111Il(117);
                                }
                                if (!hashSet.contains(l111l1111lI1l.l1l1l11I1l)) {
                                    l11l11iiii1l.l111l11111I1l();
                                    l11l1111liil.l11l1111I1ll(l1l11l1Illl.l111l1111l1Il());
                                    l11l11iiii1l.l1111l111111Il(120);
                                }
                                if (hashSet.contains(l111l1111lI1l.l1l1l11Il)) {
                                    l11l11iiii1l.l111l11111I1l();
                                    i2 = 0;
                                    try {
                                        l11l1111liil.l1111l111111Il(Settings.Secure.getInt(l11l11l111Il.l1111l111111Il.getContentResolver(), "adb_enabled", 0));
                                        l11l11iiii1l.l1111l111111Il(121);
                                    } catch (Throwable th7) {
                                        th = th7;
                                        th = th;
                                        z4 = z2;
                                        if (!hashSet.contains(l111l1111lI1l.l1l11lIl1Il)) {
                                            l11l1111liil.l11l1111Ill(Log.getStackTraceString(th));
                                        }
                                        z3 = z4;
                                        i3 = z4;
                                        if (!hashSet.contains(l111l111lIlll)) {
                                        }
                                        l111l111iii1l.l111l11111I1l();
                                        l1l1l1llllVar.l111l11111I1l();
                                        jSONObjectL1111l111111Il = l1l1l11Ill.l1111l111111Il(l11l1111liil, (Set<String>) null);
                                        subCollectors = smOption.getSubCollectors();
                                        if (subCollectors != null) {
                                            length = subCollectors.length;
                                            while (i4 < length) {
                                                subCollector = subCollectors[i4];
                                                if (subCollector.timeout <= 0) {
                                                    mapCollect = subCollector.collect();
                                                } else {
                                                    mapCollect = (Map) new l1IIIIIIIl().l1111l111111Il(subCollector.timeout, new Callable() {
                                                        @Override
                                                        public final Object call() {
                                                            return subCollector.collect();
                                                        }
                                                    });
                                                }
                                                if (mapCollect != null) {
                                                    while (r2.hasNext()) {
                                                        if (!jSONObjectL1111l111111Il.has(str)) {
                                                            obj = mapCollect.get(str);
                                                            if (obj instanceof Map) {
                                                                jSONObjectL1111l111111Il.put(str, new JSONObject((Map) obj));
                                                            } else {
                                                                jSONObjectL1111l111111Il.put(str, obj);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        if (smOption.isUsingShortBoxData()) {
                                            jSONObjectL1111l111111Il2 = null;
                                        } else {
                                            jSONObjectL1111l111111Il2 = null;
                                        }
                                        Context context3 = l11l11l111Il.l1111l111111Il;
                                        String string4 = jSONObjectL1111l111111Il.toString();
                                        if (jSONObjectL1111l111111Il2 == null) {
                                            string = null;
                                        } else {
                                            string = jSONObjectL1111l111111Il2.toString();
                                        }
                                        if (l11l111l11ilL111l11111lIl == null) {
                                            strM374v1 = SMSDK.m374v1(context3, string4, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                            if (!TextUtils.isEmpty(strM374v1)) {
                                            }
                                            throw new Exception("error ret: " + strM374v1);
                                        }
                                        strM374v1 = SMSDK.m374v1(context3, string4, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                        if (!TextUtils.isEmpty(strM374v1)) {
                                        }
                                        throw new Exception("error ret: " + strM374v1);
                                    }
                                } else {
                                    i2 = 0;
                                }
                                if (!hashSet.contains(l111l1111lI1l.l11l1l1l1Il)) {
                                    l11l11iiii1l.l111l11111I1l();
                                    l11l1111liil.l11l11IlIIll(smOption.getExtraInfo());
                                    l11l11iiii1l.l1111l111111Il(124);
                                }
                                if (!hashSet.contains(l111l1111lI1l.l1l1l1ll)) {
                                    l11l11iiii1l.l111l11111I1l();
                                    mapL111l11111I1l = l111l11111lIl.l111l11111I1l();
                                    if (mapL111l11111I1l != null && !mapL111l11111I1l.isEmpty()) {
                                        l11l1111liil.l111l11111lIl(mapL111l11111I1l);
                                    }
                                    l11l11iiii1l.l1111l111111Il(125);
                                }
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l1l1ll1l)) {
                                    this.l111l11111I1l.set(Thread.currentThread().getId());
                                    try {
                                        deviceId = SmAntiFraud.getDeviceId();
                                        if (deviceId != null && !deviceId.startsWith("D")) {
                                            l11l1111liil.l11l111lI1l(deviceId);
                                        }
                                        this.l111l11111I1l.set(-1L);
                                    } catch (Throwable th8) {
                                        this.l111l11111I1l.set(-1L);
                                        throw th8;
                                    }
                                }
                                l11l11iiii1l.l1111l111111Il(126);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l111l1l1IIll) && SMSDK.m371ma()) {
                                    l11l1111liil.l11l1111lIIl(z2 ? 1 : 0);
                                }
                                l11l11iiii1l.l1111l111111Il(135);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l1lIlIl) && (parentFile = new File(l11l11l111Il.l1111l111111Il.getApplicationInfo().dataDir).getParentFile()) != null && parentFile.canRead()) {
                                    l11l1111liil.l111l1111llIl(z2 ? 1 : 0);
                                }
                                l11l11iiii1l.l1111l111111Il(139);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l11l1ll1ll)) {
                                    l11l1111liil.l11l11IlIIll(l11l11Il11ll.l1111l111111Il(l11l11l111Il.l1111l111111Il));
                                }
                                l11l11iiii1l.l1111l111111Il(142);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l111l1111lI1l.l1l1ll1IIl) && (mapL111l1111l1Il = l111l11111lIl.l111l1111l1Il()) != null) {
                                    l11l1111liil.l11l1111lIIl(mapL111l1111l1Il);
                                }
                                l11l11iiii1l.l1111l111111Il(153);
                                l11l11iiii1l.l111l11111I1l();
                                if (!hashSet.contains(l11l111l1I1l) && !hashSet.contains(l111l1111lI1l.l1l1lll11l)) {
                                    l11l1111liil.l111l1111llIl(l111l11111lIl.l1111l111111Il(l11l11l111Il.l1111l111111Il));
                                }
                                l11l11iiii1l.l1111l111111Il(154);
                                thread.join(3000L);
                                thread2.join();
                                if (!hashSet.contains(l111l1111lI1l.l111l1l1IIll) && !hashSet.contains(l111l111lIlll) && l11l11l1llil.l111l11111lIl() > 0) {
                                    l11l1111liil.l11l1111lIIl(l11l11l1llil.l111l11111lIl());
                                }
                                if (!hashSet.contains(l111l1111lI1l.l11l1llllll) && l111l111iii1l.l111l11111lIl()) {
                                    l11l1111liil.l111l1111lI1l(z2 ? 1 : 0);
                                }
                                if (!hashSet.contains(l111l1111lI1l.l1l1llllIl) && l1l1l1llllVar.l111l11111lIl()) {
                                    l11l1111liil.l11l111l11Il(z2 ? 1 : 0);
                                }
                                if (!hashSet.contains(l111l1111lI1l.l1l1l1I1ll)) {
                                    l11l1111liil.l111l1111l1Il((int) (System.currentTimeMillis() - jCurrentTimeMillis));
                                }
                                if (!hashSet.contains(l111l1111lI1l.l11l1ll1lIl)) {
                                    l11l1111liil.l11l111l1lll(l11l11iiii1l.l1111l111111Il() + l11l11iiii1l3.l1111l111111Il() + l11l11iiii1l2.l1111l111111Il());
                                }
                                l11l11iiii1l.l111l11111lIl();
                                l11l11iiii1l3.l111l11111lIl();
                                l11l11iiii1l2.l111l11111lIl();
                                z3 = z2;
                                i3 = z2;
                                if (!hashSet.contains(l111l111lIlll)) {
                                    l11l11l1llil.l111l11111I1l();
                                    i3 = z3;
                                }
                            } catch (Throwable th9) {
                                th = th9;
                                i2 = 0;
                                th = th;
                                z4 = z2;
                                if (!hashSet.contains(l111l1111lI1l.l1l11lIl1Il)) {
                                    l11l1111liil.l11l1111Ill(Log.getStackTraceString(th));
                                }
                                z3 = z4;
                                i3 = z4;
                                if (!hashSet.contains(l111l111lIlll)) {
                                    l11l11l1llil.l111l11111I1l();
                                    i3 = z3;
                                }
                                l111l111iii1l.l111l11111I1l();
                                l1l1l1llllVar.l111l11111I1l();
                                jSONObjectL1111l111111Il = l1l1l11Ill.l1111l111111Il(l11l1111liil, (Set<String>) null);
                                subCollectors = smOption.getSubCollectors();
                                if (subCollectors != null) {
                                    length = subCollectors.length;
                                    while (i4 < length) {
                                        subCollector = subCollectors[i4];
                                        if (subCollector.timeout <= 0) {
                                            mapCollect = subCollector.collect();
                                        } else {
                                            mapCollect = (Map) new l1IIIIIIIl().l1111l111111Il(subCollector.timeout, new Callable() {
                                                @Override
                                                public final Object call() {
                                                    return subCollector.collect();
                                                }
                                            });
                                        }
                                        if (mapCollect != null) {
                                            while (r2.hasNext()) {
                                                if (!jSONObjectL1111l111111Il.has(str)) {
                                                    obj = mapCollect.get(str);
                                                    if (obj instanceof Map) {
                                                        jSONObjectL1111l111111Il.put(str, new JSONObject((Map) obj));
                                                    } else {
                                                        jSONObjectL1111l111111Il.put(str, obj);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                if (smOption.isUsingShortBoxData()) {
                                    jSONObjectL1111l111111Il2 = null;
                                } else {
                                    jSONObjectL1111l111111Il2 = null;
                                }
                                Context context4 = l11l11l111Il.l1111l111111Il;
                                String string5 = jSONObjectL1111l111111Il.toString();
                                if (jSONObjectL1111l111111Il2 == null) {
                                    string = null;
                                } else {
                                    string = jSONObjectL1111l111111Il2.toString();
                                }
                                if (l11l111l11ilL111l11111lIl == null) {
                                    strM374v1 = SMSDK.m374v1(context4, string5, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                    if (!TextUtils.isEmpty(strM374v1)) {
                                    }
                                    throw new Exception("error ret: " + strM374v1);
                                }
                                strM374v1 = SMSDK.m374v1(context4, string5, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                if (!TextUtils.isEmpty(strM374v1)) {
                                }
                                throw new Exception("error ret: " + strM374v1);
                            }
                        } catch (Throwable th10) {
                            th = th10;
                            z5 = true;
                            i2 = 0;
                            z4 = z5;
                            if (!hashSet.contains(l111l1111lI1l.l1l11lIl1Il)) {
                                l11l1111liil.l11l1111Ill(Log.getStackTraceString(th));
                            }
                            z3 = z4;
                            i3 = z4;
                            if (!hashSet.contains(l111l111lIlll)) {
                                l11l11l1llil.l111l11111I1l();
                                i3 = z3;
                            }
                            l111l111iii1l.l111l11111I1l();
                            l1l1l1llllVar.l111l11111I1l();
                            jSONObjectL1111l111111Il = l1l1l11Ill.l1111l111111Il(l11l1111liil, (Set<String>) null);
                            subCollectors = smOption.getSubCollectors();
                            if (subCollectors != null) {
                                length = subCollectors.length;
                                while (i4 < length) {
                                    subCollector = subCollectors[i4];
                                    if (subCollector.timeout <= 0) {
                                        mapCollect = subCollector.collect();
                                    } else {
                                        mapCollect = (Map) new l1IIIIIIIl().l1111l111111Il(subCollector.timeout, new Callable() {
                                            @Override
                                            public final Object call() {
                                                return subCollector.collect();
                                            }
                                        });
                                    }
                                    if (mapCollect != null) {
                                        while (r2.hasNext()) {
                                            if (!jSONObjectL1111l111111Il.has(str)) {
                                                obj = mapCollect.get(str);
                                                if (obj instanceof Map) {
                                                    jSONObjectL1111l111111Il.put(str, new JSONObject((Map) obj));
                                                } else {
                                                    jSONObjectL1111l111111Il.put(str, obj);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            if (smOption.isUsingShortBoxData()) {
                                jSONObjectL1111l111111Il2 = null;
                            } else {
                                jSONObjectL1111l111111Il2 = null;
                            }
                            Context context5 = l11l11l111Il.l1111l111111Il;
                            String string6 = jSONObjectL1111l111111Il.toString();
                            if (jSONObjectL1111l111111Il2 == null) {
                                string = null;
                            } else {
                                string = jSONObjectL1111l111111Il2.toString();
                            }
                            if (l11l111l11ilL111l11111lIl == null) {
                                strM374v1 = SMSDK.m374v1(context5, string6, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                                if (!TextUtils.isEmpty(strM374v1)) {
                                }
                                throw new Exception("error ret: " + strM374v1);
                            }
                            strM374v1 = SMSDK.m374v1(context5, string6, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                            if (!TextUtils.isEmpty(strM374v1)) {
                            }
                            throw new Exception("error ret: " + strM374v1);
                        }
                    }
                } catch (Throwable th11) {
                    th = th11;
                    z2 = true;
                    i2 = 0;
                    th = th;
                    z4 = z2;
                    if (!hashSet.contains(l111l1111lI1l.l1l11lIl1Il)) {
                        l11l1111liil.l11l1111Ill(Log.getStackTraceString(th));
                    }
                    z3 = z4;
                    i3 = z4;
                    if (!hashSet.contains(l111l111lIlll)) {
                        l11l11l1llil.l111l11111I1l();
                        i3 = z3;
                    }
                    l111l111iii1l.l111l11111I1l();
                    l1l1l1llllVar.l111l11111I1l();
                    jSONObjectL1111l111111Il = l1l1l11Ill.l1111l111111Il(l11l1111liil, (Set<String>) null);
                    subCollectors = smOption.getSubCollectors();
                    if (subCollectors != null) {
                        length = subCollectors.length;
                        while (i4 < length) {
                            subCollector = subCollectors[i4];
                            if (subCollector.timeout <= 0) {
                                mapCollect = subCollector.collect();
                            } else {
                                mapCollect = (Map) new l1IIIIIIIl().l1111l111111Il(subCollector.timeout, new Callable() {
                                    @Override
                                    public final Object call() {
                                        return subCollector.collect();
                                    }
                                });
                            }
                            if (mapCollect != null) {
                                while (r2.hasNext()) {
                                    if (!jSONObjectL1111l111111Il.has(str)) {
                                        obj = mapCollect.get(str);
                                        if (obj instanceof Map) {
                                            jSONObjectL1111l111111Il.put(str, new JSONObject((Map) obj));
                                        } else {
                                            jSONObjectL1111l111111Il.put(str, obj);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if (smOption.isUsingShortBoxData()) {
                        jSONObjectL1111l111111Il2 = null;
                    } else {
                        jSONObjectL1111l111111Il2 = null;
                    }
                    Context context6 = l11l11l111Il.l1111l111111Il;
                    String string7 = jSONObjectL1111l111111Il.toString();
                    if (jSONObjectL1111l111111Il2 == null) {
                        string = null;
                    } else {
                        string = jSONObjectL1111l111111Il2.toString();
                    }
                    if (l11l111l11ilL111l11111lIl == null) {
                        strM374v1 = SMSDK.m374v1(context6, string7, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                        if (!TextUtils.isEmpty(strM374v1)) {
                        }
                        throw new Exception("error ret: " + strM374v1);
                    }
                    strM374v1 = SMSDK.m374v1(context6, string7, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
                    if (!TextUtils.isEmpty(strM374v1)) {
                    }
                    throw new Exception("error ret: " + strM374v1);
                }
            } catch (Throwable th12) {
                th = th12;
                l11l11l1llil = l11l11l1llil2;
            }
        } catch (Throwable th13) {
            th = th13;
            smOption = smOption2;
            l11l11l1llil = l11l11l1llil2;
            z2 = true;
            i2 = 0;
            l1l1l1llllVar = l1l1l1llllVar2;
            l111l111iii1l = l111l111iii1l2;
        }
        l111l111iii1l.l111l11111I1l();
        l1l1l1llllVar.l111l11111I1l();
        jSONObjectL1111l111111Il = l1l1l11Ill.l1111l111111Il(l11l1111liil, (Set<String>) null);
        try {
            subCollectors = smOption.getSubCollectors();
            if (subCollectors != null) {
                length = subCollectors.length;
                while (i4 < length) {
                    subCollector = subCollectors[i4];
                    if (subCollector.timeout <= 0) {
                        mapCollect = subCollector.collect();
                    } else {
                        mapCollect = (Map) new l1IIIIIIIl().l1111l111111Il(subCollector.timeout, new Callable() {
                            @Override
                            public final Object call() {
                                return subCollector.collect();
                            }
                        });
                    }
                    if (mapCollect != null) {
                        while (r2.hasNext()) {
                            if (!jSONObjectL1111l111111Il.has(str)) {
                                obj = mapCollect.get(str);
                                if (obj instanceof Map) {
                                    jSONObjectL1111l111111Il.put(str, new JSONObject((Map) obj));
                                } else {
                                    jSONObjectL1111l111111Il.put(str, obj);
                                }
                            }
                        }
                    }
                }
            }
        } catch (Throwable unused) {
        }
        if (smOption.isUsingShortBoxData() || !TextUtils.isEmpty(l11l11l111Il.l111l11111Il) || hashSet.contains(l111l1111lI1l.l1l1llIIl)) {
            jSONObjectL1111l111111Il2 = null;
        } else {
            l11l1111liil.l11l1111I11l(i3);
            jSONObjectL1111l111111Il2 = l1l1l11Ill.l1111l111111Il(l11l1111liil, l111l1111lI1l.l1l1I111l);
            l111l1111lI1l.l1111l111111Il(jSONObjectL1111l111111Il2);
        }
        Context context7 = l11l11l111Il.l1111l111111Il;
        String string8 = jSONObjectL1111l111111Il.toString();
        if (jSONObjectL1111l111111Il2 == null) {
            string = null;
        } else {
            string = jSONObjectL1111l111111Il2.toString();
        }
        strM374v1 = SMSDK.m374v1(context7, string8, string, (l11l111l11ilL111l11111lIl == null && l11l111l11ilL111l11111lIl.l11l111l1I1l()) ? l11l111l11ilL111l11111lIl.l1111l111111Il() : null, smOption.getPublicKey(), smOption.getOrganization(), smOption.getAppId(), smOption.getChannel(), l11l11l111Il.l111l11111I1l, hashSet, arrayList);
        if (!TextUtils.isEmpty(strM374v1) || !strM374v1.startsWith("{")) {
            throw new Exception("error ret: " + strM374v1);
        }
        int iIndexOf = strM374v1.indexOf("}{") + i3;
        if (iIndexOf > 0) {
            this.l1111l111111Il = strM374v1.substring(i2, iIndexOf);
            strM374v1 = strM374v1.substring(iIndexOf);
        } else {
            this.l1111l111111Il = strM374v1;
        }
        this.l111l11111lIl = strM374v1;
        if (TextUtils.isEmpty(l11l11l111Il.l111l11111Il)) {
            l11l111ll1Il.l1111l111111Il(l11l11l111Il.l1111l111111Il, this.l111l11111lIl);
        } else {
            l11l111ll1Il.l111l11111I1l(l11l11l111Il.l1111l111111Il);
        }
        l11l111ll1Il.l111l11111Il(l11l11l111Il.l1111l111111Il);
        this.l111l11111Il = System.currentTimeMillis();
        return z ? this.l111l11111lIl : this.l1111l111111Il;
    }

    public boolean l111l11111I1l() {
        return Thread.currentThread().getId() == this.l111l11111I1l.get();
    }

    public static void l1111l111111Il(l11l11IIII1l l11l11iiii1l, Set set, l11l1111lIIl l11l1111liil, l111l11I1IIIl l111l11i1iiil, SmAntiFraud.SmOption smOption, List list, l11l11IIII1l l11l11iiii1l2) throws Throwable {
        List<String> listL11l1111Ill;
        l11l11iiii1l.l111l11111I1l();
        if (!set.contains(l11l111lI1l) && !set.contains(l111l1111lI1l.l1l11l1Il)) {
            l11l1l1l1Il.l1111l111111Il(l11l1111liil);
        }
        l11l11iiii1l.l1111l111111Il(60);
        l11l11iiii1l.l111l11111I1l();
        if (l11l11l111Il.l1111l111111Il != null && !set.contains(l111l1111lI1l.l1l11l1Il1l)) {
            l11l1111liil.l11l111l11Il(l11l11l111Il.l1111l111111Il.getFilesDir().toString());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 62, set, l111l1111lI1l.l1l11l1IIl)) {
            l11l1111liil.l1111l111111Il(l1111l111111Il.l1111l111111Il());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 64, set, l111l1111lI1l.l11l111l1I1l)) {
            l11l1111liil.l11l11l11lIl(l1l11I11l.l111l11111Il().l111l11111I1l());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 4, set, l111l1111lI1l.l1l11I11lll)) {
            l11l1111liil.l11l1111lIIl(l111l11i1iiil.l1111l111111Il());
        }
        if (!set.contains(l111l1111lI1l.l11l11Il11ll)) {
            l11l1111liil.l11l11l11I1l(l111l11i1iiil.l111l1111lI1l());
        }
        if (!set.contains(l111l1111lI1l.l11l11Il111l)) {
            l11l1111liil.l11l11l11Il(l111l11i1iiil.l111l1111lIl());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 97, set, l11l111lll) && !set.contains(l111l1111lI1l.l1IIIIIIIl) && (listL11l1111Ill = l1111l111111Il.l11l1111Ill()) != null && !listL11l1111Ill.isEmpty()) {
            l11l1111liil.l111l1111lI1l(listL11l1111Ill);
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 115, set, l111l1111lI1l.l1l11I11ll)) {
            l11l1111liil.l11l111lllIl(smOption.getOrganization());
        }
        if (!set.contains(l111l1111lI1l.l111l11IlIlIl)) {
            l11l1111liil.l11l11l111Il(l111l11i1iiil.l111l1111llIl());
        }
        if (!set.contains(l111l1111lI1l.l11l111l1Il)) {
            l11l1111liil.l111l11111Il(smOption.getChannel());
        }
        if (!set.contains(l111l1111lI1l.l11l111ll11l)) {
            l11l1111liil.l11l111llI1l(l11l11lI1lll.l111l1111l1Il);
        }
        if (!set.contains(l111l1111lI1l.l11l111ll1Il)) {
            l11l1111liil.l11l111Il(l11l11lI1lll.l111l11111I1l);
        }
        if (!set.contains(l111l1111lI1l.l11l1l1IIIl)) {
            l11l1111liil.l111l111I1l(l11l11lI1lll.l111l11111Il);
        }
        if (!set.contains(l111l1111lI1l.l11l111lll)) {
            l11l1111liil.l111l1111llIl(Long.valueOf(System.currentTimeMillis()));
        }
        if (!set.contains(l111l1111lI1l.l11l1lIl)) {
            l11l1111liil.l111l11111I1l(SystemClock.elapsedRealtime());
        }
        if (!set.contains(l111l1111lI1l.l1l1lI1ll)) {
            l11l1111liil.l111l11111Il(SystemClock.uptimeMillis());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 96, set, l111l1111lI1l.l1l11I111ll)) {
            l11l1111liil.l11l1111lIIl(Integer.valueOf(l111l11111lIl.l111l1111lI1l()));
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 90, set, l111l1111lI1l.l11l111lllIl)) {
            l11l1111liil.l111l111llIl(Build.VERSION.RELEASE);
        }
        if (!set.contains(l111l1111lI1l.l11l111llI1l)) {
            l11l1111liil.l111l11111lIl(smOption.getAppId());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 10, set, l11l111l1Il) && !set.contains(l111l1111lI1l.l11l1ll11ll) && !set.contains(l111l1111lI1l.l1l1lll1l) && !set.contains(l111l1111lI1l.l1l1lll1ll)) {
            l11l11I1111l l11l11i1111l = new l11l11I1111l();
            if (l11l11i1111l.l1111l111111Il(l11l11l111Il.l1111l111111Il, false)) {
                l11l1111liil.l11l1111Il1l(l11l11i1111l.l111l11111I1l);
                l11l1111liil.l111l11111lIl(l11l11i1111l.l111l11111lIl());
                l11l1111liil.l111l1111lIl(l11l11i1111l.l111l11111lIl);
            }
        }
        l11l11iiii1l.l1111l111111Il(141);
        if (!set.contains(l111l1111lI1l.l1l1llIl)) {
            l11l1111liil.l111l111lIlll(l1l11I11l.l111l11111Il().l111l1111lIl());
        }
        l11l11iiii1l.l1111l111111Il(163);
        if (!set.contains(l111l1111lI1l.l11l1llIl1l)) {
            l11l1111liil.l11l1111Il(l111l11111lIl.l111l11111Il(l11l11l111Il.l1111l111111Il));
        }
        l11l11iiii1l.l1111l111111Il(164);
        if (!set.contains(l111l1111lI1l.l1l1lI111l)) {
            l11l1111liil.l11l1111I1ll(l111l11111lIl.l111l11111I1l(l11l11l111Il.l1111l111111Il));
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 165, set, l111l1111lI1l.l1l1I1111l) && l1l11I11l.l111l11111Il().l1111l111111Il(l11l11l111Il.l1111l111111Il)) {
            l11l1111liil.l111l11111I1l(1);
        }
        if (!set.contains(l111l1111lI1l.l1l1lI11ll)) {
            l11l1111liil.l1111l111111Il(l111l11I1IIIl.l111l1111l1Il().l111l11111lIl());
        }
        if (!set.contains(l111l1111lI1l.l11l1lI1l)) {
            l11l1111liil.l111l11111lIl(l1l11I11l.l111l11111Il().l1111l111111Il());
        }
        if (!l111l1111l1Il.l1111l111111Il(l11l11iiii1l, 167, set, l111l1111lI1l.l1l1lI1l1l)) {
            l1l11I1l1l.l1111l111111Il.execute(new Runnable() {
                @Override
                public final void run() {
                    l111l1111llIl.l111l11111Il();
                }
            });
            list.clear();
            List<byte[]> listL111l1111l1Il = l1l11I11l.l111l11111Il().l111l1111l1Il();
            if (listL111l1111l1Il == null) {
                l11l1111liil.l111l11IlIlIl(l1l11I11l.l111l11111Il().l111l1111llIl());
            } else {
                list.addAll(listL111l1111l1Il);
            }
        }
        if (!set.contains(l111l1111lI1l.l1lIl1Il)) {
            l11l1111liil.l11l1111I1l(l1l11I11l.l111l11111Il().l111l1111lI1l());
        }
        l11l11iiii1l.l1111l111111Il(169);
        l11l11iiii1l2.l111l11111I1l();
    }
}
