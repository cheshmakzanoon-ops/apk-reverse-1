package com.unity3d.player;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.res.Configuration;
import android.graphics.Rect;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;
import android.os.Process;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.TypedValue;
import android.view.InputEvent;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.OrientationEventListener;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import com.ishumei.smantifraud.l111l1111llIl;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

public class UnityPlayer extends FrameLayout implements IUnityPlayerLifecycleEvents, InterfaceC1133h {
    private static final int ANR_TIMEOUT_SECONDS = 4;
    private static final String LAUNCH_FULLSCREEN = "unity.launch-fullscreen";
    private static final int RUN_STATE_CHANGED_MSG_CODE = 2269;
    private static final String SPLASH_ENABLE_METADATA_NAME = "unity.splash-enable";
    private static final String SPLASH_MODE_METADATA_NAME = "unity.splash-mode";
    private static final String TANGO_ENABLE_METADATA_NAME = "unity.tango-enable";
    public static Activity currentActivity;
    private Context mContext;
    private SurfaceView mGlView;
    private int mInitialScreenOrientation;
    private boolean mIsFullscreen;
    private BroadcastReceiver mKillingIsMyBusiness;
    private boolean mMainDisplayOverride;
    private int mNaturalOrientation;
    private OrientationEventListener mOrientationListener;
    private boolean mProcessKillRequested;
    private boolean mQuitting;
    DialogC1139n mSoftInputDialog;
    private C1142q mState;
    private C1145t mVideoPlayerProxy;
    private GoogleARCoreApi m_ARCoreApi;
    private boolean m_AddPhoneCallListener;
    private AudioVolumeHandler m_AudioVolumeHandler;
    private Camera2Wrapper m_Camera2Wrapper;
    private ClipboardManager m_ClipboardManager;
    private final ConcurrentLinkedQueue m_Events;
    private C1118a m_FakeListener;
    private HFPStatus m_HFPStatus;
    C1122e m_MainThread;
    private NetworkConnectivity m_NetworkConnectivity;
    private C1137l m_PersistentUnitySurface;
    private C1120c m_PhoneCallListener;
    private C1140o m_SplashScreen;
    private TelephonyManager m_TelephonyManager;
    private IUnityPlayerLifecycleEvents m_UnityPlayerLifecycleEvents;
    private Uri m_launchUri;

    class C11022 extends BroadcastReceiver {
        C11022() {
        }

        @Override
        public void onReceive(Context context, Intent intent) {
            UnityPlayer.this.finish();
        }
    }

    class C1118a implements SensorEventListener {
        C1118a() {
        }

        @Override
        public final void onAccuracyChanged(Sensor sensor, int i) {
        }

        @Override
        public final void onSensorChanged(SensorEvent sensorEvent) {
        }
    }

    static final class EnumC1119b {

        public static final int f338a = 1;

        public static final int f339b = 2;

        public static final int f340c = 3;

        private static final int[] f341d = {1, 2, 3};
    }

    private class C1120c extends PhoneStateListener {
        private C1120c() {
        }

        C1120c(UnityPlayer unityPlayer, byte b) {
            this();
        }

        @Override
        public final void onCallStateChanged(int i, String str) {
            UnityPlayer.this.nativeMuteMasterAudio(i == 1);
        }
    }

    enum EnumC1121d {
        PAUSE,
        RESUME,
        QUIT,
        SURFACE_LOST,
        SURFACE_ACQUIRED,
        FOCUS_LOST,
        FOCUS_GAINED,
        NEXT_FRAME,
        URL_ACTIVATED,
        ORIENTATION_ANGLE_CHANGE
    }

    private class C1122e extends Thread {

        Handler f354a;

        boolean f355b;

        boolean f356c;

        int f357d;

        int f358e;

        int f359f;

        int f360g;

        int f361h;

        private C1122e() {
            this.f355b = false;
            this.f356c = false;
            this.f357d = EnumC1119b.f339b;
            this.f358e = 0;
            this.f361h = 5;
        }

        C1122e(UnityPlayer unityPlayer, byte b) {
            this();
        }

        private void m493a(EnumC1121d enumC1121d) {
            Handler handler = this.f354a;
            if (handler != null) {
                Message.obtain(handler, UnityPlayer.RUN_STATE_CHANGED_MSG_CODE, enumC1121d).sendToTarget();
            }
        }

        public final void m494a() {
            m493a(EnumC1121d.QUIT);
        }

        public final void m495a(int i, int i2) {
            this.f359f = i;
            this.f360g = i2;
            m493a(EnumC1121d.ORIENTATION_ANGLE_CHANGE);
        }

        public final void m496a(Runnable runnable) {
            if (this.f354a == null) {
                return;
            }
            m493a(EnumC1121d.PAUSE);
            Message.obtain(this.f354a, runnable).sendToTarget();
        }

        public final void m497b() {
            m493a(EnumC1121d.RESUME);
        }

        public final void m498b(Runnable runnable) {
            if (this.f354a == null) {
                return;
            }
            m493a(EnumC1121d.SURFACE_LOST);
            Message.obtain(this.f354a, runnable).sendToTarget();
        }

        public final void m499c() {
            m493a(EnumC1121d.FOCUS_GAINED);
        }

        public final void m500c(Runnable runnable) {
            Handler handler = this.f354a;
            if (handler == null) {
                return;
            }
            Message.obtain(handler, runnable).sendToTarget();
            m493a(EnumC1121d.SURFACE_ACQUIRED);
        }

        public final void m501d() {
            m493a(EnumC1121d.FOCUS_LOST);
        }

        public final void m502d(Runnable runnable) {
            Handler handler = this.f354a;
            if (handler != null) {
                Message.obtain(handler, runnable).sendToTarget();
            }
        }

        public final void m503e() {
            m493a(EnumC1121d.URL_ACTIVATED);
        }

