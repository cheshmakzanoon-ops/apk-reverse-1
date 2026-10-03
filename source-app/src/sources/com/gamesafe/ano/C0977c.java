package com.gamesafe.ano;

import android.app.Activity;
import android.content.Context;
import java.util.Collection;

public class C0977c {

    private static Context f539a;

    private static Activity f540b;

    public static Boolean m851a(Object obj) {
        try {
            return (Boolean) C0984j.m892a("android.app.ActivityThread$ActivityClientRecord", obj, "paused");
        } catch (Exception unused) {
            return true;
        }
    }

    public static void m852a() {
        C0976b.m847a("jar_ver:7.4.15(2020/11/10)-jar-version");
    }

    public static void m853a(int i, Object obj) {
        if (i == 1) {
            f540b = (Activity) obj;
        } else if (i == 2) {
            f539a = (Context) obj;
        }
    }

    public static Context m854b() {
        if (f539a == null) {
            try {
                f539a = (Context) C0984j.m892a("android.app.ActivityThread", C0984j.m895a("android.app.ActivityThread", "currentActivityThread", new Class[0], new Object[0]), "mInitialApplication");
            } catch (Exception unused) {
                f539a = null;
            }
        }
        return f539a;
    }

    public static Activity m855c() {
        try {
            return (Activity) C0984j.m893a("com.unity3d.player.UnityPlayer", "currentActivity");
        } catch (Exception unused) {
            return null;
        }
    }

    public static Activity m856d() {
        Activity activity = f540b;
        if (activity != null) {
            return activity;
        }
        Activity activityM855c = m855c();
        return activityM855c == null ? m857e() : activityM855c;
    }

    private static Activity m857e() {
        try {
            Activity activity = null;
            for (Object obj : ((Collection) C0984j.m894a("java.util.Map", "values", C0984j.m892a("android.app.ActivityThread", C0984j.m895a("android.app.ActivityThread", "currentActivityThread", new Class[0], new Object[0]), "mActivities"), new Class[0], new Object[0])).toArray()) {
                if (obj != null) {
                    Object objM892a = C0984j.m892a("android.app.ActivityThread$ActivityClientRecord", obj, "activity");
                    Boolean boolM851a = m851a(obj);
                    if (objM892a != null && (activity == null || !boolM851a.booleanValue())) {
                        activity = (Activity) objM892a;
                    }
                }
            }
            return activity;
        } catch (Exception unused) {
            return null;
        }
    }
}
