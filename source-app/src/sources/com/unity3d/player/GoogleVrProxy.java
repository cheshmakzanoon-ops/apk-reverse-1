package com.unity3d.player;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.view.Surface;
import android.view.SurfaceView;
import android.view.View;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.util.Iterator;
import java.util.Vector;
import java.util.concurrent.atomic.AtomicLong;

class GoogleVrProxy extends C1129d implements GoogleVrVideo {

    private boolean f219f;

    private boolean f220g;

    private Runnable f221h;

    private Vector f222i;

    private SurfaceView f223j;

    private C1083a f224k;

    private Thread f225l;

    private Handler f226m;

    class C1083a {

        public boolean f238a = false;

        public boolean f239b = false;

        public boolean f240c = false;

        public boolean f241d = false;

        public boolean f242e = true;

        public boolean f243f = false;

        C1083a() {
        }

        public final void m464a(String str) {
            StringBuilder sb = new StringBuilder();
            sb.append(str);
            sb.append(" : VR State [");
            for (Field field : getClass().getDeclaredFields()) {
                try {
                    Object obj = field.get(this);
                    if (obj.getClass() != getClass()) {
                        sb.append(" ");
                        sb.append(field.getName());
                        sb.append("=");
                        sb.append(obj);
                        sb.append(",");
                    }
                } catch (Exception unused) {
                }
            }
            sb.append("]");
            C1134i.Log(4, sb.toString());
        }

        public final boolean m465a() {
            return this.f238a && this.f239b;
        }

        public final void m466b() {
            this.f238a = false;
            this.f239b = false;
            this.f241d = false;
            this.f242e = true;
            this.f243f = false;
        }
    }

    public GoogleVrProxy(InterfaceC1133h interfaceC1133h) {
        super("Google VR", interfaceC1133h);
        this.f219f = false;
        this.f220g = false;
        this.f221h = null;
        this.f222i = new Vector();
        this.f223j = null;
        this.f224k = new C1083a();
        this.f225l = null;
        this.f226m = new Handler(Looper.getMainLooper()) {
            @Override
            public final void handleMessage(Message message) {
                if (message.what != 135711) {
                    super.handleMessage(message);
                }
                switch (message.arg1) {
                    case 2147483645:
                        Iterator it = GoogleVrProxy.this.f222i.iterator();
                        while (it.hasNext()) {
                            ((GoogleVrVideo.GoogleVrVideoCallbacks) it.next()).onFrameAvailable();
                        }
                        break;
                    case 2147483646:
                        Surface surface = (Surface) message.obj;
                        Iterator it2 = GoogleVrProxy.this.f222i.iterator();
                        while (it2.hasNext()) {
                            ((GoogleVrVideo.GoogleVrVideoCallbacks) it2.next()).onSurfaceAvailable(surface);
                        }
                        break;
                    default:
                        super.handleMessage(message);
                        break;
                }
            }
        };
        initVrJni();
    }

    public void m451a(boolean z) {
        this.f224k.f241d = z;
        this.f224k.m464a("setVrEnabled");
    }

    private boolean m452a(ClassLoader classLoader) {
        try {
            Class<?> clsLoadClass = classLoader.loadClass("com.unity3d.unitygvr.GoogleVR");
            C1143r c1143r = new C1143r(clsLoadClass, clsLoadClass.getConstructor(null).newInstance(null));
            c1143r.m691a("initialize", new Class[]{Activity.class, Context.class, SurfaceView.class, Boolean.TYPE, Handler.class});
            c1143r.m691a("deinitialize", new Class[0]);
            Class cls = Boolean.TYPE;
            c1143r.m691a("load", new Class[]{cls, cls, cls, cls, cls, Runnable.class});
            c1143r.m691a("enable", new Class[]{Boolean.TYPE});
            c1143r.m691a("unload", new Class[0]);
            c1143r.m691a("pause", new Class[0]);
            c1143r.m691a("resume", new Class[0]);
            c1143r.m691a("getGvrLayout", new Class[0]);
            c1143r.m691a("getVideoSurfaceId", new Class[0]);
            c1143r.m691a("getVideoSurface", new Class[0]);
            this.f441a = c1143r;
            return true;
        } catch (Exception e) {
            reportError("Exception initializing GoogleVR from Unity library. " + e.getLocalizedMessage());
            return false;
        }
    }

    public boolean m455d() {
        return this.f224k.f241d;
    }

