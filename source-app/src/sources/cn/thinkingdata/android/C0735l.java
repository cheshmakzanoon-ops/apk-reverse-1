package cn.thinkingdata.android;

import android.content.Context;
import android.content.res.Resources;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import java.util.HashMap;
import java.util.Map;

public class C0735l {

    private static final Map<Context, C0735l> f224d = new HashMap();

    private String f225a;

    private int f226b;

    private int f227c;

    private C0735l(Context context) {
        this.f226b = 10;
        this.f227c = 10000;
        Resources resources = context.getResources();
        String packageName = context.getPackageName();
        try {
            this.f225a = packageName;
            this.f225a = resources.getString(resources.getIdentifier("TADeFaultMainProcessName", TypedValues.Custom.S_STRING, packageName));
        } catch (Exception unused) {
        }
        try {
            this.f226b = resources.getInteger(resources.getIdentifier("TARetentionDays", TypedValues.Custom.S_INT, packageName));
        } catch (Exception unused2) {
        }
        try {
            this.f227c = resources.getInteger(resources.getIdentifier("TADatabaseLimit", TypedValues.Custom.S_INT, packageName));
        } catch (Exception unused3) {
        }
        TDPresetProperties.initDisableList(context);
    }

    public static C0735l m656a(Context context) {
        C0735l c0735l;
        Map<Context, C0735l> map = f224d;
        synchronized (map) {
            c0735l = map.get(context);
            if (c0735l == null) {
                c0735l = new C0735l(context);
                map.put(context, c0735l);
            }
        }
        return c0735l;
    }

    long m657a() {
        int i = this.f226b;
        if (i > 10 || i < 0) {
            i = 10;
        }
        return 86400000 * ((long) i);
    }

    public String m658b() {
        return this.f225a;
    }

    int m659c() {
        return Math.max(this.f227c, 5000);
    }
}