        @Override
        public final void run() {
            setName("UnityMain");
            Looper.prepare();
            this.f354a = new Handler(new Handler.Callback() {
                private void m504a() {
                    if (C1122e.this.f357d == EnumC1119b.f340c && C1122e.this.f356c) {
                        UnityPlayer.this.nativeFocusChanged(true);
                        C1122e.this.f357d = EnumC1119b.f338a;
                    }
                }

                @Override
                public final boolean handleMessage(Message message) {
                    if (message.what != UnityPlayer.RUN_STATE_CHANGED_MSG_CODE) {
                        return false;
                    }
                    EnumC1121d enumC1121d = (EnumC1121d) message.obj;
                    if (enumC1121d == EnumC1121d.NEXT_FRAME) {
                        C1122e.this.f358e--;
                        UnityPlayer.this.executeGLThreadJobs();
                        if (!C1122e.this.f355b || !C1122e.this.f356c) {
                            return true;
                        }
                        if (C1122e.this.f361h >= 0) {
                            if (C1122e.this.f361h == 0 && UnityPlayer.this.getSplashEnabled()) {
                                UnityPlayer.this.DisableStaticSplashScreen();
                            }
                            C1122e.this.f361h--;
                        }
                        if (!UnityPlayer.this.isFinishing() && !UnityPlayer.this.nativeRender()) {
                            UnityPlayer.this.finish();
                        }
                    } else if (enumC1121d == EnumC1121d.QUIT) {
                        Looper.myLooper().quit();
                    } else if (enumC1121d == EnumC1121d.RESUME) {
                        C1122e.this.f355b = true;
                    } else if (enumC1121d == EnumC1121d.PAUSE) {
                        C1122e.this.f355b = false;
                    } else if (enumC1121d == EnumC1121d.SURFACE_LOST) {
                        C1122e.this.f356c = false;
                    } else {
                        if (enumC1121d == EnumC1121d.SURFACE_ACQUIRED) {
                            C1122e.this.f356c = true;
                        } else if (enumC1121d == EnumC1121d.FOCUS_LOST) {
                            if (C1122e.this.f357d == EnumC1119b.f338a) {
                                UnityPlayer.this.nativeFocusChanged(false);
                            }
                            C1122e.this.f357d = EnumC1119b.f339b;
                        } else if (enumC1121d == EnumC1121d.FOCUS_GAINED) {
                            C1122e.this.f357d = EnumC1119b.f340c;
                        } else if (enumC1121d == EnumC1121d.URL_ACTIVATED) {
                            UnityPlayer.this.nativeSetLaunchURL(UnityPlayer.this.getLaunchURL());
                        } else if (enumC1121d == EnumC1121d.ORIENTATION_ANGLE_CHANGE) {
                            UnityPlayer.this.nativeOrientationChanged(C1122e.this.f359f, C1122e.this.f360g);
                        }
                        m504a();
                    }
                    if (C1122e.this.f355b && C1122e.this.f358e <= 0) {
                        Message.obtain(C1122e.this.f354a, UnityPlayer.RUN_STATE_CHANGED_MSG_CODE, EnumC1121d.NEXT_FRAME).sendToTarget();
                        C1122e.this.f358e++;
                    }
                    return true;
                }
            });
            Looper.loop();
        }
    }

    private abstract class AbstractRunnableC1123f implements Runnable {
        private AbstractRunnableC1123f() {
        }

        AbstractRunnableC1123f(UnityPlayer unityPlayer, byte b) {
            this();
        }

        public abstract void mo491a();

        @Override
        public final void run() {
            if (UnityPlayer.this.isFinishing()) {
                return;
            }
            mo491a();
        }
    }

    static {
        new C1141p().m677a();
    }

    public UnityPlayer(Context context) {
        this(context, null);
    }

    public UnityPlayer(Context context, IUnityPlayerLifecycleEvents iUnityPlayerLifecycleEvents) {
        super(context);
        this.mInitialScreenOrientation = -1;
        byte b = 0;
        this.mMainDisplayOverride = false;
        this.mIsFullscreen = true;
        this.mState = new C1142q();
        this.m_Events = new ConcurrentLinkedQueue();
        this.mKillingIsMyBusiness = null;
        this.mOrientationListener = null;
        this.m_MainThread = new C1122e(this, b);
        this.m_AddPhoneCallListener = false;
        this.m_PhoneCallListener = new C1120c(this, b);
        this.m_ARCoreApi = null;
        this.m_FakeListener = new C1118a();
        this.m_Camera2Wrapper = null;
        this.m_HFPStatus = null;
        this.m_AudioVolumeHandler = null;
        this.m_launchUri = null;
        this.m_NetworkConnectivity = null;
        this.mProcessKillRequested = true;
        this.mSoftInputDialog = null;
        this.m_UnityPlayerLifecycleEvents = iUnityPlayerLifecycleEvents;
        if (context instanceof Activity) {
            Activity activity = (Activity) context;
            currentActivity = activity;
            this.mInitialScreenOrientation = activity.getRequestedOrientation();
            this.m_launchUri = currentActivity.getIntent().getData();
        }
        this.mContext = context;
        EarlyEnableFullScreenIfEnabled(currentActivity);
        this.mNaturalOrientation = getNaturalOrientation(getResources().getConfiguration().orientation);
        if (currentActivity != null && getSplashEnabled()) {
            C1140o c1140o = new C1140o(this.mContext, C1140o.a.m676a()[getSplashMode()]);
            this.m_SplashScreen = c1140o;
            addView(c1140o);
        }
        String strLoadNative = loadNative(this.mContext.getApplicationInfo());
        if (currentActivity != null) {
            this.m_PersistentUnitySurface = new C1137l(this.mContext);
        }
        if (!C1142q.m680c()) {
            C1134i.Log(6, "Your hardware does not support this application.");
            AlertDialog alertDialogCreate = new AlertDialog.Builder(this.mContext).setTitle("Failure to initialize!").setPositiveButton("OK", new DialogInterface.OnClickListener() {
                @Override
                public final void onClick(DialogInterface dialogInterface, int i) {
                    UnityPlayer.this.finish();
                }
            }).setMessage("Your hardware does not support this application.\n\n" + strLoadNative + "\n\n Press OK to quit.").create();
            alertDialogCreate.setCancelable(false);
            alertDialogCreate.show();
            return;
        }
        initJni(context);
        this.mState.m683c(true);
        SurfaceView surfaceViewCreateGlView = CreateGlView();
        this.mGlView = surfaceViewCreateGlView;
        surfaceViewCreateGlView.setContentDescription(GetGlViewContentDescription(context));
        addView(this.mGlView);
        bringChildToFront(this.m_SplashScreen);
        this.mQuitting = false;
        Context context2 = this.mContext;
        if (context2 instanceof Activity) {
            Window window = ((Activity) context2).getWindow();
            window.addFlags(2097152);
            window.addFlags(524288);
            window.addFlags(4194304);
        }
        hideStatusBar();
        this.m_TelephonyManager = (TelephonyManager) this.mContext.getSystemService("phone");
        this.m_ClipboardManager = (ClipboardManager) this.mContext.getSystemService("clipboard");
        this.m_Camera2Wrapper = new Camera2Wrapper(this.mContext);
        this.m_HFPStatus = new HFPStatus(this.mContext);
        this.m_MainThread.start();
    }

