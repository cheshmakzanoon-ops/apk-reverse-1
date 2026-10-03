package com.gme.trtc.hardwareearmonitor.daisy;

import android.content.Context;
import android.media.AudioManager;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.util.C1055g;
import java.util.List;

@JNINamespace("liteav::extensions")
public class HardwareEarMonitorDaisy implements IDaisyAudioKitCallback {
    private static final String TAG = "HardwareEarMonitorDaisy";
    private DaisyAudioKit mDaisyAudioKit;
    private DaisyAudioKaraokeFeatureKit mDaisyKaraokeKit;
    private long mNativeHardwareEarMonitorHandle;
    private Object mLock = new Object();
    private AudioManager mAudioManager = (AudioManager) ContextUtils.getApplicationContext().getSystemService("audio");
    private Context mContext = ContextUtils.getApplicationContext();
    private C1055g mTaskRunner = new C1055g();

    public static native void nativeHandleResult(long j, int i);

    public static HardwareEarMonitorDaisy create(long j) {
        return new HardwareEarMonitorDaisy(j);
    }

    public static boolean isAudioKitSupport() {
        return DaisyFeatureKitManager.isAudioKitSupport(ContextUtils.getApplicationContext());
    }

    public boolean isKaraokeServiceSupport() {
        return this.mDaisyAudioKit.isFeatureSupported(DaisyAudioKit.FeatureType.HWAUDIO_FEATURE_KARAOKE);
    }

    public int[] getKaraokeSupportedServices() {
        List<Integer> supportedFeatures = this.mDaisyAudioKit.getSupportedFeatures();
        if (supportedFeatures == null) {
            return null;
        }
        int[] iArr = new int[supportedFeatures.size()];
        for (int i = 0; i < supportedFeatures.size(); i++) {
            iArr[i] = supportedFeatures.get(i).intValue();
        }
        return iArr;
    }

    public void createKaraokeService() {
        this.mDaisyKaraokeKit = (DaisyAudioKaraokeFeatureKit) this.mDaisyAudioKit.createFeature(DaisyAudioKit.FeatureType.HWAUDIO_FEATURE_KARAOKE);
    }

    public void destroy() {
        synchronized (this.mLock) {
            this.mNativeHardwareEarMonitorHandle = 0L;
        }
        DaisyAudioKit daisyAudioKit = this.mDaisyAudioKit;
        if (daisyAudioKit != null) {
            daisyAudioKit.destroy();
            this.mDaisyAudioKit = null;
        }
        DaisyAudioKaraokeFeatureKit daisyAudioKaraokeFeatureKit = this.mDaisyKaraokeKit;
        if (daisyAudioKaraokeFeatureKit != null) {
            daisyAudioKaraokeFeatureKit.destroy();
            this.mDaisyKaraokeKit = null;
        }
    }

    public int enableKaraoke(boolean z) {
        DaisyAudioKaraokeFeatureKit daisyAudioKaraokeFeatureKit = this.mDaisyKaraokeKit;
        if (daisyAudioKaraokeFeatureKit == null) {
            return 1806;
        }
        return daisyAudioKaraokeFeatureKit.enableKaraokeFeature(z);
    }

    public boolean setAudioParams(String str) {
        try {
            this.mAudioManager.setParameters(str);
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    public int setReverberation(int i) {
        DaisyAudioKaraokeFeatureKit daisyAudioKaraokeFeatureKit = this.mDaisyKaraokeKit;
        if (daisyAudioKaraokeFeatureKit == null) {
            return 1806;
        }
        return daisyAudioKaraokeFeatureKit.setParameter(DaisyAudioKaraokeFeatureKit.ParameName.CMD_SET_AUDIO_EFFECT_MODE_BASE, i);
    }

    private int setEqualizer(int i) {
        DaisyAudioKaraokeFeatureKit daisyAudioKaraokeFeatureKit = this.mDaisyKaraokeKit;
        if (daisyAudioKaraokeFeatureKit == null) {
            return 1806;
        }
        return daisyAudioKaraokeFeatureKit.setParameter(DaisyAudioKaraokeFeatureKit.ParameName.CMD_SET_VOCAL_EQUALIZER_MODE, i);
    }

    private int setVolume(int i) {
        DaisyAudioKaraokeFeatureKit daisyAudioKaraokeFeatureKit = this.mDaisyKaraokeKit;
        if (daisyAudioKaraokeFeatureKit == null) {
            return 1806;
        }
        return daisyAudioKaraokeFeatureKit.setParameter(DaisyAudioKaraokeFeatureKit.ParameName.CMD_SET_VOCAL_VOLUME_BASE, i);
    }

    public boolean isHardwareEarMonitorSupported() {
        DaisyAudioKit daisyAudioKit = this.mDaisyAudioKit;
        if (daisyAudioKit == null) {
            return false;
        }
        return daisyAudioKit.isFeatureSupported(DaisyAudioKit.FeatureType.HWAUDIO_FEATURE_KARAOKE);
    }

    public int getKaraokeLatency() {
        DaisyAudioKaraokeFeatureKit daisyAudioKaraokeFeatureKit = this.mDaisyKaraokeKit;
        if (daisyAudioKaraokeFeatureKit == null) {
            return -1;
        }
        try {
            return daisyAudioKaraokeFeatureKit.getKaraokeLatency();
        } catch (Throwable unused) {
            return -1;
        }
    }

    @Override
    public void onResult(final int i) {
        this.mTaskRunner.m1023a(new Runnable() {
            @Override
            public final void run() {
                synchronized (HardwareEarMonitorDaisy.this.mLock) {
                    HardwareEarMonitorDaisy.nativeHandleResult(HardwareEarMonitorDaisy.this.mNativeHardwareEarMonitorHandle, i);
                }
            }
        });
    }

    public HardwareEarMonitorDaisy(long j) {
        this.mNativeHardwareEarMonitorHandle = j;
        DaisyAudioKit daisyAudioKit = new DaisyAudioKit(ContextUtils.getApplicationContext(), this);
        this.mDaisyAudioKit = daisyAudioKit;
        daisyAudioKit.initialize();
    }
}
