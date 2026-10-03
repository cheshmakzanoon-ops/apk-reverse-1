package com.gme.liteav.base.util;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.Application;
import android.content.Context;
import android.os.Bundle;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import java.lang.ref.WeakReference;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public final class C1053e implements Application.ActivityLifecycleCallbacks {

    private static final C1059k<Boolean> f750b = new C1059k<>(CallableC1054f.m1022a());

    public volatile boolean f751a;

    private volatile WeakReference<Activity> f752c;

    private volatile Boolean f753d;

    private volatile a f754e;

    private final Set<Integer> f755f;

    private final Set<Integer> f756g;

    public interface a {
        void mo973a(boolean z);
    }

    C1053e(byte b2) {
        this();
    }

    static class b {

        private static final C1053e f757a = new C1053e(0);
    }

    public static void m1012a(boolean z) {
        f750b.m1028a(Boolean.valueOf(z));
    }

    public static C1053e m1011a() {
        return b.f757a;
    }

    private C1053e() {
        this.f752c = null;
        this.f753d = null;
        this.f755f = new HashSet();
        this.f756g = new HashSet();
        this.f751a = false;
        Context applicationContext = ContextUtils.getApplicationContext();
        if (applicationContext == null) {
            Log.m948e("ProcessLifecycleOwner", "ProcessStateOwner init failed. Context is null", new Object[0]);
        } else {
            ((Application) applicationContext.getApplicationContext()).registerActivityLifecycleCallbacks(this);
        }
    }

    public final synchronized void m1017a(Activity activity) {
        if (activity == null) {
            return;
        }
        if (m1020c() != null) {
            Log.m949i("ProcessLifecycleOwner", "activity is exists, don't need activity from user", new Object[0]);
            return;
        }
        this.f752c = new WeakReference<>(activity);
        Log.m949i("ProcessLifecycleOwner", "update activity to " + activity + " from user", new Object[0]);
    }

    public final synchronized boolean m1019b() {
        if (this.f753d == null) {
            this.f753d = f750b.m1027a();
        }
        return this.f753d.booleanValue();
    }

    public final synchronized void m1018a(a aVar) {
        this.f754e = aVar;
    }

    private synchronized void m1015b(boolean z) {
        if (this.f753d == null || this.f753d.booleanValue() != z) {
            this.f753d = Boolean.valueOf(z);
            f750b.m1028a(Boolean.valueOf(z));
            if (this.f754e != null && this.f751a) {
                this.f754e.mo973a(this.f753d.booleanValue());
            }
        }
    }

    private static boolean m1013a(Context context) {
        try {
            ActivityManager activityManager = (ActivityManager) context.getSystemService("activity");
            if (activityManager == null) {
                Log.m948e("ProcessLifecycleOwner", "activityManager is null.", new Object[0]);
                return false;
            }
            List<ActivityManager.RunningAppProcessInfo> runningAppProcesses = activityManager.getRunningAppProcesses();
            if (runningAppProcesses == null) {
                Log.m948e("ProcessLifecycleOwner", "processInfoList is null.", new Object[0]);
                return false;
            }
            for (ActivityManager.RunningAppProcessInfo runningAppProcessInfo : runningAppProcesses) {
                if (runningAppProcessInfo.importance == 100 && context.getPackageName().equals(runningAppProcessInfo.processName)) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            Log.m948e("ProcessLifecycleOwner", "Get App background state failed. ".concat(String.valueOf(e)), new Object[0]);
            return false;
        }
    }

    @Override
    public final synchronized void onActivityCreated(Activity activity, Bundle bundle) {
    }

    @Override
    public final synchronized void onActivityStarted(Activity activity) {
        m1014b(activity);
    }

    @Override
    public final synchronized void onActivityResumed(Activity activity) {
        m1014b(activity);
    }

    @Override
    public final synchronized void onActivityPaused(Activity activity) {
        this.f756g.add(Integer.valueOf(activity.hashCode()));
    }

    @Override
    public final synchronized void onActivityStopped(Activity activity) {
        if (this.f751a) {
            StringBuilder sb = new StringBuilder("onActivityStopped, activity=");
            sb.append(activity);
            sb.append(" mActivity=");
            sb.append(this.f752c != null ? this.f752c.get() : "null");
            Log.m949i("ProcessLifecycleOwner", sb.toString(), new Object[0]);
        }
        int iHashCode = activity.hashCode();
        if (this.f755f.contains(Integer.valueOf(iHashCode))) {
            this.f755f.remove(Integer.valueOf(iHashCode));
            m1015b(this.f755f.size() == 0);
            if (this.f752c != null && this.f752c.get() == activity) {
                this.f752c = null;
            }
        } else if (this.f755f.size() == 0) {
            if (this.f756g.contains(Integer.valueOf(iHashCode))) {
                m1015b(true);
            }
        } else {
            m1015b(false);
        }
        this.f756g.remove(Integer.valueOf(iHashCode));
    }

    @Override
    public final synchronized void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
    }

    @Override
    public final synchronized void onActivityDestroyed(Activity activity) {
        if (this.f751a) {
            StringBuilder sb = new StringBuilder("onActivityDestroyed, activity=");
            sb.append(activity);
            sb.append(" mActivity=");
            sb.append(this.f752c != null ? this.f752c.get() : "null");
            Log.m949i("ProcessLifecycleOwner", sb.toString(), new Object[0]);
        }
    }

    private void m1014b(Activity activity) {
        this.f755f.add(Integer.valueOf(activity.hashCode()));
        this.f752c = new WeakReference<>(activity);
        m1015b(false);
        if (this.f751a) {
            Log.m949i("ProcessLifecycleOwner", "update activity to ".concat(String.valueOf(activity)), new Object[0]);
        }
    }

    public final Activity m1020c() {
        WeakReference<Activity> weakReference = this.f752c;
        if (weakReference != null) {
            return weakReference.get();
        }
        return null;
    }
}
