package com.gme.p007av.jni;

import com.gme.TMG.ITMGAudioCtrl;
import com.gme.TMG.ITMGType;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.p007av.sdk.AVError;
import java.util.concurrent.locks.ReentrantReadWriteLock;

@JNINamespace("liteav::gme")
public class GMESDKAudioJni {
    private ITMGAudioCtrl.ITMGAudioFrameCallback mAudioFrameCallback;
    private final ReentrantReadWriteLock.ReadLock mJniReadLock;
    private final ReentrantReadWriteLock.WriteLock mJniWriteLock;
    private long mNativeGMESDKAudioJni;
    private final ReentrantReadWriteLock mReadWriteLock;

    private static native int nativeAddAudioBlackList(long j, String str);

    private static native int nativeDestroy(long j);

    private static native int nativeEnableAudioCaptureDevice(long j, boolean z);

    private static native int nativeEnableAudioPlayDevice(long j, boolean z);

    private static native int nativeEnableAudioRecv(long j, boolean z);

    private static native int nativeEnableAudioSend(long j, boolean z);

    private static native int nativeEnableCustomAudioCapture(long j, boolean z);

    private static native int nativeEnableCustomAudioRendering(long j, boolean z);

    private static native int nativeEnableLoopBack(long j, boolean z);

    private static native int nativeEnableSpatializer(long j, boolean z);

    private static native int nativeGetCustomAudioRenderingFrame(long j, AudioFrame audioFrame);

    private static native int nativeGetMicLevel(long j);

    private static native int nativeGetMicVolume(long j);

    private static native int nativeGetRecvStreamLevel(long j, String str);

    private static native int nativeGetSendStreamLevel(long j);

    private static native int nativeGetSpeakerLevel(long j);

    private static native int nativeGetSpeakerVolume(long j);

    private static native int nativeGetSpeakerVolumeByUserID(long j, String str);

    private static native boolean nativeIsAudioCaptureDeviceEnabled(long j);

    private static native boolean nativeIsAudioPlayDeviceEnabled(long j);

    private static native boolean nativeIsAudioRecvEnabled(long j);

    private static native boolean nativeIsAudioSendEnabled(long j);

    private static native boolean nativeIsEnableSpatializer(long j);

    private static native boolean nativeIsUserIDInAudioBlackList(long j, String str);

    private static native int nativeRemoveAudioBlackList(long j, String str);

    private static native int nativeSendCustomAudioData(long j, AudioFrame audioFrame);

    private static native int nativeSetAudioFrameCallback(long j, GMESDKAudioJni gMESDKAudioJni, boolean z);

    private static native int nativeSetAudioRoute(long j, int i);

    private static native int nativeSetLoopBackVolume(long j, int i);

    private static native int nativeSetMicVolume(long j, int i);

    private static native int nativeSetSpeakerVolume(long j, int i);

    private static native int nativeSetSpeakerVolumeByUserID(long j, String str, int i);

    private static native int nativeStopTrackingVolume(long j);

    private static native int nativeTrackingVolume(long j, float f);

    public int InitSpatializer(String str) {
        return 0;
    }

    static class AudioFrame {

        private ITMGType.TMGAudioFrame f568a;

        public AudioFrame(ITMGType.TMGAudioFrame tMGAudioFrame) {
            this.f568a = tMGAudioFrame;
        }

        public byte[] getData() {
            return this.f568a.data;
        }

        public int getSampleRate() {
            return this.f568a.sample_rate;
        }

        public int getChannel() {
            return this.f568a.channel;
        }

        public long getTimestamp() {
            return this.f568a.timestamp;
        }
    }

    public GMESDKAudioJni(long j) {
        ReentrantReadWriteLock reentrantReadWriteLock = new ReentrantReadWriteLock();
        this.mReadWriteLock = reentrantReadWriteLock;
        this.mJniReadLock = reentrantReadWriteLock.readLock();
        this.mJniWriteLock = reentrantReadWriteLock.writeLock();
        this.mAudioFrameCallback = null;
        this.mNativeGMESDKAudioJni = j;
    }

