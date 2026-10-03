package com.gme.trtc.hardwareearmonitor.vivo;

import android.media.AudioManager;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.annotations.JNINamespace;

@JNINamespace("liteav::extensions")
public class HardwareEarMonitorVivo {
    private AudioManager mAudioManager = (AudioManager) ContextUtils.getApplicationContext().getSystemService("audio");
    private long mNativeHardwareEarMonitorHandle;

    public static HardwareEarMonitorVivo create(long j) {
        return new HardwareEarMonitorVivo(j);
    }

    public boolean setAudioParams(String str) {
        try {
            this.mAudioManager.setParameters(str);
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    public String getParameters(String str) {
        try {
            return this.mAudioManager.getParameters(str);
        } catch (Throwable unused) {
            return "";
        }
    }

    public HardwareEarMonitorVivo(long j) {
        this.mNativeHardwareEarMonitorHandle = j;
    }
}