    private void m457e() {
        Activity activity = (Activity) this.f443c;
        if (!this.f220g || this.f224k.f243f || activity == null) {
            return;
        }
        this.f224k.f243f = true;
        Intent intent = new Intent("android.intent.action.MAIN");
        intent.addCategory("android.intent.category.HOME");
        intent.setFlags(268435456);
        activity.startActivity(intent);
    }

    private static boolean m458f() {
        return Build.VERSION.SDK_INT >= 24;
    }

    private final native void initVrJni();

    private final native boolean isQuiting();

    private final native void setVrVideoTransform(float[][] fArr);

    public final void m459a(Intent intent) {
        if (intent == null || !intent.getBooleanExtra("android.intent.extra.VR_LAUNCH", false)) {
            return;
        }
        this.f220g = true;
    }

    public final boolean m460a() {
        return this.f224k.f238a;
    }

    public final boolean m461a(Activity activity, Context context, SurfaceView surfaceView, Runnable runnable) {
        String str;
        boolean zBooleanValue;
        if (activity == null || context == null || surfaceView == null || runnable == null) {
            str = "Invalid parameters passed to Google VR initialization.";
        } else {
            this.f224k.m466b();
            this.f443c = context;
            this.f221h = runnable;
            if (this.f220g && !m458f()) {
                str = "Daydream requires a device that supports an api version of 24 (Nougat) or better.";
            } else {
                if (!m452a(UnityPlayer.class.getClassLoader())) {
                    return false;
                }
                try {
                    zBooleanValue = ((Boolean) this.f441a.m690a("initialize", activity, context, surfaceView, Boolean.valueOf(this.f220g), this.f226m)).booleanValue();
                } catch (Exception e) {
                    reportError("Exception while trying to initialize Unity Google VR Library. " + e.getLocalizedMessage());
                    zBooleanValue = false;
                }
                if (zBooleanValue) {
                    this.f223j = surfaceView;
                    this.f224k.f238a = true;
                    this.f224k.m464a("initialize");
                    this.f444d = "";
                    return true;
                }
                str = "Unable to initialize GoogleVR library.";
            }
        }
        reportError(str);
        return false;
    }

    public final void m462b() {
        resumeGvrLayout();
    }

    public final void m463c() {
        C1134i.Log(4, "GoogleVRProxy::onConfigurationChanged");
        SurfaceView surfaceView = this.f223j;
        if (surfaceView != null) {
            surfaceView.getHolder().setSizeFromLayout();
        }
    }

    @Override
    public void deregisterGoogleVrVideoListener(GoogleVrVideo.GoogleVrVideoCallbacks googleVrVideoCallbacks) {
        if (this.f222i.contains(googleVrVideoCallbacks)) {
            googleVrVideoCallbacks.onSurfaceUnavailable();
            this.f222i.remove(googleVrVideoCallbacks);
        }
    }

    protected Object getVideoSurface() {
        if (m455d() && !this.f224k.f242e) {
            try {
                return this.f441a.m690a("getVideoSurface", new Object[0]);
            } catch (Exception e) {
                reportError("Exception caught while Getting GoogleVR Video Surface. " + e.getLocalizedMessage());
            }
        }
        return null;
    }

    protected int getVideoSurfaceId() {
        if (m455d() && !this.f224k.f242e) {
            try {
                return ((Integer) this.f441a.m690a("getVideoSurfaceId", new Object[0])).intValue();
            } catch (Exception e) {
                reportError("Exception caught while getting Video Surface ID from GoogleVR. " + e.getLocalizedMessage());
            }
        }
        return -1;
    }

    protected long loadGoogleVr(final boolean z, final boolean z2, final boolean z3, final boolean z4, final boolean z5) {
        if (!this.f224k.f238a) {
            return 0L;
        }
        final AtomicLong atomicLong = new AtomicLong(0L);
        this.f444d = (z || z2) ? "Daydream" : "Cardboard";
        if (!runOnUiThreadWithSync(new Runnable() {
            @Override
            public final void run() {
                try {
                    atomicLong.set(((Long) GoogleVrProxy.this.f441a.m690a("load", Boolean.valueOf(z), Boolean.valueOf(z2), Boolean.valueOf(z3), Boolean.valueOf(z4), Boolean.valueOf(z5), GoogleVrProxy.this.f221h)).longValue());
                    GoogleVrProxy.this.f224k.f239b = true;
                } catch (Exception e) {
                    GoogleVrProxy.this.reportError("Exception caught while loading GoogleVR. " + e.getLocalizedMessage());
                    atomicLong.set(0L);
                }
            }
        }) || atomicLong.longValue() == 0) {
            reportError("Google VR had a fatal issue while loading. VR will not be available.");
        }
        this.f224k.m464a("loadGoogleVr");
        return atomicLong.longValue();
    }

