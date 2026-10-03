package com.gme.p007av.jni;

import com.gme.TMG.ITMGContext;
import com.gme.TMG.ITMGType;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.p007av.sdk.AVError;
import com.gme.p007av.utils.EventHelper;
import com.gme.p007av.utils.GMELibLoader;
import java.util.concurrent.locks.ReentrantReadWriteLock;

@JNINamespace("liteav::gme")
public class GMESDKJni {
    public static final String TAG = "GMESDKJni";
    private final GMESDKAudioEffectJni mAudioEffectJni;
    private final GMESDKAudioJni mAudioJni;
    private ITMGContext.ITMGDelegate mDelegate;
    private final ReentrantReadWriteLock.ReadLock mJniReadLock;
    private final ReentrantReadWriteLock.WriteLock mJniWriteLock;
    private long mNativeGMESDKJni;
    private final GMESDKPTTJni mPttJni;
    private final ReentrantReadWriteLock mReadWriteLock;
    private final GMESDKRoomJni mRoomJni;

    private static native int nativeCheckMicPermission(long j);

    private static native long nativeCreateAudioCtrl(long j);

    private static native long nativeCreateAudioEffectCtrl(long j);

    private static native long nativeCreateContext(GMESDKJni gMESDKJni);

    private static native long nativeCreatePTT(long j);

    private static native long nativeCreateRoom(long j);

    private static native int nativeDestroyContext(long j);

    private static native int nativeEnterRoom(long j, String str, int i, byte[] bArr);

    private static native int nativeExitRoom(long j);

    private static native byte[] nativeGenAuthBuffer(int i, String str, String str2, String str3);

    private static native String nativeGetAdvanceParam(long j, String str);

    private static native String nativeGetLogPath(long j);

    private static native String nativeGetSDKVersion(long j);

    private static native int nativeInit(long j, String str, String str2);

    private static native boolean nativeIsRoomEntered(long j);

    private static native int nativePause(long j);

    private static native int nativePoll(long j);

    private static native int nativeResume(long j);

    private static native int nativeSetAdvanceParams(long j, String str, String str2);

    private static native void nativeSetAppVersion(long j, String str);

    private static native int nativeSetAudioRole(long j, int i);

    private static native int nativeSetLogLevel(long j, int i, int i2);

    private static native int nativeSetLogPath(long j, String str);

    private static native int nativeSetRangeAudioMode(long j, int i);

    private static native int nativeSetRecvMixStreamCount(long j, int i);

    private static native void nativeSetRegion(long j, String str);

    private static native int nativeSetScene(long j, int i);

    private static native int nativeSetTeamID(long j, int i);

    private static native int nativeShowDebugView(long j, boolean z);

    private static native int nativeUnInit(long j);

    static {
        GMELibLoader.loadSdkLibrary();
    }

    public GMESDKJni() {
        ReentrantReadWriteLock reentrantReadWriteLock = new ReentrantReadWriteLock();
        this.mReadWriteLock = reentrantReadWriteLock;
        this.mJniReadLock = reentrantReadWriteLock.readLock();
        this.mJniWriteLock = reentrantReadWriteLock.writeLock();
        this.mNativeGMESDKJni = nativeCreateContext(this);
        this.mAudioJni = new GMESDKAudioJni(nativeCreateAudioCtrl(this.mNativeGMESDKJni));
        this.mAudioEffectJni = new GMESDKAudioEffectJni(nativeCreateAudioEffectCtrl(this.mNativeGMESDKJni));
        this.mRoomJni = new GMESDKRoomJni(nativeCreateRoom(this.mNativeGMESDKJni));
        this.mPttJni = new GMESDKPTTJni(nativeCreatePTT(this.mNativeGMESDKJni));
    }

    public GMESDKAudioJni getAudioJni() {
        return this.mAudioJni;
    }

    public GMESDKAudioEffectJni getAudioEffectJni() {
        return this.mAudioEffectJni;
    }

    public GMESDKRoomJni getRoomJni() {
        return this.mRoomJni;
    }

    public GMESDKPTTJni getPTTJni() {
        return this.mPttJni;
    }

    public int destroy() {
        destroyOther();
        this.mAudioJni.destroy();
        this.mJniWriteLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                nativeDestroyContext(j);
                this.mNativeGMESDKJni = 0L;
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniWriteLock.unlock();
        }
    }

    private void destroyOther() {
        this.mAudioJni.destroy();
        this.mAudioEffectJni.destroy();
        this.mRoomJni.destroy();
    }

    public int poll() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativePoll(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int pause() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativePause(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int resume() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeResume(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setLogLevel(int i, int i2) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeSetLogLevel(j, i, i2);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setLogPath(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeSetLogPath(j, str);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public String getLogPath() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeGetLogPath(j);
            }
            return null;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int showDebugView(boolean z) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeShowDebugView(j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public void setRegion(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                nativeSetRegion(j, str);
            }
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public void setDelegate(ITMGContext.ITMGDelegate iTMGDelegate) {
        this.mDelegate = iTMGDelegate;
    }

    public int init(String str, String str2) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeInit(j, str, str2);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int unInit() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeUnInit(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public String getSDKVersion() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeGetSDKVersion(j);
            }
            return null;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setScene(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeSetScene(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public void setAppVersion(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                nativeSetAppVersion(j, str);
            }
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setAdvanceParams(String str, String str2) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeSetAdvanceParams(j, str, str2);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public String getAdvanceParam(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeGetAdvanceParam(j, str);
            }
            return null;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int enterRoom(String str, int i, byte[] bArr) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeEnterRoom(j, str, i, bArr);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int exitRoom() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeExitRoom(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public boolean isRoomEntered() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeIsRoomEntered(j);
            }
            return false;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setRecvMixStreamCount(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeSetRecvMixStreamCount(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setAudioRole(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeSetAudioRole(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setRangeAudioMode(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeSetRangeAudioMode(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setRangeAudioTeamID(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeSetTeamID(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public static byte[] genAuthBuffer(int i, String str, String str2, String str3) {
        return nativeGenAuthBuffer(i, str, str2, str3);
    }

    public int checkMicPermission() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKJni;
            if (j != 0) {
                return nativeCheckMicPermission(j);
            }
            return ITMGType.ITMG_MIC_PERMISSION.ITMG_PERMISSION_NotDetermined.ordinal();
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public void onEvent(int i, String str) {
        ITMGContext.ITMGDelegate iTMGDelegate = this.mDelegate;
        if (iTMGDelegate != null) {
            iTMGDelegate.OnEvent(EventHelper.idToEvent(i), EventHelper.parserEvent(str));
        }
    }
}
