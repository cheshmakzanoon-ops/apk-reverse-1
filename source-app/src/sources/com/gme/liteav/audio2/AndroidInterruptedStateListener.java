package com.gme.liteav.audio2;

import android.media.AudioManager;
import android.media.AudioRecordingConfiguration;
import android.os.Build;
import cn.thinkingdata.android.j$$ExternalSyntheticApiModelOutline0;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.ThreadUtils;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.lang.reflect.Proxy;
import java.util.List;
import java.util.concurrent.Executor;

@JNINamespace("liteav::audio")
public class AndroidInterruptedStateListener implements C0991d.a, C0992e.b {
    private static final int RECORDING_CONFIGS_LIMIT = 10;
    public static final String TAG = "AndroidInterruptedStateListener";
    private static C0991d mRecordingCallback;
    private final long mNativeRecordingConfigListener;
    private volatile boolean mNeedNotify = false;
    private Object mObject = new Object();
    private C0992e mPhoneStateManager;

    private static native void nativeNotifyAudioRecordingConfigChangedFromJava(long j, RecordingConfig[] recordingConfigArr);

    private static native void nativeNotifyInterruptedByPhoneCallFromJava(long j);

    private static native void nativeNotifyResumedByPhoneCallFromJava(long j);

    static {
        if (Build.VERSION.SDK_INT >= 24) {
            mRecordingCallback = new C0991d();
        }
    }

    public AndroidInterruptedStateListener(long j) {
        this.mNativeRecordingConfigListener = j;
        Log.m947d(TAG, "new AndroidInterruptedStateListener" + hashCode(), new Object[0]);
    }

    public void registerAudioRecordingCallback() {
        if (LiteavSystemInfo.getSystemOSVersionInt() < 24) {
            return;
        }
        C0991d c0991d = mRecordingCallback;
        if (c0991d != null) {
            c0991d.f576a = this;
        }
        ThreadUtils.getUiThreadHandler().post(RunnableC0988a.m920a(this));
        this.mNeedNotify = true;
    }

    static void lambda$registerAudioRecordingCallback$0(AndroidInterruptedStateListener androidInterruptedStateListener) {
        if (androidInterruptedStateListener.mPhoneStateManager == null) {
            androidInterruptedStateListener.mPhoneStateManager = new C0992e(androidInterruptedStateListener);
        }
        C0992e c0992e = androidInterruptedStateListener.mPhoneStateManager;
        if (!C0992e.m927b()) {
            if (Build.VERSION.SDK_INT >= 31) {
                try {
                    if (c0992e.f580d == null) {
                        c0992e.f580d = Class.forName("android.media.AudioManager$OnModeChangedListener");
                    }
                    if (c0992e.f581e == null) {
                        c0992e.f581e = Proxy.newProxyInstance(c0992e.f580d.getClassLoader(), new Class[]{c0992e.f580d}, new C0992e.a(c0992e));
                    }
                    AudioManager.class.getMethod("addOnModeChangedListener", Executor.class, c0992e.f580d).invoke(c0992e.f579b, ExecutorC0995h.m934a(c0992e), c0992e.f581e);
                } catch (Throwable th) {
                    Log.m948e("PhoneStateManager", "add mode changed listener failed, " + th.getMessage(), new Object[0]);
                }
            } else if (Build.VERSION.SDK_INT >= 26 && C0992e.f577c != null) {
                Log.m949i("PhoneStateManager", "register audio playback callback.", new Object[0]);
                C0992e.f577c.f575a = c0992e;
            }
        } else {
            try {
                if (c0992e.f578a != null) {
                    c0992e.f578a.listen(c0992e, 32);
                } else {
                    Log.m951w("PhoneStateManager", "TelephonyManager is null, start listen phone state failed.", new Object[0]);
                }
            } catch (Throwable th2) {
                Log.m948e("PhoneStateManager", "start listen phone state failed, " + th2.getMessage(), new Object[0]);
            }
        }
        c0992e.f582f.m1023a(RunnableC0993f.m932a(c0992e));
    }

    public void unregisterAudioRecordingCallback() {
        if (LiteavSystemInfo.getSystemOSVersionInt() >= 24 && mRecordingCallback != null) {
            synchronized (this.mObject) {
                this.mNeedNotify = false;
                mRecordingCallback.f576a = null;
                ThreadUtils.getUiThreadHandler().post(RunnableC0989b.m921a(this));
            }
        }
    }

    static void lambda$unregisterAudioRecordingCallback$1(AndroidInterruptedStateListener androidInterruptedStateListener) {
        C0992e c0992e = androidInterruptedStateListener.mPhoneStateManager;
        if (c0992e != null) {
            if (!C0992e.m927b()) {
                if (Build.VERSION.SDK_INT < 31) {
                    C0992e.m929c();
                    return;
                }
                try {
                    if (c0992e.f580d == null || c0992e.f581e == null) {
                        return;
                    }
                    AudioManager.class.getMethod("removeOnModeChangedListener", c0992e.f580d).invoke(c0992e.f579b, c0992e.f581e);
                    return;
                } catch (Throwable th) {
                    Log.m948e("PhoneStateManager", "remove mode changed listener failed, " + th.getMessage(), new Object[0]);
                    return;
                }
            }
            try {
                if (c0992e.f578a != null) {
                    c0992e.f578a.listen(c0992e, 0);
                }
                c0992e.f583g = 0;
            } catch (Throwable th2) {
                Log.m948e("PhoneStateManager", "stop listen phone state failed, " + th2.getMessage(), new Object[0]);
            }
        }
    }

    @Override
    public void OnRecordingConfigChanged(List<AudioRecordingConfiguration> list) {
        if (list == null) {
            return;
        }
        int iMin = Math.min(list.size(), 10);
        RecordingConfig[] recordingConfigArr = new RecordingConfig[iMin];
        for (int i = 0; i < iMin; i++) {
            recordingConfigArr[i] = new RecordingConfig();
            AudioRecordingConfiguration audioRecordingConfigurationM582m = j$$ExternalSyntheticApiModelOutline0.m582m((Object) list.get(i));
            recordingConfigArr[i].f569a = audioRecordingConfigurationM582m.getClientAudioSessionId();
            if (LiteavSystemInfo.getSystemOSVersionInt() >= 29) {
                if (Build.VERSION.SDK_INT >= 29) {
                    recordingConfigArr[i].f570b = audioRecordingConfigurationM582m.isClientSilenced();
                }
            } else {
                recordingConfigArr[i].f570b = false;
            }
        }
        synchronized (this.mObject) {
            if (this.mNeedNotify) {
                nativeNotifyAudioRecordingConfigChangedFromJava(this.mNativeRecordingConfigListener, recordingConfigArr);
            }
        }
    }

    @Override
    public void onInterruptedByPhoneCall() {
        synchronized (this.mObject) {
            if (this.mNeedNotify) {
                nativeNotifyInterruptedByPhoneCallFromJava(this.mNativeRecordingConfigListener);
            }
        }
    }

    @Override
    public void onResumedByPhoneCall() {
        synchronized (this.mObject) {
            if (this.mNeedNotify) {
                nativeNotifyResumedByPhoneCallFromJava(this.mNativeRecordingConfigListener);
            }
        }
    }

    static class RecordingConfig {

        int f569a = 0;

        boolean f570b = false;

        public int getSessionId() {
            return this.f569a;
        }

        public boolean isSilenced() {
            return this.f570b;
        }
    }
}