    protected void pauseGvrLayout() {
        if (this.f224k.m465a() && !this.f224k.f242e) {
            if (m455d()) {
                Iterator it = this.f222i.iterator();
                while (it.hasNext()) {
                    ((GoogleVrVideo.GoogleVrVideoCallbacks) it.next()).onSurfaceUnavailable();
                }
            }
            if (this.f441a != null) {
                this.f441a.m690a("pause", new Object[0]);
            }
            this.f224k.f242e = true;
            this.f224k.m464a("pauseGvrLayout");
        }
    }

    @Override
    public void registerGoogleVrVideoListener(GoogleVrVideo.GoogleVrVideoCallbacks googleVrVideoCallbacks) {
        if (this.f222i.contains(googleVrVideoCallbacks)) {
            return;
        }
        this.f222i.add(googleVrVideoCallbacks);
        Surface surface = (Surface) getVideoSurface();
        if (surface != null) {
            googleVrVideoCallbacks.onSurfaceAvailable(surface);
        }
    }

    protected void resumeGvrLayout() {
        if (this.f224k.m465a() && this.f224k.f242e) {
            if (this.f441a != null) {
                this.f441a.m690a("resume", new Object[0]);
            }
            this.f224k.f242e = false;
            this.f224k.m464a("resumeGvrLayout");
        }
    }

    protected void setGoogleVrModeEnabled(final boolean z) {
        if (!this.f224k.m465a() || this.f442b == null || this.f443c == null) {
            return;
        }
        if (!z && isQuiting()) {
            m457e();
        }
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                if (z == GoogleVrProxy.this.m455d()) {
                    return;
                }
                try {
                    if (!z || GoogleVrProxy.this.m455d()) {
                        if (!z && GoogleVrProxy.this.m455d()) {
                            GoogleVrProxy.this.m451a(false);
                            if (GoogleVrProxy.this.f441a != null) {
                                GoogleVrProxy.this.f441a.m690a("enable", false);
                            }
                            if (GoogleVrProxy.this.f441a != null && GoogleVrProxy.this.f442b != null) {
                                GoogleVrProxy.this.f442b.removeViewFromPlayer((View) GoogleVrProxy.this.f441a.m690a("getGvrLayout", new Object[0]));
                            }
                        }
                    } else if (GoogleVrProxy.this.f441a != null && GoogleVrProxy.this.f442b != null && !GoogleVrProxy.this.f442b.addViewToPlayer((View) GoogleVrProxy.this.f441a.m690a("getGvrLayout", new Object[0]), true)) {
                        GoogleVrProxy.this.reportError("Unable to add Google VR to view hierarchy.");
                        return;
                    } else {
                        if (GoogleVrProxy.this.f441a != null) {
                            GoogleVrProxy.this.f441a.m690a("enable", true);
                        }
                        GoogleVrProxy.this.m451a(true);
                    }
                    GoogleVrProxy.this.f224k.m464a("Enable VR");
                } catch (Exception e) {
                    GoogleVrProxy.this.reportError("Exception enabling Google VR on UI Thread. " + e.getLocalizedMessage());
                }
            }
        });
    }

    @Override
    public void setVideoLocationTransform(float[] fArr) {
        float[][] fArr2 = (float[][]) Array.newInstance((Class<?>) Float.TYPE, 4, 4);
        for (int i = 0; i < 4; i++) {
            for (int i2 = 0; i2 < 4; i2++) {
                fArr2[i][i2] = fArr[(i * 4) + i2];
            }
        }
        setVrVideoTransform(fArr2);
    }

    protected void unloadGoogleVr() {
        if (this.f224k.f241d) {
            setGoogleVrModeEnabled(false);
        }
        if (this.f224k.f240c) {
            this.f224k.f240c = false;
        }
        this.f223j = null;
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                try {
                    if (GoogleVrProxy.this.f441a != null) {
                        GoogleVrProxy.this.f441a.m690a("unload", new Object[0]);
                        GoogleVrProxy.this.f441a.m690a("deinitialize", new Object[0]);
                        GoogleVrProxy.this.f441a = null;
                    }
                    GoogleVrProxy.this.f224k.f239b = false;
                    GoogleVrProxy.this.f224k.m464a("unloadGoogleVr");
                } catch (Exception e) {
                    GoogleVrProxy.this.reportError("Exception unloading Google VR on UI Thread. " + e.getLocalizedMessage());
                }
            }
        });
    }
}
