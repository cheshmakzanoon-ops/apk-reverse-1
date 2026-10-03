package com.gme.trtc.hardwareearmonitor.honor;

import android.content.Context;
import android.media.AudioManager;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.util.C1055g;
import java.util.List;

@JNINamespace("liteav::extensions")
public class HardwareEarMonitorHonor implements IHonorAudioServiceCallback {
    private static final String TAG = "HardwareEarMonitorHonor";
    private HonorAudioClient mHnAudioClient;
    private HonorEarReturnClient mHnEarReturnClient;
    private long mNativeHardwareEarMonitorHandle;
    private Object mLock = new Object();
    private AudioManager mAudioManager = (AudioManager) ContextUtils.getApplicationContext().getSystemService("audio");
    private Context mContext = ContextUtils.getApplicationContext();
    private C1055g mTaskRunner = new C1055g();

    public static native void nativeHandleResult(long j, int i);

    public static HardwareEarMonitorHonor create(long j) {
        return new HardwareEarMonitorHonor(j);
    }

    public static boolean isAudioKitSupport() {
        return HonorAudioClient.isDeviceSupported(ContextUtils.getApplicationContext());
    }

    public boolean isKaraokeServiceSupport() {
        return this.mHnAudioClient.isServiceSupported(HonorAudioClient.ServiceType.HNAUDIO_SERVICE_EARRETURN);
    }

    public int[] getKaraokeSupportedServices() {
        List<Integer> supportedServices = this.mHnAudioClient.getSupportedServices();
        if (supportedServices == null) {
            return null;
        }
        int[] iArr = new int[supportedServices.size()];
        for (int i = 0; i < supportedServices.size(); i++) {
            iArr[i] = supportedServices.get(i).intValue();
        }
        return iArr;
    }

    public void createKaraokeService() {
        this.mHnEarReturnClient = (HonorEarReturnClient) this.mHnAudioClient.createService(HonorAudioClient.ServiceType.HNAUDIO_SERVICE_EARRETURN);
    }

    public void destroy() {
        synchronized (this.mLock) {
            this.mNativeHardwareEarMonitorHandle = 0L;
        }
        HonorAudioClient honorAudioClient = this.mHnAudioClient;
        if (honorAudioClient != null) {
            honorAudioClient.destroy();
            this.mHnAudioClient = null;
        }
        HonorEarReturnClient honorEarReturnClient = this.mHnEarReturnClient;
        if (honorEarReturnClient != null) {
            honorEarReturnClient.destroy();
            this.mHnEarReturnClient = null;
        }
    }

    public int enableKaraoke(boolean z) {
        HonorEarReturnClient honorEarReturnClient = this.mHnEarReturnClient;
        if (honorEarReturnClient == null) {
            return 1806;
        }
        return honorEarReturnClient.enableEarReturn(z);
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
        HonorEarReturnClient honorEarReturnClient = this.mHnEarReturnClient;
        if (honorEarReturnClient == null) {
            return 1806;
        }
        return honorEarReturnClient.setParameter(HonorEarReturnClient.ParameName.CMD_SET_AUDIO_EFFECT_MODE_BASE, i);
    }

    public int setEqualizer(int i) {
        HonorEarReturnClient honorEarReturnClient = this.mHnEarReturnClient;
        if (honorEarReturnClient == null) {
            return 1806;
        }
        return honorEarReturnClient.setParameter(HonorEarReturnClient.ParameName.CMD_SET_VOCAL_EQUALIZER_MODE, i);
    }

    public int setVolume(int i) {
        HonorEarReturnClient honorEarReturnClient = this.mHnEarReturnClient;
        if (honorEarReturnClient == null) {
            return 1806;
        }
        return honorEarReturnClient.setParameter(HonorEarReturnClient.ParameName.CMD_SET_VOCAL_VOLUME_BASE, i);
    }

    public boolean isHardwareEarMonitorSupported() {
        HonorEarReturnClient honorEarReturnClient = this.mHnEarReturnClient;
        if (honorEarReturnClient == null) {
            return false;
        }
        return honorEarReturnClient.isServiceSupported();
    }

    public int getKaraokeLatency() {
        HonorEarReturnClient honorEarReturnClient = this.mHnEarReturnClient;
        if (honorEarReturnClient == null) {
            return -1;
        }
        try {
            return honorEarReturnClient.getEarReturnLatency();
        } catch (Throwable unused) {
            return -1;
        }
    }

    @Override
    public void onResult(final int i) {
        this.mTaskRunner.m1023a(new Runnable() {
            @Override
            public final void run() {
                synchronized (HardwareEarMonitorHonor.this.mLock) {
                    HardwareEarMonitorHonor.nativeHandleResult(HardwareEarMonitorHonor.this.mNativeHardwareEarMonitorHandle, i);
                }
            }
        });
    }

    public HardwareEarMonitorHonor(long j) {
        this.mNativeHardwareEarMonitorHandle = 0L;
        this.mNativeHardwareEarMonitorHandle = j;
        HonorAudioClient honorAudioClient = new HonorAudioClient(this.mContext, this);
        this.mHnAudioClient = honorAudioClient;
        honorAudioClient.initialize();
    }
}
