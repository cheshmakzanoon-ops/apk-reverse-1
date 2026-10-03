package com.gme.p007av.jni;

import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.p007av.sdk.AVError;
import java.util.concurrent.locks.ReentrantReadWriteLock;

@JNINamespace("liteav::gme")
public class GMESDKPTTJni {
    private final ReentrantReadWriteLock.ReadLock mJniReadLock;
    private final ReentrantReadWriteLock.WriteLock mJniWriteLock;
    private long mNativeGMESDKPTTJni;
    private final ReentrantReadWriteLock mReadWriteLock;

    private static native int nativeApplyPTTAuthbuffer(long j, byte[] bArr);

    private static native int nativeCancelRecording(long j);

    private static native int nativeDestroy(long j);

    private static native int nativeDownloadRecordedFile(long j, String str, String str2);

    private static native int nativeGetFileSize(long j, String str);

    private static native int nativeGetVoiceFileDuration(long j, String str);

    private static native int nativePlayRecordedFile(long j, String str, int i);

    private static native int nativeSetMaxMessageLength(long j, int i);

    private static native int nativeSetPTTSourceLanguage(long j, String str);

    private static native int nativeSpeechToText(long j, String str, String str2, String str3);

    private static native int nativeStartRecording(long j, String str);

    private static native int nativeStartRecordingWithStreamingRecognition(long j, String str, String str2, String str3);

    private static native int nativeStopPlayFile(long j);

    private static native int nativeStopRecording(long j);

    private static native int nativeTextToSpeech(long j, int i, String str, String str2, String str3, float f);

    private static native int nativeTranslateText(long j, String str, String str2, String str3);

    private static native int nativeUploadRecordedFile(long j, String str);

    public GMESDKPTTJni(long j) {
        ReentrantReadWriteLock reentrantReadWriteLock = new ReentrantReadWriteLock();
        this.mReadWriteLock = reentrantReadWriteLock;
        this.mJniReadLock = reentrantReadWriteLock.readLock();
        this.mJniWriteLock = reentrantReadWriteLock.writeLock();
        this.mNativeGMESDKPTTJni = j;
    }

    public int destroy() {
        this.mJniWriteLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j == 0) {
                return AVError.AV_ERR_CONTEXT_NOT_START;
            }
            int iNativeDestroy = nativeDestroy(j);
            this.mNativeGMESDKPTTJni = 0L;
            return iNativeDestroy;
        } finally {
            this.mJniWriteLock.unlock();
        }
    }

    public int applyPTTAuthbuffer(byte[] bArr) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeApplyPTTAuthbuffer(j, bArr);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setMaxMessageLength(int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeSetMaxMessageLength(j, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int startRecording(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeStartRecording(j, str);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int stopRecording() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeStopRecording(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int cancelRecording() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeCancelRecording(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int uploadRecordedFile(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeUploadRecordedFile(j, str);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int downloadRecordedFile(String str, String str2) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeDownloadRecordedFile(j, str, str2);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int playRecordedFile(String str, int i) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativePlayRecordedFile(j, str, i);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int stopPlayFile() {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeStopPlayFile(j);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int speechToText(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeSpeechToText(j, str, "", "");
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int speechToText(String str, String str2) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeSpeechToText(j, str, str2, str2);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int speechToText(String str, String str2, String str3) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeSpeechToText(j, str, str2, str3);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int translateText(String str, String str2, String str3) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeTranslateText(j, str, str2, str3);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getFileSize(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeGetFileSize(j, str);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int getVoiceFileDuration(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeGetVoiceFileDuration(j, str);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int startRecordingWithStreamingRecognition(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeStartRecordingWithStreamingRecognition(j, str, "cmn-Hans-CN", "cmn-Hans-CN");
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int startRecordingWithStreamingRecognition(String str, String str2) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeStartRecordingWithStreamingRecognition(j, str, str2, str2);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int startRecordingWithStreamingRecognition(String str, String str2, String str3) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeStartRecordingWithStreamingRecognition(j, str, str2, str3);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int setPTTSourceLanguage(String str) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeSetPTTSourceLanguage(j, str);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }

    public int textToSpeech(int i, String str, String str2, String str3, float f) {
        this.mJniReadLock.lock();
        try {
            long j = this.mNativeGMESDKPTTJni;
            if (j != 0) {
                return nativeTextToSpeech(j, i, str, str2, str3, f);
            }
            return AVError.AV_ERR_CONTEXT_NOT_START;
        } finally {
            this.mJniReadLock.unlock();
        }
    }
}