    public SurfaceView CreateGlView() {
        SurfaceView surfaceView = new SurfaceView(this.mContext);
        surfaceView.setId(this.mContext.getResources().getIdentifier("unitySurfaceView", "id", this.mContext.getPackageName()));
        if (IsWindowTranslucent()) {
            surfaceView.getHolder().setFormat(-3);
            surfaceView.setZOrderOnTop(true);
        } else {
            surfaceView.getHolder().setFormat(-1);
        }
        surfaceView.getHolder().addCallback(new SurfaceHolder.Callback() {
            @Override
            public final void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
                UnityPlayer.this.updateGLDisplay(0, surfaceHolder.getSurface());
                UnityPlayer.this.sendSurfaceChangedEvent();
            }

            @Override
            public final void surfaceCreated(SurfaceHolder surfaceHolder) {
                UnityPlayer.this.updateGLDisplay(0, surfaceHolder.getSurface());
                if (UnityPlayer.this.m_PersistentUnitySurface != null) {
                    UnityPlayer.this.m_PersistentUnitySurface.m574a(UnityPlayer.this);
                }
            }

            @Override
            public final void surfaceDestroyed(SurfaceHolder surfaceHolder) {
                if (UnityPlayer.this.m_PersistentUnitySurface != null) {
                    UnityPlayer.this.m_PersistentUnitySurface.m573a(UnityPlayer.this.mGlView);
                }
                UnityPlayer.this.updateGLDisplay(0, null);
            }
        });
        surfaceView.setFocusable(true);
        surfaceView.setFocusableInTouchMode(true);
        return surfaceView;
    }

    public void DisableStaticSplashScreen() {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                UnityPlayer unityPlayer = UnityPlayer.this;
                unityPlayer.removeView(unityPlayer.m_SplashScreen);
                UnityPlayer.this.m_SplashScreen = null;
            }
        });
    }

    private void EarlyEnableFullScreenIfEnabled(Activity activity) {
        View decorView;
        if (activity == null || activity.getWindow() == null) {
            return;
        }
        if ((getLaunchFullscreen() || activity.getIntent().getBooleanExtra("android.intent.extra.VR_LAUNCH", false)) && (decorView = activity.getWindow().getDecorView()) != null) {
            decorView.setSystemUiVisibility(7);
        }
    }

    private String GetGlViewContentDescription(Context context) {
        return context.getResources().getString(context.getResources().getIdentifier("game_view_content_description", "string", context.getPackageName()));
    }

    private boolean IsWindowTranslucent() {
        if (currentActivity == null) {
            return false;
        }
        TypedValue typedValue = new TypedValue();
        return currentActivity.getTheme().resolveAttribute(android.R.attr.windowIsTranslucent, typedValue, true) && typedValue.type == 18 && typedValue.data != 0;
    }

    public static void UnitySendMessage(String str, String str2, String str3) {
        if (C1142q.m680c()) {
            try {
                nativeUnitySendMessage(str, str2, str3.getBytes("UTF-8"));
                return;
            } catch (UnsupportedEncodingException unused) {
                return;
            }
        }
        C1134i.Log(5, "Native libraries not loaded - dropping message for " + str + "." + str2);
    }

    private void checkResumePlayer() {
        Activity activity = currentActivity;
        if (this.mState.m687e(activity != null ? MultiWindowSupport.getAllowResizableWindow(activity) : false)) {
            this.mState.m684d(true);
            queueGLThreadEvent(new Runnable() {
                @Override
                public final void run() {
                    UnityPlayer.this.nativeResume();
                    UnityPlayer.this.runOnUiThread(new Runnable() {
                        @Override
                        public final void run() {
                            if (UnityPlayer.this.m_PersistentUnitySurface != null) {
                                UnityPlayer.this.m_PersistentUnitySurface.m575b(UnityPlayer.this);
                            }
                        }
                    });
                }
            });
            this.m_MainThread.m497b();
        }
    }

    public void finish() {
        Context context = this.mContext;
        if (!(context instanceof Activity) || ((Activity) context).isFinishing()) {
            return;
        }
        ((Activity) this.mContext).finish();
    }

    private ApplicationInfo getApplicationInfo() {
        return this.mContext.getPackageManager().getApplicationInfo(this.mContext.getPackageName(), 128);
    }

    private boolean getLaunchFullscreen() {
        try {
            return getApplicationInfo().metaData.getBoolean(LAUNCH_FULLSCREEN);
        } catch (Exception unused) {
            return false;
        }
    }

    private int getNaturalOrientation(int i) {
        int rotation = ((WindowManager) this.mContext.getSystemService("window")).getDefaultDisplay().getRotation();
        if ((rotation == 0 || rotation == 2) && i == 2) {
            return 0;
        }
        return ((rotation == 1 || rotation == 3) && i == 1) ? 0 : 1;
    }

    private String getProcessName() {
        int iMyPid = Process.myPid();
        List<ActivityManager.RunningAppProcessInfo> runningAppProcesses = ((ActivityManager) this.mContext.getSystemService("activity")).getRunningAppProcesses();
        if (runningAppProcesses == null) {
            return null;
        }
        for (ActivityManager.RunningAppProcessInfo runningAppProcessInfo : runningAppProcesses) {
            if (runningAppProcessInfo.pid == iMyPid) {
                return runningAppProcessInfo.processName;
            }
        }
        return null;
    }

    public boolean getSplashEnabled() {
        try {
            return getApplicationInfo().metaData.getBoolean(SPLASH_ENABLE_METADATA_NAME);
        } catch (Exception unused) {
            return false;
        }
    }

    private boolean getTangoEnabled() {
        try {
            return getApplicationInfo().metaData.getBoolean(TANGO_ENABLE_METADATA_NAME);
        } catch (Exception unused) {
            return false;
        }
    }

    private void hideStatusBar() {
        Context context = this.mContext;
        if (context instanceof Activity) {
            ((Activity) context).getWindow().setFlags(1024, 1024);
        }
    }

    private final native void initJni(Context context);

    protected static boolean loadLibraryStatic(String str) {
        StringBuilder sb;
        try {
            System.loadLibrary(str);
            return true;
        } catch (Exception e) {
            sb = new StringBuilder("Unknown error ");
            sb.append(e);
            C1134i.Log(6, sb.toString());
            return false;
        } catch (UnsatisfiedLinkError unused) {
            sb = new StringBuilder("Unable to find ");
            sb.append(str);
            C1134i.Log(6, sb.toString());
            return false;
        }
    }

    private static String loadNative(ApplicationInfo applicationInfo) {
        String string;
        String str = applicationInfo.nativeLibraryDir + "/libmain.so";
        try {
            System.loadLibrary("main");
            if (NativeLoader.load(applicationInfo.nativeLibraryDir)) {
                C1142q.m678a();
                return "";
            }
            C1134i.Log(6, "NativeLoader.load failure, Unity libraries were not loaded.");
            return "NativeLoader.load failure, Unity libraries were not loaded.";
        } catch (SecurityException e) {
            string = e.toString();
            return logLoadLibMainError(str, string);
        } catch (UnsatisfiedLinkError e2) {
            string = e2.toString();
            return logLoadLibMainError(str, string);
        }
    }

    private static String logLoadLibMainError(String str, String str2) {
        String str3 = "Failed to load 'libmain.so'\n\n" + str2;
        C1134i.Log(6, str3);
        return str3;
    }

    private final native void nativeApplicationUnload();

    private final native boolean nativeDone();

    public final native void nativeFocusChanged(boolean z);

    private final native boolean nativeInjectEvent(InputEvent inputEvent);

    public final native boolean nativeIsAutorotationOn();

    public final native void nativeLowMemory();

    public final native void nativeMuteMasterAudio(boolean z);

    public final native void nativeOrientationChanged(int i, int i2);

    public final native boolean nativePause();

    public final native void nativeRecreateGfxState(int i, Surface surface);

    public final native boolean nativeRender();

    public final native void nativeReportKeyboardConfigChanged();

    private final native void nativeRestartActivityIndicator();

    public final native void nativeResume();

    public final native void nativeSendSurfaceChangedEvent();

    public final native void nativeSetInputArea(int i, int i2, int i3, int i4);

    public final native void nativeSetInputSelection(int i, int i2);

    public final native void nativeSetInputString(String str);

    public final native void nativeSetKeyboardIsVisible(boolean z);

    public final native void nativeSetLaunchURL(String str);

    public final native void nativeSoftInputCanceled();

    public final native void nativeSoftInputClosed();

    public final native void nativeSoftInputLostFocus();

    private static native void nativeUnitySendMessage(String str, String str2, byte[] bArr);

    private void pauseUnity() {
        reportSoftInputStr(null, 1, true);
        if (this.mState.m688f()) {
            if (C1142q.m680c()) {
                final Semaphore semaphore = new Semaphore(0);
                this.m_MainThread.m496a(isFinishing() ? new Runnable() {
                    @Override
                    public final void run() {
                        UnityPlayer.this.shutdown();
                        semaphore.release();
                    }
                } : new Runnable() {
                    @Override
                    public final void run() {
                        if (!UnityPlayer.this.nativePause()) {
                            semaphore.release();
                            return;
                        }
                        UnityPlayer.this.mQuitting = true;
                        UnityPlayer.this.shutdown();
                        semaphore.release(2);
                    }
                });
                try {
                    if (!semaphore.tryAcquire(4L, TimeUnit.SECONDS)) {
                        C1134i.Log(5, "Timeout while trying to pause the Unity Engine.");
                    }
                } catch (InterruptedException unused) {
                    C1134i.Log(5, "UI thread got interrupted while trying to pause the Unity Engine.");
                }
                if (semaphore.drainPermits() > 0) {
                    destroy();
                }
            }
            this.mState.m684d(false);
            this.mState.m682b(true);
            if (this.m_AddPhoneCallListener) {
                this.m_TelephonyManager.listen(this.m_PhoneCallListener, 0);
            }
        }
    }

    private void queueGLThreadEvent(AbstractRunnableC1123f abstractRunnableC1123f) {
        if (isFinishing()) {
            return;
        }
        queueGLThreadEvent((Runnable) abstractRunnableC1123f);
    }

    private void queueGLThreadEvent(Runnable runnable) {
        if (C1142q.m680c()) {
            if (Thread.currentThread() == this.m_MainThread) {
                runnable.run();
            } else {
                this.m_Events.add(runnable);
            }
        }
    }

    public void sendSurfaceChangedEvent() {
        if (C1142q.m680c() && this.mState.m686e()) {
            this.m_MainThread.m502d(new Runnable() {
                @Override
                public final void run() {
                    UnityPlayer.this.nativeSendSurfaceChangedEvent();
                }
            });
        }
    }

    public void shutdown() {
        this.mProcessKillRequested = nativeDone();
        this.mState.m683c(false);
    }

    private void swapViews(View view, View view2) {
        boolean z;
        if (this.mState.m685d()) {
            z = false;
        } else {
            pause();
            z = true;
        }
        if (view != null) {
            ViewParent parent = view.getParent();
            if (!(parent instanceof UnityPlayer) || ((UnityPlayer) parent) != this) {
                if (parent instanceof ViewGroup) {
                    ((ViewGroup) parent).removeView(view);
                }
                addView(view);
                bringChildToFront(view);
                view.setVisibility(0);
            }
        }
        if (view2 != null && view2.getParent() == this) {
            view2.setVisibility(8);
            removeView(view2);
        }
        if (z) {
            resume();
        }
    }

    private static void unloadNative() {
        if (C1142q.m680c()) {
            if (!NativeLoader.unload()) {
                throw new UnsatisfiedLinkError("Unable to unload libraries from libmain.so");
            }
            C1142q.m679b();
        }
    }

    private boolean updateDisplayInternal(final int i, final Surface surface) {
        if (!C1142q.m680c() || !this.mState.m686e()) {
            return false;
        }
        final Semaphore semaphore = new Semaphore(0);
        Runnable runnable = new Runnable() {
            @Override
            public final void run() {
                UnityPlayer.this.nativeRecreateGfxState(i, surface);
                semaphore.release();
            }
        };
        if (i == 0) {
            C1122e c1122e = this.m_MainThread;
            if (surface == null) {
                c1122e.m498b(runnable);
            } else {
                c1122e.m500c(runnable);
            }
        } else {
            runnable.run();
        }
        if (surface != null || i != 0) {
            return true;
        }
        try {
            if (semaphore.tryAcquire(4L, TimeUnit.SECONDS)) {
                return true;
            }
            C1134i.Log(5, "Timeout while trying detaching primary window.");
            return true;
        } catch (InterruptedException unused) {
            C1134i.Log(5, "UI thread got interrupted while trying to detach the primary window from the Unity Engine.");
            return true;
        }
    }

    public void updateGLDisplay(int i, Surface surface) {
        if (this.mMainDisplayOverride) {
            return;
        }
        updateDisplayInternal(i, surface);
    }

    protected void addPhoneCallListener() {
        this.m_AddPhoneCallListener = true;
        this.m_TelephonyManager.listen(this.m_PhoneCallListener, 32);
    }

    @Override
    public boolean addViewToPlayer(View view, boolean z) {
        swapViews(view, z ? this.mGlView : null);
        boolean z2 = true;
        boolean z3 = view.getParent() == this;
        boolean z4 = z && this.mGlView.getParent() == null;
        boolean z5 = this.mGlView.getParent() == this;
        if (!z3 || (!z4 && !z5)) {
            z2 = false;
        }
        if (!z2) {
            if (!z3) {
                C1134i.Log(6, "addViewToPlayer: Failure adding view to hierarchy");
            }
            if (!z4 && !z5) {
                C1134i.Log(6, "addViewToPlayer: Failure removing old view from hierarchy");
            }
        }
        return z2;
    }

    public void configurationChanged(Configuration configuration) {
        C1134i.Log(4, "onConfigurationChanged");
        SurfaceView surfaceView = this.mGlView;
        if (surfaceView instanceof SurfaceView) {
            surfaceView.getHolder().setSizeFromLayout();
        }
        C1145t c1145t = this.mVideoPlayerProxy;
        if (c1145t != null) {
            c1145t.m715c();
        }
        GoogleVrProxy googleVrProxyM448b = GoogleVrApi.m448b();
        if (googleVrProxyM448b != null) {
            googleVrProxyM448b.m463c();
        }
    }

    public void destroy() {
        C1134i.Log(4, "onDestroy");
        if (GoogleVrApi.m448b() != null) {
            GoogleVrApi.m446a();
        }
        C1137l c1137l = this.m_PersistentUnitySurface;
        if (c1137l != null) {
            c1137l.m572a();
            this.m_PersistentUnitySurface = null;
        }
        Camera2Wrapper camera2Wrapper = this.m_Camera2Wrapper;
        if (camera2Wrapper != null) {
            camera2Wrapper.m443a();
            this.m_Camera2Wrapper = null;
        }
        HFPStatus hFPStatus = this.m_HFPStatus;
        if (hFPStatus != null) {
            hFPStatus.m473a();
            this.m_HFPStatus = null;
        }
        NetworkConnectivity networkConnectivity = this.m_NetworkConnectivity;
        if (networkConnectivity != null) {
            networkConnectivity.m476b();
            this.m_NetworkConnectivity = null;
        }
        this.mQuitting = true;
        if (!this.mState.m685d()) {
            pause();
        }
        this.m_MainThread.m494a();
        try {
            this.m_MainThread.join(4000L);
        } catch (InterruptedException unused) {
            this.m_MainThread.interrupt();
        }
        BroadcastReceiver broadcastReceiver = this.mKillingIsMyBusiness;
        if (broadcastReceiver != null) {
            this.mContext.unregisterReceiver(broadcastReceiver);
        }
        this.mKillingIsMyBusiness = null;
        if (C1142q.m680c()) {
            removeAllViews();
        }
        if (this.mProcessKillRequested) {
            IUnityPlayerLifecycleEvents iUnityPlayerLifecycleEvents = this.m_UnityPlayerLifecycleEvents;
            if (iUnityPlayerLifecycleEvents != null) {
                iUnityPlayerLifecycleEvents.onUnityPlayerQuitted();
            } else {
                onUnityPlayerQuitted();
            }
            kill();
        }
        unloadNative();
    }

    protected void disableLogger() {
        C1134i.f449a = true;
    }

    public boolean displayChanged(int i, Surface surface) {
        if (i == 0) {
            this.mMainDisplayOverride = surface != null;
            runOnUiThread(new Runnable() {
                @Override
                public final void run() {
                    if (UnityPlayer.this.mMainDisplayOverride) {
                        UnityPlayer unityPlayer = UnityPlayer.this;
                        unityPlayer.removeView(unityPlayer.mGlView);
                    } else {
                        UnityPlayer unityPlayer2 = UnityPlayer.this;
                        unityPlayer2.addView(unityPlayer2.mGlView);
                    }
                }
            });
        }
        return updateDisplayInternal(i, surface);
    }

    protected void executeGLThreadJobs() {
        while (true) {
            Runnable runnable = (Runnable) this.m_Events.poll();
            if (runnable == null) {
                return;
            } else {
                runnable.run();
            }
        }
    }

    protected String getClipboardText() {
        ClipData primaryClip = this.m_ClipboardManager.getPrimaryClip();
        return primaryClip != null ? primaryClip.getItemAt(0).coerceToText(this.mContext).toString() : "";
    }

    protected String getKeyboardLayout() {
        DialogC1139n dialogC1139n = this.mSoftInputDialog;
        if (dialogC1139n == null) {
            return null;
        }
        return dialogC1139n.m671a();
    }

    protected String getLaunchURL() {
        Uri uri = this.m_launchUri;
        if (uri != null) {
            return uri.toString();
        }
        return null;
    }

    protected int getNetworkConnectivity() {
        if (!C1138m.f457c) {
            return 0;
        }
        if (this.m_NetworkConnectivity == null) {
            this.m_NetworkConnectivity = new NetworkConnectivity(this.mContext);
        }
        return this.m_NetworkConnectivity.m475a();
    }

    public String getNetworkProxySettings(String str) {
        String str2;
        String str3;
        if (!str.startsWith("http:")) {
            if (str.startsWith("https:")) {
                str2 = "https.proxyHost";
                str3 = "https.proxyPort";
            }
            return null;
        }
        str2 = "http.proxyHost";
        str3 = "http.proxyPort";
        String property = System.getProperties().getProperty(str2);
        if (property != null && !"".equals(property)) {
            StringBuilder sb = new StringBuilder(property);
            String property2 = System.getProperties().getProperty(str3);
            if (property2 != null && !"".equals(property2)) {
                sb.append(":");
                sb.append(property2);
            }
            String property3 = System.getProperties().getProperty("http.nonProxyHosts");
            if (property3 != null && !"".equals(property3)) {
                sb.append('\n');
                sb.append(property3);
            }
            return sb.toString();
        }
        return null;
    }

    public Bundle getSettings() {
        return Bundle.EMPTY;
    }

    protected int getSplashMode() {
        try {
            return getApplicationInfo().metaData.getInt(SPLASH_MODE_METADATA_NAME);
        } catch (Exception unused) {
            return 0;
        }
    }

    protected int getUaaLLaunchProcessType() {
        String processName = getProcessName();
        return (processName == null || processName.equals(this.mContext.getPackageName())) ? 0 : 1;
    }

    public View getView() {
        return this;
    }

    protected void hideSoftInput() {
        postOnUiThread(new Runnable() {
            @Override
            public final void run() {
                UnityPlayer.this.reportSoftInputArea(new Rect());
                UnityPlayer.this.reportSoftInputIsVisible(false);
                if (UnityPlayer.this.mSoftInputDialog != null) {
                    UnityPlayer.this.mSoftInputDialog.dismiss();
                    UnityPlayer.this.mSoftInputDialog = null;
                    UnityPlayer.this.nativeReportKeyboardConfigChanged();
                }
            }
        });
    }

    public void init(int i, boolean z) {
    }

    protected boolean initializeGoogleAr() {
        if (this.m_ARCoreApi != null || currentActivity == null || !getTangoEnabled()) {
            return false;
        }
        GoogleARCoreApi googleARCoreApi = new GoogleARCoreApi();
        this.m_ARCoreApi = googleARCoreApi;
        googleARCoreApi.initializeARCore(currentActivity);
        if (this.mState.m685d()) {
            return false;
        }
        this.m_ARCoreApi.resumeARCore();
        return false;
    }

    protected boolean initializeGoogleVr() {
        final GoogleVrProxy googleVrProxyM448b = GoogleVrApi.m448b();
        if (googleVrProxyM448b == null) {
            GoogleVrApi.m447a(this);
            googleVrProxyM448b = GoogleVrApi.m448b();
            if (googleVrProxyM448b == null) {
                C1134i.Log(6, "Unable to create Google VR subsystem.");
                return false;
            }
        }
        final Semaphore semaphore = new Semaphore(0);
        final Runnable runnable = new Runnable() {
            @Override
            public final void run() {
                UnityPlayer.this.injectEvent(new KeyEvent(0, 4));
                UnityPlayer.this.injectEvent(new KeyEvent(1, 4));
            }
        };
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                if (!googleVrProxyM448b.m461a(UnityPlayer.currentActivity, UnityPlayer.this.mContext, UnityPlayer.this.CreateGlView(), runnable)) {
                    C1134i.Log(6, "Unable to initialize Google VR subsystem.");
                }
                if (UnityPlayer.currentActivity != null) {
                    googleVrProxyM448b.m459a(UnityPlayer.currentActivity.getIntent());
                }
                semaphore.release();
            }
        });
        try {
            if (semaphore.tryAcquire(4L, TimeUnit.SECONDS)) {
                return googleVrProxyM448b.m460a();
            }
            C1134i.Log(5, "Timeout while trying to initialize Google VR.");
            return false;
        } catch (InterruptedException e) {
            C1134i.Log(5, "UI thread was interrupted while initializing Google VR. " + e.getLocalizedMessage());
            return false;
        }
    }

    public boolean injectEvent(InputEvent inputEvent) {
        if (C1142q.m680c()) {
            return nativeInjectEvent(inputEvent);
        }
        return false;
    }

    protected boolean isFinishing() {
        if (!this.mQuitting) {
            Context context = this.mContext;
            boolean z = (context instanceof Activity) && ((Activity) context).isFinishing();
            this.mQuitting = z;
            if (!z) {
                return false;
            }
        }
        return true;
    }

    protected boolean isUaaLUseCase() {
        String callingPackage = ((Activity) this.mContext).getCallingPackage();
        return callingPackage != null && callingPackage.equals(this.mContext.getPackageName());
    }

    protected void kill() {
        Process.killProcess(Process.myPid());
    }

    protected boolean loadLibrary(String str) {
        return loadLibraryStatic(str);
    }

    public void lowMemory() {
        if (C1142q.m680c()) {
            queueGLThreadEvent(new Runnable() {
                @Override
                public final void run() {
                    UnityPlayer.this.nativeLowMemory();
                }
            });
        }
    }

    public void newIntent(Intent intent) {
        C1134i.Log(4, "onNewIntent");
        this.m_launchUri = intent.getData();
        this.m_MainThread.m503e();
    }

    protected void notifyOnUnityPlayerUnloaded() {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                UnityPlayer.this.pause();
                UnityPlayer.this.windowFocusChanged(false);
                if (UnityPlayer.this.m_UnityPlayerLifecycleEvents != null) {
                    UnityPlayer.this.m_UnityPlayerLifecycleEvents.onUnityPlayerUnloaded();
                } else {
                    UnityPlayer.this.onUnityPlayerUnloaded();
                }
            }
        });
    }

    @Override
    public boolean onGenericMotionEvent(MotionEvent motionEvent) {
        return injectEvent(motionEvent);
    }

    @Override
    public boolean onKeyDown(int i, KeyEvent keyEvent) {
        return injectEvent(keyEvent);
    }

    @Override
    public boolean onKeyLongPress(int i, KeyEvent keyEvent) {
        return injectEvent(keyEvent);
    }

    @Override
    public boolean onKeyMultiple(int i, int i2, KeyEvent keyEvent) {
        return injectEvent(keyEvent);
    }

    @Override
    public boolean onKeyUp(int i, KeyEvent keyEvent) {
        return injectEvent(keyEvent);
    }

    @Override
    public boolean onTouchEvent(MotionEvent motionEvent) {
        return injectEvent(motionEvent);
    }

    @Override
    public void onUnityPlayerQuitted() {
        C1134i.Log(4, "onUnityPlayerQuitted, pass IUnityPlayerLifecycleEvents to UnityPlayer constructor or override this method in child class");
    }

    @Override
    public void onUnityPlayerUnloaded() {
        C1134i.Log(4, "onUnityPlayerUnloaded, pass IUnityPlayerLifecycleEvents to UnityPlayer constructor or override this method in child class");
    }

    public void pause() {
        C1134i.Log(4, "onPause");
        GoogleARCoreApi googleARCoreApi = this.m_ARCoreApi;
        if (googleARCoreApi != null) {
            googleARCoreApi.pauseARCore();
        }
        C1145t c1145t = this.mVideoPlayerProxy;
        if (c1145t != null) {
            c1145t.m712a();
        }
        GoogleVrProxy googleVrProxyM448b = GoogleVrApi.m448b();
        if (googleVrProxyM448b != null) {
            googleVrProxyM448b.pauseGvrLayout();
        }
        AudioVolumeHandler audioVolumeHandler = this.m_AudioVolumeHandler;
        if (audioVolumeHandler != null) {
            audioVolumeHandler.m441a();
            this.m_AudioVolumeHandler = null;
        }
        pauseUnity();
    }

    void postOnUiThread(Runnable runnable) {
        new Handler(Looper.getMainLooper()).post(runnable);
    }

    public void quit() {
        destroy();
    }

    @Override
    public void removeViewFromPlayer(View view) {
        swapViews(this.mGlView, view);
        boolean z = view.getParent() == null;
        boolean z2 = this.mGlView.getParent() == this;
        if (z && z2) {
            return;
        }
        if (!z) {
            C1134i.Log(6, "removeViewFromPlayer: Failure removing view from hierarchy");
        }
        if (z2) {
            return;
        }
        C1134i.Log(6, "removeVireFromPlayer: Failure agging old view to hierarchy");
    }

    @Override
    public void reportError(String str, String str2) {
        C1134i.Log(6, str + ": " + str2);
    }

    protected void reportSoftInputArea(final Rect rect) {
        queueGLThreadEvent(new AbstractRunnableC1123f() {
            {
                super(UnityPlayer.this, (byte) 0);
            }

            @Override
            public final void mo491a() {
                UnityPlayer.this.nativeSetInputArea(rect.left, rect.top, rect.right, rect.bottom);
            }
        });
    }

    protected void reportSoftInputIsVisible(final boolean z) {
        queueGLThreadEvent(new AbstractRunnableC1123f() {
            {
                super(UnityPlayer.this, (byte) 0);
            }

            @Override
            public final void mo491a() {
                UnityPlayer.this.nativeSetKeyboardIsVisible(z);
            }
        });
    }

    protected void reportSoftInputSelection(final int i, final int i2) {
        queueGLThreadEvent(new AbstractRunnableC1123f() {
            {
                super(UnityPlayer.this, (byte) 0);
            }

            @Override
            public final void mo491a() {
                UnityPlayer.this.nativeSetInputSelection(i, i2);
            }
        });
    }

    protected void reportSoftInputStr(final String str, final int i, final boolean z) {
        if (i == 1) {
            hideSoftInput();
        }
        queueGLThreadEvent(new AbstractRunnableC1123f() {
            {
                super(UnityPlayer.this, (byte) 0);
            }

            @Override
            public final void mo491a() {
                if (z) {
                    UnityPlayer.this.nativeSoftInputCanceled();
                } else {
                    String str2 = str;
                    if (str2 != null) {
                        UnityPlayer.this.nativeSetInputString(str2);
                    }
                }
                if (i == 1) {
                    UnityPlayer.this.nativeSoftInputClosed();
                }
            }
        });
    }

    protected void requestUserAuthorization(String str) {
        if (!C1138m.f456b || str == null || str.isEmpty() || currentActivity == null) {
            return;
        }
        C1138m.f458d.mo569a(currentActivity, str);
    }

    public void resume() {
        C1134i.Log(4, "onResume");
        GoogleARCoreApi googleARCoreApi = this.m_ARCoreApi;
        if (googleARCoreApi != null) {
            googleARCoreApi.resumeARCore();
        }
        this.mState.m682b(false);
        C1145t c1145t = this.mVideoPlayerProxy;
        if (c1145t != null) {
            c1145t.m714b();
        }
        checkResumePlayer();
        if (C1142q.m680c()) {
            nativeRestartActivityIndicator();
        }
        GoogleVrProxy googleVrProxyM448b = GoogleVrApi.m448b();
        if (googleVrProxyM448b != null) {
            googleVrProxyM448b.m462b();
        }
        if (this.m_AudioVolumeHandler == null) {
            this.m_AudioVolumeHandler = new AudioVolumeHandler(this.mContext);
        }
    }

    void runOnAnonymousThread(Runnable runnable) {
        new Thread(runnable).start();
    }

    void runOnUiThread(Runnable runnable) {
        Context context = this.mContext;
        if (context instanceof Activity) {
            ((Activity) context).runOnUiThread(runnable);
        } else {
            C1134i.Log(5, "Not running Unity from an Activity; ignored...");
        }
    }

    protected void setCharacterLimit(final int i) {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                if (UnityPlayer.this.mSoftInputDialog != null) {
                    UnityPlayer.this.mSoftInputDialog.m672a(i);
                }
            }
        });
    }

    protected void setClipboardText(String str) {
        this.m_ClipboardManager.setPrimaryClip(ClipData.newPlainText("Text", str));
    }

    protected void setHideInputField(final boolean z) {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                if (UnityPlayer.this.mSoftInputDialog != null) {
                    UnityPlayer.this.mSoftInputDialog.m675a(z);
                }
            }
        });
    }

    protected void setSelection(final int i, final int i2) {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                if (UnityPlayer.this.mSoftInputDialog != null) {
                    UnityPlayer.this.mSoftInputDialog.m673a(i, i2);
                }
            }
        });
    }

    protected void setSoftInputStr(final String str) {
        runOnUiThread(new Runnable() {
            @Override
            public final void run() {
                if (UnityPlayer.this.mSoftInputDialog == null || str == null) {
                    return;
                }
                UnityPlayer.this.mSoftInputDialog.m674a(str);
            }
        });
    }

    protected void showSoftInput(final String str, final int i, final boolean z, final boolean z2, final boolean z3, final boolean z4, final String str2, final int i2, final boolean z5, final boolean z6) {
        postOnUiThread(new Runnable() {
            @Override
            public final void run() {
                UnityPlayer.this.mSoftInputDialog = new DialogC1139n(UnityPlayer.this.mContext, this, str, i, z, z2, z3, str2, i2, z5, z6);
                UnityPlayer.this.mSoftInputDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
                    @Override
                    public final void onCancel(DialogInterface dialogInterface) {
                        UnityPlayer.this.nativeSoftInputLostFocus();
                        UnityPlayer.this.reportSoftInputStr(null, 1, false);
                    }
                });
                UnityPlayer.this.mSoftInputDialog.show();
                UnityPlayer.this.nativeReportKeyboardConfigChanged();
            }
        });
    }

    protected boolean showVideoPlayer(String str, int i, int i2, int i3, boolean z, int i4, int i5) {
        if (this.mVideoPlayerProxy == null) {
            this.mVideoPlayerProxy = new C1145t(this);
        }
        boolean zM713a = this.mVideoPlayerProxy.m713a(this.mContext, str, i, i2, i3, z, i4, i5, new C1145t.a() {
            @Override
            public final void mo492a() {
                UnityPlayer.this.mVideoPlayerProxy = null;
            }
        });
        if (zM713a) {
            runOnUiThread(new Runnable() {
                @Override
                public final void run() {
                    if (UnityPlayer.this.nativeIsAutorotationOn() && (UnityPlayer.this.mContext instanceof Activity)) {
                        ((Activity) UnityPlayer.this.mContext).setRequestedOrientation(UnityPlayer.this.mInitialScreenOrientation);
                    }
                }
            });
        }
        return zM713a;
    }

    protected boolean skipPermissionsDialog() {
        if (!C1138m.f456b || currentActivity == null) {
            return false;
        }
        return C1138m.f458d.mo570a(currentActivity);
    }

    public boolean startOrientationListener(int i) {
        String str;
        if (this.mOrientationListener != null) {
            str = "Orientation Listener already started.";
        } else {
            OrientationEventListener orientationEventListener = new OrientationEventListener(this.mContext, i) {
                @Override
                public final void onOrientationChanged(int i2) {
                    UnityPlayer.this.m_MainThread.m495a(UnityPlayer.this.mNaturalOrientation, i2);
                }
            };
            this.mOrientationListener = orientationEventListener;
            if (orientationEventListener.canDetectOrientation()) {
                this.mOrientationListener.enable();
                return true;
            }
            str = "Orientation Listener cannot detect orientation.";
        }
        C1134i.Log(5, str);
        return false;
    }

    public boolean stopOrientationListener() {
        OrientationEventListener orientationEventListener = this.mOrientationListener;
        if (orientationEventListener == null) {
            C1134i.Log(5, "Orientation Listener was not started.");
            return false;
        }
        orientationEventListener.disable();
        this.mOrientationListener = null;
        return true;
    }

    protected void toggleGyroscopeSensor(boolean z) {
        SensorManager sensorManager = (SensorManager) this.mContext.getSystemService(l111l1111llIl.l11l111ll11l);
        Sensor defaultSensor = sensorManager.getDefaultSensor(11);
        if (z) {
            sensorManager.registerListener(this.m_FakeListener, defaultSensor, 1);
        } else {
            sensorManager.unregisterListener(this.m_FakeListener);
        }
    }

    public void unload() {
        nativeApplicationUnload();
    }

    public void windowFocusChanged(boolean z) {
        C1134i.Log(4, "windowFocusChanged: " + z);
        this.mState.m681a(z);
        if (this.mState.m686e()) {
            DialogC1139n dialogC1139n = this.mSoftInputDialog;
            if (dialogC1139n == null || dialogC1139n.f461a) {
                if (z) {
                    this.m_MainThread.m499c();
                } else {
                    this.m_MainThread.m501d();
                }
                checkResumePlayer();
            }
        }
    }
}
