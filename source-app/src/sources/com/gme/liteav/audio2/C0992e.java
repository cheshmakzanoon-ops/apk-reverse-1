package com.gme.liteav.audio2;

import android.content.Context;
import android.media.AudioManager;
import android.os.Build;
import android.os.Process;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.util.C1055g;
import com.gme.liteav.base.util.C1055g.a;
import java.lang.ref.WeakReference;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

public final class C0992e extends PhoneStateListener implements C0990c.a {

    static C0990c f577c;

    Class<?> f580d;

    Object f581e;

    private b f584h;

    int f583g = 0;

    private boolean f585i = false;

    TelephonyManager f578a = (TelephonyManager) ContextUtils.getApplicationContext().getSystemService("phone");

    AudioManager f579b = (AudioManager) ContextUtils.getApplicationContext().getSystemService("audio");

    C1055g f582f = new C1055g("PhoneStateManager");

    public interface b {
        void onInterruptedByPhoneCall();

        void onResumedByPhoneCall();
    }

    static {
        if (Build.VERSION.SDK_INT >= 26) {
            f577c = new C0990c();
        }
    }

    public C0992e(b bVar) {
        this.f584h = bVar;
    }

    @Override
    public final void onCallStateChanged(int i, String str) {
        b bVar = this.f584h;
        if (bVar == null || this.f583g == i) {
            return;
        }
        this.f583g = i;
        if (i == 2) {
            bVar.onInterruptedByPhoneCall();
        } else if (i == 0) {
            bVar.onResumedByPhoneCall();
        }
    }

    @Override
    public final void mo922a() {
        C1055g c1055g = this.f582f;
        C1055g.a aVar = c1055g.new a(RunnableC0994g.m933a(this));
        synchronized (c1055g) {
            c1055g.f761c.add(aVar);
        }
        C1055g.this.f760b.postDelayed(aVar.f763b, aVar.f764c);
    }

    public void m930d() {
        b bVar = this.f584h;
        if (bVar == null) {
            return;
        }
        try {
            if (this.f579b.getMode() == 2) {
                this.f585i = true;
                bVar.onInterruptedByPhoneCall();
            } else if (this.f585i) {
                this.f585i = false;
                bVar.onResumedByPhoneCall();
            }
        } catch (Throwable th) {
            Log.m948e("PhoneStateManager", "get Mode exception, " + th.getMessage(), new Object[0]);
        }
    }

    static boolean m927b() {
        Context applicationContext = ContextUtils.getApplicationContext();
        if (applicationContext == null) {
            return false;
        }
        try {
            return applicationContext.checkPermission("android.permission.READ_PHONE_STATE", Process.myPid(), Process.myUid()) == 0;
        } catch (Throwable th) {
            Log.m948e("PhoneStateManager", "check permission exception, " + th.getMessage(), new Object[0]);
            return true;
        }
    }

    static void m929c() {
        if (Build.VERSION.SDK_INT >= 26 && f577c != null) {
            Log.m949i("PhoneStateManager", "unregister audio playback callback.", new Object[0]);
            f577c.f575a = null;
        }
    }

    static class a implements InvocationHandler {

        private final WeakReference<C0992e> f586a;

        a(C0992e c0992e) {
            this.f586a = new WeakReference<>(c0992e);
        }

        @Override
        public final Object invoke(Object obj, Method method, Object[] objArr) {
            b bVar;
            try {
                if ("onModeChanged".equals(method.getName())) {
                    int iIntValue = ((Integer) objArr[0]).intValue();
                    C0992e c0992e = this.f586a.get();
                    if (c0992e != null && (bVar = c0992e.f584h) != null) {
                        if (iIntValue == 2) {
                            c0992e.f585i = true;
                            bVar.onInterruptedByPhoneCall();
                        } else if (c0992e.f585i) {
                            c0992e.f585i = false;
                            bVar.onResumedByPhoneCall();
                        }
                    }
                }
            } catch (Throwable th) {
                Log.m948e("PhoneStateManager", "notify mode changed failed, " + th.getMessage(), new Object[0]);
            }
            return obj;
        }
    }
}
