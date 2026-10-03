package com.gme.p007av.jni;

import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.p007av.sdk.AVError;
import java.util.concurrent.locks.ReentrantReadWriteLock;

@JNINamespace("liteav::gme")
public class GMESDKRoomJni {
    private final ReentrantReadWriteLock.ReadLock mJniReadLock;
    private final ReentrantReadWriteLock.WriteLock mJniWriteLock;
    private long mNativeGMESDKRoomJni;
    private final ReentrantReadWriteLock mReadWriteLock;

    private static native int nativeChangeRoomType(long j, int i);

    private static native int nativeDestroy(long j);

    private static native String nativeGetRoomID(long j);

    private static native int nativeGetRoomType(long j);

    private static native int nativeSendCustomData(long j, byte[] bArr, int i);

    private static native int nativeSendSEIMsg(long j, String str, int i);

    private static native int nativeStartRoomSharing(long j, String str, String str2, byte[] bArr);

    private static native int nativeStopRoomSharing(long j);

    private static native int nativeStopSendCustomData(long j);

    private static native int nativeSwitchRoom(long j, String str, byte[] bArr);

    private static native int nativeUpdateAudioRecvRange(long j, float f);

    private static native int nativeUpdateOtherPosition(long j, String str, float[] fArr);

    private static native int nativeUpdateSelfPosition(long j, float[] fArr, float[] fArr2, float[] fArr3, float[] fArr4);

    private static native int nativeUpdateSpatializerRecvRange(long j, float f);

    public GMESDKRoomJni(long j) {
        ReentrantReadWriteLock reentrantReadWriteLock = new ReentrantReadWriteLock();
        this.mReadWriteLock = reentrantReadWriteLock;
        this.mJniReadLock = reentrantReadWriteLock.readLock();
        this.mJniWriteLock = reentrantReadWriteLock.writeLock();
        this.mNativeGMESDKRoomJni = j;
    }

    public int destroy() {
        this.mJniWriteLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j == 0) {
                return AVError.AV_ERR_CONTEXT_NOT_START;
            }
            int iNativeDestroy = nativeDestroy(j);
            this.mNativeGMESDKRoomJni = 0L;
            return iNativeDestroy;
        } finally {
            this.mJniWriteLock.unlock();
        }
    }

    public String getRoomID() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeGetRoomID(j);
            }
            return null;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int startRoomSharing(String str, String str2, byte[] bArr) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeStartRoomSharing(j, str, str2, bArr);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int stopRoomSharing() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeStopRoomSharing(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int changeRoomType(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeChangeRoomType(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getRoomType() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeGetRoomType(j);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int switchRoom(String str, byte[] bArr) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeSwitchRoom(j, str, bArr);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int sendCustomData(byte[] bArr, int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeSendCustomData(j, bArr, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int stopSendCustomData() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeStopSendCustomData(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int updateAudioRecvRange(float f) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeUpdateAudioRecvRange(j, f);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int updateSelfPosition(float[] fArr, float[] fArr2, float[] fArr3, float[] fArr4) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeUpdateSelfPosition(j, fArr, fArr2, fArr3, fArr4);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int updateSpatializerRecvRange(float f) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeUpdateSpatializerRecvRange(j, f);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int updateOtherPosition(String str, float[] fArr) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeUpdateOtherPosition(j, str, fArr);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int sendSEIMsg(String str, int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKRoomJni;
            if (j != 0) {
                return nativeSendSEIMsg(j, str, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }
}
