package com.gme.liteav.audio2;

import android.media.AudioRecord;
import android.media.AudioTimestamp;
import android.os.Process;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.nio.ByteBuffer;

@JNINamespace("liteav::audio")
class LiteavAudioRecord3 {
    private static final int DEFAULT_LATENCY_MS = 30;
    private static final int HARDWARE_LATENCY_MS = 20;
    private static final long LATENCY_THRESHOLD_MS = 1000;
    private static final long NANOS_PER_MS = 1000000;
    private static final long NANOS_PER_SECOND = 1000000000;
    private static final String TAG = "LiteavAudioRecord3";
    private AudioRecord mAudioRecord;
    private int mSampleRate = 0;
    private int mBufferSize = 0;
    private int mReadFrameIndex = 0;
    private int mBytesPerFrame = 0;
    private int mSystemOSVersion = 0;

    private AudioRecord createStartedAudioRecord(int i, int i2, int i3, int i4) {
        AudioRecord audioRecord;
        try {
            audioRecord = new AudioRecord(i, i2, i3, 2, i4);
            try {
                try {
                    if (audioRecord.getState() != 1) {
                        throw new RuntimeException("AudioRecord is not initialized.");
                    }
                    this.mReadFrameIndex = 0;
                    audioRecord.startRecording();
                    Log.m949i(TAG, "create AudioRecord success. sampleRate: %d, channelConfig: %d, bufferSize: %d, audio source: %s", Integer.valueOf(i2), Integer.valueOf(i3), Integer.valueOf(i4), audioSourceToString(i));
                    return audioRecord;
                } catch (Throwable unused) {
                    Log.m951w(TAG, "create AudioRecord failed. source: %s, sampleRate: %d, channelConfig: %d, bufferSize: %d", audioSourceToString(i), Integer.valueOf(i2), Integer.valueOf(i3), Integer.valueOf(i4));
                    destroyAudioRecord(audioRecord);
                    return null;
                }
            } catch (Throwable unused2) {
            }
        } catch (Throwable unused3) {
            audioRecord = null;
        }
    }

    private static void destroyAudioRecord(AudioRecord audioRecord) {
        if (audioRecord == null) {
            return;
        }
        try {
            if (audioRecord.getRecordingState() == 3) {
                audioRecord.stop();
            }
            audioRecord.release();
        } catch (Throwable th) {
            Log.m948e(TAG, "stop AudioRecord failed.", th);
        }
    }

    private static String audioSourceToString(int i) {
        switch (i) {
            case 0:
                return "DEFAULT";
            case 1:
                return "MIC";
            case 2:
                return "VOICE_UPLINK";
            case 3:
                return "VOICE_DOWNLINK";
            case 4:
                return "VOICE_CALL";
            case 5:
                return "CAMCORDER";
            case 6:
                return "VOICE_RECOGNITION";
            case 7:
                return "VOICE_COMMUNICATION";
            case 8:
            default:
                return "INVALID";
            case 9:
                return "UNPROCESSED";
            case 10:
                return "VOICE_PERFORMANCE";
        }
    }

    public int startRecording(int i, int i2, int i3, int i4) {
        this.mBytesPerFrame = i3 * 2;
        this.mSampleRate = i2;
        int i5 = i3 == 1 ? 16 : 12;
        int minBufferSize = AudioRecord.getMinBufferSize(i2, i5, 2);
        if (minBufferSize <= 0) {
            Log.m948e(TAG, "AudioRecord.getMinBufferSize return error: ".concat(String.valueOf(minBufferSize)), new Object[0]);
        }
        int i6 = i3 * i2;
        if (minBufferSize < i6) {
            minBufferSize = i6;
        }
        int[] iArr = {i, 1, 5, 0};
        for (int i7 = 0; i7 < 4 && this.mAudioRecord == null; i7++) {
            int i8 = iArr[i7];
            for (int i9 = 1; i9 <= 2 && this.mAudioRecord == null; i9++) {
                int i10 = minBufferSize * i9;
                this.mBufferSize = i10;
                if (i10 >= i4 * 4 || i9 >= 2) {
                    this.mAudioRecord = createStartedAudioRecord(i8, i2, i5, i10);
                }
            }
        }
        if (this.mAudioRecord == null) {
            return -1;
        }
        this.mSystemOSVersion = LiteavSystemInfo.getSystemOSVersionInt();
        Process.setThreadPriority(-19);
        return 0;
    }

    public int read(ByteBuffer byteBuffer, int i) {
        if (this.mAudioRecord == null) {
            return -1;
        }
        byteBuffer.position(0);
        int i2 = this.mAudioRecord.read(byteBuffer, i);
        if (i2 < 0) {
            Log.m948e(TAG, "read failed, %d", Integer.valueOf(i2));
            return -1;
        }
        this.mReadFrameIndex += i2 / this.mBytesPerFrame;
        return i2;
    }

    public void stopRecording() {
        destroyAudioRecord(this.mAudioRecord);
        this.mAudioRecord = null;
    }

    public int getSessionId() {
        AudioRecord audioRecord = this.mAudioRecord;
        if (audioRecord == null) {
            return -1;
        }
        return audioRecord.getAudioSessionId();
    }

    public int getRecordLatencyMs() {
        if (this.mAudioRecord == null || this.mSystemOSVersion < 24) {
            return 30;
        }
        try {
            return getLatencyByTimestamp();
        } catch (Throwable th) {
            Log.m951w(TAG, "get latency exception " + th.getMessage(), new Object[0]);
            return 30;
        }
    }

    private int getLatencyByTimestamp() {
        AudioTimestamp audioTimestamp = new AudioTimestamp();
        if (this.mAudioRecord.getTimestamp(audioTimestamp, 0) != 0) {
            Log.m951w(TAG, "fail to get audio record timestamp", new Object[0]);
            return 30;
        }
        int iNanoTime = (int) ((System.nanoTime() - (audioTimestamp.nanoTime + lengthBytesToNano(((long) this.mReadFrameIndex) - audioTimestamp.framePosition))) / 1000000);
        int i = iNanoTime + 20;
        if (iNanoTime <= 0 || iNanoTime > LATENCY_THRESHOLD_MS) {
            return 30;
        }
        return i;
    }

    private long lengthBytesToNano(long j) {
        return (j * NANOS_PER_SECOND) / ((long) this.mSampleRate);
    }
}
