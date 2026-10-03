package com.gme.liteav.audio2;

import android.content.Context;
import android.media.AudioFormat;
import android.media.AudioManager;
import android.media.AudioPlaybackCaptureConfiguration;
import android.media.AudioRecord;
import android.media.projection.MediaProjection;
import android.os.Process;
import cn.thinkingdata.android.j$$ExternalSyntheticApiModelOutline0;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import java.nio.ByteBuffer;

@JNINamespace("liteav::audio")
public class SystemLoopbackRecorder2 {
    private static final String TAG = "SystemLoopbackRecorder2";
    private static final Object mLock = new Object();
    private static MediaProjection mMediaProjection;
    private static volatile long mNativeSystemLoopbackRecorder;

    private static native void nativeSetMediaProjectionSession(long j, MediaProjection mediaProjection);

    public static void notifyMediaProjectionState(MediaProjection mediaProjection) {
        StringBuilder sb = new StringBuilder("Received MediaProjection state ");
        sb.append(mediaProjection != null);
        Log.m949i(TAG, sb.toString(), new Object[0]);
        synchronized (mLock) {
            mMediaProjection = mediaProjection;
            setMediaProjectionSession();
        }
    }

    public SystemLoopbackRecorder2(long j) {
        mNativeSystemLoopbackRecorder = j;
    }

    public MediaProjection getMediaProjection() {
        return mMediaProjection;
    }

    public void releaseNativeSystemLoopbackRecorder() {
        mNativeSystemLoopbackRecorder = 0L;
    }

    public static void setMediaProjectionSession() {
        if (mMediaProjection == null) {
            Log.m949i(TAG, "MediaProjection is null.", new Object[0]);
        } else if (mNativeSystemLoopbackRecorder != 0) {
            nativeSetMediaProjectionSession(mNativeSystemLoopbackRecorder, mMediaProjection);
        }
    }

    static class Recorder {

        private AudioRecord f571a;

        private AudioManager f572b;

        public Recorder() {
            Context applicationContext = ContextUtils.getApplicationContext();
            ContextUtils.getApplicationContext();
            this.f572b = (AudioManager) applicationContext.getSystemService("audio");
        }

        public void stopRecording() {
            m919a(this.f571a);
            this.f571a = null;
        }

        public int read(ByteBuffer byteBuffer, int i) {
            if (this.f571a == null) {
                return -1;
            }
            byteBuffer.position(0);
            int i2 = this.f571a.read(byteBuffer, i);
            if (i2 > 0) {
                return i2;
            }
            Log.m948e(SystemLoopbackRecorder2.TAG, "Read failed ".concat(String.valueOf(i2)), new Object[0]);
            return -1;
        }

        private static AudioRecord m917a(MediaProjection mediaProjection, int i, int i2, int i3) {
            AudioPlaybackCaptureConfiguration.Builder builderM579m = j$$ExternalSyntheticApiModelOutline0.m579m(mediaProjection);
            builderM579m.addMatchingUsage(1);
            builderM579m.addMatchingUsage(14);
            AudioPlaybackCaptureConfiguration audioPlaybackCaptureConfigurationBuild = builderM579m.build();
            if (audioPlaybackCaptureConfigurationBuild == null) {
                return null;
            }
            int i4 = i2 == 1 ? 16 : 12;
            AudioFormat audioFormatBuild = new AudioFormat.Builder().setEncoding(2).setSampleRate(i).setChannelMask(i4).build();
            int minBufferSize = AudioRecord.getMinBufferSize(i, i4, 2);
            AudioRecord audioRecordBuild = null;
            for (int i5 = 1; i5 <= 2 && audioRecordBuild == null; i5++) {
                int i6 = minBufferSize * i5;
                if (i6 >= i3 * 4 || i5 >= 2) {
                    try {
                        audioRecordBuild = new AudioRecord.Builder().setAudioFormat(audioFormatBuild).setBufferSizeInBytes(i6).setAudioPlaybackCaptureConfig(audioPlaybackCaptureConfigurationBuild).build();
                        if (audioRecordBuild.getState() != 1) {
                            Log.m948e(SystemLoopbackRecorder2.TAG, "Audio record state error", new Object[0]);
                            m919a(audioRecordBuild);
                            audioRecordBuild = null;
                        } else {
                            audioRecordBuild.startRecording();
                            Log.m949i(SystemLoopbackRecorder2.TAG, "Create audio record success", new Object[0]);
                        }
                    } catch (Throwable th) {
                        Log.m951w(SystemLoopbackRecorder2.TAG, "Create record error " + th.getMessage(), new Object[0]);
                        m919a(audioRecordBuild);
                    }
                }
            }
            return audioRecordBuild;
        }

        private static void m919a(AudioRecord audioRecord) {
            if (audioRecord == null) {
                return;
            }
            try {
                if (audioRecord.getRecordingState() == 3) {
                    audioRecord.stop();
                }
                audioRecord.release();
            } catch (Throwable th) {
                Log.m948e(SystemLoopbackRecorder2.TAG, "Destroy AudioRecord failed." + th.getMessage(), new Object[0]);
            }
        }

        private void m918a(int i) {
            try {
                AudioManager audioManager = this.f572b;
                if (audioManager != null) {
                    audioManager.setMode(i);
                }
            } catch (Throwable th) {
                Log.m948e(SystemLoopbackRecorder2.TAG, "Set audio mode exception " + th.getMessage(), new Object[0]);
            }
        }

        public int startRecording(MediaProjection mediaProjection, int i, int i2, int i3, int i4) {
            if (i4 == 0) {
                try {
                    AudioManager audioManager = this.f572b;
                    if (audioManager != null) {
                        audioManager.setAllowedCapturePolicy(3);
                    }
                } catch (Throwable th) {
                    Log.m948e(SystemLoopbackRecorder2.TAG, "ForbidCaptureAudioFromCurrentApp error " + th.getMessage(), new Object[0]);
                }
            }
            AudioManager audioManager2 = this.f572b;
            int mode = audioManager2 != null ? audioManager2.getMode() : 0;
            m918a(0);
            this.f571a = m917a(mediaProjection, i, i2, i3);
            m918a(mode);
            if (this.f571a == null) {
                return -1;
            }
            Process.setThreadPriority(-19);
            return 0;
        }
    }
}