    public int destroy() {
        this.mJniWriteLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j == 0) {
                return AVError.AV_ERR_CONTEXT_NOT_START;
            }
            int iNativeDestroy = nativeDestroy(j);
            this.mNativeGMESDKAudioJni = 0L;
            return iNativeDestroy;
        } finally {
            this.mJniWriteLock.unlock();
        }
    }

    public int enableAudioSend(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeEnableAudioSend(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public boolean isAudioSendEnabled() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeIsAudioSendEnabled(j);
            }
            return false;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int enableAudioRecv(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeEnableAudioRecv(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public boolean isAudioRecvEnabled() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeIsAudioRecvEnabled(j);
            }
            return false;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int enableAudioCaptureDevice(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeEnableAudioCaptureDevice(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public boolean isAudioCaptureDeviceEnabled() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeIsAudioCaptureDeviceEnabled(j);
            }
            return false;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int enableAudioPlayDevice(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeEnableAudioPlayDevice(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public boolean isAudioPlayDeviceEnabled() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeIsAudioPlayDeviceEnabled(j);
            }
            return false;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setSpeakerVolumeByUserID(String str, int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeSetSpeakerVolumeByUserID(j, str, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getSpeakerVolumeByUserID(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeGetSpeakerVolumeByUserID(j, str);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getMicVolume() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeGetMicVolume(j);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setMicVolume(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeSetMicVolume(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getSpeakerVolume() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeGetSpeakerVolume(j);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setSpeakerVolume(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeSetSpeakerVolume(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int enableLoopBack(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeEnableLoopBack(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setLoopBackVolume(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeSetLoopBackVolume(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int addAudioBlackList(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeAddAudioBlackList(j, str);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int removeAudioBlackList(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeRemoveAudioBlackList(j, str);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public boolean isUserIDInAudioBlackList(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeIsUserIDInAudioBlackList(j, str);
            }
            return false;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int EnableCustomAudioCapture(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeEnableCustomAudioCapture(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int SetAudioRoute(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeSetAudioRoute(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int SendCustomAudioData(ITMGType.TMGAudioFrame tMGAudioFrame) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeSendCustomAudioData(j, new AudioFrame(tMGAudioFrame));
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int EnableCustomAudioRendering(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeEnableCustomAudioRendering(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int GetCustomAudioRenderingFrame(ITMGType.TMGAudioFrame tMGAudioFrame) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeGetCustomAudioRenderingFrame(j, new AudioFrame(tMGAudioFrame));
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int TrackingVolume(float f) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeTrackingVolume(j, f);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int StopTrackingVolume() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeStopTrackingVolume(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int GetMicLevel() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeGetMicLevel(j);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int GetSpeakerLevel() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeGetSpeakerLevel(j);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int GetSendStreamLevel() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeGetSendStreamLevel(j);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int GetRecvStreamLevel(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeGetRecvStreamLevel(j, str);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int EnableSpatializer(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeEnableSpatializer(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public boolean IsEnableSpatializer() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                return nativeIsEnableSpatializer(j);
            }
            return false;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public void setAudioFrameCallback(ITMGAudioCtrl.ITMGAudioFrameCallback iTMGAudioFrameCallback) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioJni;
            if (j != 0) {
                nativeSetAudioFrameCallback(j, this, iTMGAudioFrameCallback != null);
                this.mAudioFrameCallback = iTMGAudioFrameCallback;
            }
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    void onCapturedAudioFrame(byte[] bArr, long j, int i, int i2) {
        if (this.mAudioFrameCallback == null) {
            return;
        }
        ITMGType.TMGAudioFrame tMGAudioFrame = new ITMGType.TMGAudioFrame();
        tMGAudioFrame.data = bArr;
        tMGAudioFrame.timestamp = j;
        tMGAudioFrame.sample_rate = i;
        tMGAudioFrame.channel = i2;
        this.mAudioFrameCallback.OnCapturedAudioFrame(tMGAudioFrame);
    }

    void onLocalProcessedAudioFrame(byte[] bArr, long j, int i, int i2) {
        if (this.mAudioFrameCallback == null) {
            return;
        }
        ITMGType.TMGAudioFrame tMGAudioFrame = new ITMGType.TMGAudioFrame();
        tMGAudioFrame.data = bArr;
        tMGAudioFrame.timestamp = j;
        tMGAudioFrame.sample_rate = i;
        tMGAudioFrame.channel = i2;
        this.mAudioFrameCallback.OnLocalProcessedAudioFrame(tMGAudioFrame);
    }

    void onPlayAudioFrame(byte[] bArr, long j, int i, int i2, String str) {
        if (this.mAudioFrameCallback == null) {
            return;
        }
        ITMGType.TMGAudioFrame tMGAudioFrame = new ITMGType.TMGAudioFrame();
        tMGAudioFrame.data = bArr;
        tMGAudioFrame.timestamp = j;
        tMGAudioFrame.sample_rate = i;
        tMGAudioFrame.channel = i2;
        this.mAudioFrameCallback.OnPlayAudioFrame(tMGAudioFrame, str);
    }

    void onMixedPlayAudioFrame(byte[] bArr, long j, int i, int i2) {
        if (this.mAudioFrameCallback == null) {
            return;
        }
        ITMGType.TMGAudioFrame tMGAudioFrame = new ITMGType.TMGAudioFrame();
        tMGAudioFrame.data = bArr;
        tMGAudioFrame.timestamp = j;
        tMGAudioFrame.sample_rate = i;
        tMGAudioFrame.channel = i2;
        this.mAudioFrameCallback.OnMixedPlayAudioFrame(tMGAudioFrame);
    }

    void onMixedAllAudioFrame(byte[] bArr, long j, int i, int i2) {
        if (this.mAudioFrameCallback == null) {
            return;
        }
        ITMGType.TMGAudioFrame tMGAudioFrame = new ITMGType.TMGAudioFrame();
        tMGAudioFrame.data = bArr;
        tMGAudioFrame.timestamp = j;
        tMGAudioFrame.sample_rate = i;
        tMGAudioFrame.channel = i2;
        this.mAudioFrameCallback.OnMixedAllAudioFrame(tMGAudioFrame);
    }
}
