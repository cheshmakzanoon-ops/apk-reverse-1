package com.gme.p007av.jni;

import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.p007av.sdk.AVError;
import java.util.concurrent.locks.ReentrantReadWriteLock;

@JNINamespace("liteav::gme")
public class GMESDKAudioEffectJni {
    private final ReentrantReadWriteLock.ReadLock mJniReadLock;
    private final ReentrantReadWriteLock.WriteLock mJniWriteLock;
    private long mNativeGMESDKAudioEffectJni;
    private final ReentrantReadWriteLock mReadWriteLock;

    private static native int nativeDestroy(long j);

    private static native int nativeEnableMusicPlayout(long j, long j2, boolean z);

    private static native int nativeEnableMusicPublish(long j, long j2, boolean z);

    private static native int nativeGetMusicCurrentPosInMS(long j, long j2);

    private static native int nativeGetMusicDurationInMS(long j, long j2);

    private static native int nativeGetMusicPlayoutVolume(long j, long j2);

    private static native int nativeGetMusicPublishVolume(long j, long j2);

    private static native boolean nativeIsMusicPlayEnd(long j, long j2);

    private static native int nativePausePlayMusic(long j, long j2);

    private static native int nativeResumePlayMusic(long j, long j2);

    private static native int nativeSeekMusicToPosInTime(long j, long j2, int i);

    private static native int nativeSetAllMusicVolume(long j, int i);

    private static native int nativeSetKaraokeType(long j, int i);

    private static native int nativeSetMusicPitch(long j, long j2, float f);

    private static native int nativeSetMusicPlayoutVolume(long j, long j2, int i);

    private static native int nativeSetMusicPublishVolume(long j, long j2, int i);

    private static native int nativeSetVoiceType(long j, int i);

    private static native int nativeStartPlayMusic(long j, long j2, String str, int i);

    private static native int nativeStartRecord(long j, String str, int i);

    private static native int nativeStopPlayMusic(long j, long j2);

    private static native int nativeStopRecord(long j);

    public GMESDKAudioEffectJni(long j) {
        ReentrantReadWriteLock reentrantReadWriteLock = new ReentrantReadWriteLock();
        this.mReadWriteLock = reentrantReadWriteLock;
        this.mJniReadLock = reentrantReadWriteLock.readLock();
        this.mJniWriteLock = reentrantReadWriteLock.writeLock();
        this.mNativeGMESDKAudioEffectJni = j;
    }

    public int destroy() {
        this.mJniWriteLock.lock();
        try {
            long j = this.mNativeGMESDKAudioEffectJni;
            if (j == 0) {
                return AVError.AV_ERR_CONTEXT_NOT_START;
            }
            int iNativeDestroy = nativeDestroy(j);
            this.mNativeGMESDKAudioEffectJni = 0L;
            return iNativeDestroy;
        } finally {
            this.mJniWriteLock.unlock();
        }
    }

    public int setMusicPitch(long j, float f) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeSetMusicPitch(j2, j, f);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int startPlayMusic(long j, String str, int i) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeStartPlayMusic(j2, j, str, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int pausePlayMusic(long j) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativePausePlayMusic(j2, j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int resumePlayMusic(long j) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeResumePlayMusic(j2, j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int stopPlayMusic(long j) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeStopPlayMusic(j2, j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public boolean isMusicPlayEnd(long j) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeIsMusicPlayEnd(j2, j);
            }
            return true;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setMusicPublishVolume(long j, int i) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeSetMusicPublishVolume(j2, j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getMusicPublishVolume(long j) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeGetMusicPublishVolume(j2, j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setMusicPlayoutVolume(long j, int i) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeSetMusicPlayoutVolume(j2, j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getMusicPlayoutVolume(long j) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeGetMusicPlayoutVolume(j2, j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getMusicDurationInMS(long j) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeGetMusicDurationInMS(j2, j);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getMusicCurrentPosInMS(long j) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeGetMusicCurrentPosInMS(j2, j);
            }
            return 0;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setAllMusicVolume(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioEffectJni;
            if (j != 0) {
                return nativeSetAllMusicVolume(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int enableMusicPublish(long j, boolean z) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeEnableMusicPublish(j2, j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int enableMusicPlayout(long j, boolean z) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeEnableMusicPlayout(j2, j, z);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int seekMusicToPosInTime(long j, int i) {
        this.mJniReadLock.lock();
        try {
            long j2 = this.mNativeGMESDKAudioEffectJni;
            if (j2 != 0) {
                return nativeSeekMusicToPosInTime(j2, j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int startRecord(String str, int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioEffectJni;
            if (j != 0) {
                return nativeStartRecord(j, str, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int stopRecord() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioEffectJni;
            if (j != 0) {
                return nativeStopRecord(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setVoiceType(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioEffectJni;
            if (j != 0) {
                return nativeSetVoiceType(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setKaraokeType(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKAudioEffectJni;
            if (j != 0) {
                return nativeSetKaraokeType(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }
}
