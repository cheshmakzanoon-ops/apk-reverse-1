package com.google.android.material.card2;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import normal.updatev2.DebugActivity;
import normal.updatev2.SketchApplication;

public class C0217hm implements Thread.UncaughtExceptionHandler {

    final SketchApplication f435gQ;

    public C0217hm(SketchApplication sketchApplication) {
        this.f435gQ = sketchApplication;
    }

    public static Thread.UncaughtExceptionHandler m4656(Object obj) {
        if (C0447yc.m8635() >= 0) {
            return SketchApplication.a((SketchApplication) obj);
        }
        return null;
    }

    public static PendingIntent m4657(Object obj, int i, Object obj2, int i2) {
        if (C0452yh.m9798() > 0) {
            return C0598.m11859(obj, i, obj2, i2);
        }
        return null;
    }

    public static Object m4658(Object obj, Object obj2) {
        if (abd.m2162() >= 0) {
            return ((SketchApplication) obj).getSystemService((String) obj2);
        }
        return null;
    }

    public static Context m4659(Object obj) {
        if (C0451yg.m9580() > 0) {
            return ((SketchApplication) obj).getApplicationContext();
        }
        return null;
    }

    public static SketchApplication m4660(Object obj) {
        if (C0445ya.m8222() >= 0) {
            return ((C0217hm) obj).f435gQ;
        }
        return null;
    }

    public static SketchApplication m4661(Object obj) {
        if (abf.m2510() <= 0) {
            return m4662(obj);
        }
        return null;
    }

    public static SketchApplication m4662(Object obj) {
        if (C0453yj.m9945() <= 0) {
            return m4660((C0217hm) obj);
        }
        return null;
    }

    public static Context m4663(Object obj) {
        if (C0448yd.m9074() <= 0) {
            return m4659((SketchApplication) obj);
        }
        return null;
    }

    public static Thread.UncaughtExceptionHandler m4664(Object obj) {
        if (abf.m2500() >= 0) {
            return m4656((SketchApplication) obj);
        }
        return null;
    }

    public static Object m4665(Object obj, Object obj2) {
        if (C0460zg.m11293() > 0) {
            return m4658((SketchApplication) obj, (String) obj2);
        }
        return null;
    }

    @Override
    public void uncaughtException(Thread thread, Throwable th) {
        Intent intent = new Intent(C0456zb.m10508(m4661(this)), (Class<?>) DebugActivity.class);
        adds.m2775(intent, 32768);
        abf.m2651(intent, C0448yd.m8928(), C0458ze.m10812(th));
        C0448yd.m9032((AlarmManager) abe.m2408(m4661(this), C0450yf.m9440()), 2, 1000L, m4657(C0456zb.m10508(m4661(this)), 11111, intent, 1073741824));
        C0455za.m10112(adds.m2672());
        adds.m2787(1);
        C0445ya.m8322(abe.m2222(m4661(this)), thread, th);
    }
}
