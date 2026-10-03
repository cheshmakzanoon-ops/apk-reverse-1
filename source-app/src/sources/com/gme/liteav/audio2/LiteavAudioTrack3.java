package com.gme.liteav.audio2;

import android.media.AudioTimestamp;
import android.media.AudioTrack;
import android.os.Process;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.nio.ByteBuffer;

@JNINamespace("liteav::audio")
public class LiteavAudioTrack3 {
    private static final int DEFAULT_LATENCY_MS = 160;
    private static final int HARDWARE_LATENCY_MS = 20;
    private static final long LATENCY_THRESHOLD_MS = 1000;
    private static final long NANOS_PER_MS = 1000000;
    private static final long NANOS_PER_SECOND = 1000000000;
    private static final String TAG = "LiteavAudioTrack3";
    private AudioTrack mAudioTrack;
    private byte[] mPlayBuffer;
    private int mSampleRate = 0;
    private int mBufferSize = 0;
    private int mSystemOSVersion = 0;
    private int mWriteFrameIndex = 0;
    private int mBytesPerFrame = 0;

    private AudioTrack createStartedAudioTrack(int i, int i2, int i3, int i4) {
        AudioTrack audioTrack;
        try {
            audioTrack = new AudioTrack(i4, i, i2, 2, i3, 1);
            try {
                if (audioTrack.getState() != 1) {
                    throw new RuntimeException("AudioTrack is not initialized.");
                }
                this.mWriteFrameIndex = 0;
                audioTrack.play();
                Log.m949i(TAG, "create AudioTrack success. sampleRate: %d, channelConfig: %d, bufferSize: %d, streamType: %s", Integer.valueOf(i), Integer.valueOf(i2), Integer.valueOf(i3), streamTypeToString(i4));
                return audioTrack;
            } catch (Throwable unused) {
                Log.m951w(TAG, "create AudioTrack failed. sampleRate: %d, channelConfig: %d, bufferSize: %d, streamType: %s", Integer.valueOf(i), Integer.valueOf(i2), Integer.valueOf(i3), streamTypeToString(i4));
                destroyAudioTrack(audioTrack);
                return null;
            }
        } catch (Throwable unused2) {
            audioTrack = null;
        }
    }

    private void destroyAudioTrack(AudioTrack audioTrack) {
        if (audioTrack == null) {
            return;
        }
        try {
            if (audioTrack.getPlayState() == 3) {
                audioTrack.stop();
                audioTrack.flush();
            }
            audioTrack.release();
        } catch (Throwable th) {
            Log.m948e(TAG, "stop AudioTrack failed.", th);
        }
    }

    private static String streamTypeToString(int i) {
        if (i == 0) {
            return "STREAM_VOICE_CALL";
        }
        if (i == 1) {
            return "STREAM_SYSTEM";
        }
        if (i == 2) {
            return "STREAM_RING";
        }
        if (i == 3) {
            return "STREAM_MUSIC";
        }
        if (i == 4) {
            return "STREAM_ALARM";
        }
        if (i == 5) {
            return "STREAM_NOTIFICATION";
        }
        return "STREAM_INVALID";
    }

    public int startPlayout(int i, int i2, int i3, int i4) {
        this.mBytesPerFrame = i3 * 2;
        this.mSampleRate = i2;
        int i5 = i3 == 1 ? 4 : 12;
        int minBufferSize = AudioTrack.getMinBufferSize(i2, i5, 2);
        if (minBufferSize <= 0) {
            Log.m948e(TAG, "AudioTrack.getMinBufferSize return error: ".concat(String.valueOf(minBufferSize)), new Object[0]);
            return -2;
        }
        int[] iArr = {i, 0, 3, 1};
        for (int i6 = 0; i6 < 4 && this.mAudioTrack == null; i6++) {
            int i7 = iArr[i6];
            for (int i8 = 1; i8 <= 2 && this.mAudioTrack == null; i8++) {
                int i9 = minBufferSize * i8;
                this.mBufferSize = i9;
                if (i9 >= i4 * 4 || i8 >= 2) {
                    this.mAudioTrack = createStartedAudioTrack(i2, i5, i9, i7);
                }
            }
        }
        if (this.mAudioTrack == null) {
            return -1;
        }
        this.mSystemOSVersion = LiteavSystemInfo.getSystemOSVersionInt();
        Process.setThreadPriority(-19);
        return 0;
    }

    public int write(ByteBuffer byteBuffer, int i, int i2) {
        int iWrite;
        if (this.mAudioTrack == null) {
            return -1;
        }
        byteBuffer.position(i);
        if (this.mSystemOSVersion >= 21) {
            iWrite = this.mAudioTrack.write(byteBuffer, i2, 1);
        } else {
            byte[] bArr = this.mPlayBuffer;
            if (bArr == null || bArr.length < i2) {
                this.mPlayBuffer = new byte[i2];
            }
            byteBuffer.get(this.mPlayBuffer, 0, i2);
            iWrite = this.mAudioTrack.write(this.mPlayBuffer, 0, i2);
        }
        if (iWrite < 0) {
            Log.m948e(TAG, "write audio data to AudioTrack failed. ".concat(String.valueOf(iWrite)), new Object[0]);
            return -1;
        }
        this.mWriteFrameIndex += iWrite / this.mBytesPerFrame;
        return iWrite;
    }

    public void stopPlayout() {
        destroyAudioTrack(this.mAudioTrack);
        this.mAudioTrack = null;
    }

    public int getBufferSize() {
        return this.mBufferSize;
    }

    public int getUnderrunCount() {
        AudioTrack audioTrack = this.mAudioTrack;
        if (audioTrack == null) {
            return 0;
        }
        try {
            if (this.mSystemOSVersion >= 24) {
                return audioTrack.getUnderrunCount();
            }
            return 0;
        } catch (Throwable th) {
            Log.m951w(TAG, "get under run count exception " + th.getMessage(), new Object[0]);
            return 0;
        }
    }

    public int getPlayoutLatencyMs() {
        if (this.mAudioTrack == null || this.mSystemOSVersion < 23) {
            return DEFAULT_LATENCY_MS;
        }
        try {
            return getLatencyByTimestamp();
        } catch (Throwable th) {
            Log.m951w(TAG, "get latency exception " + th.getMessage(), new Object[0]);
            return DEFAULT_LATENCY_MS;
        }
    }

    private int getLatencyByTimestamp() {
        AudioTimestamp audioTimestamp = new AudioTimestamp();
        if (!this.mAudioTrack.getTimestamp(audioTimestamp)) {
            Log.m951w(TAG, "fail to get AudioTrack timestamp", new Object[0]);
            return DEFAULT_LATENCY_MS;
        }
        int iLengthBytesToNano = ((int) (((audioTimestamp.nanoTime + lengthBytesToNano(((long) this.mWriteFrameIndex) - audioTimestamp.framePosition)) - System.nanoTime()) / 1000000)) + 20;
        return (iLengthBytesToNano <= 0 || ((long) iLengthBytesToNano) >= LATENCY_THRESHOLD_MS) ? DEFAULT_LATENCY_MS : iLengthBytesToNano;
    }

    private long lengthBytesToNano(long j) {
        return (j * NANOS_PER_SECOND) / ((long) this.mSampleRate);
    }
}
