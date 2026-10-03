package com.gme.trtc.hardwareearmonitor;

import android.media.AudioTrack;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.util.LiteavLog;

@JNINamespace("liteav::extensions")
public class HardwareEarMonitorSilentTrack {
    private static final int DEFAULT_SAMPLE_RATE = 48000;
    private static final String TAG = "HardwareEarMonitorSilentTrack";
    private PlaybackThread mPlaybackThread;
    private int mChannelConfig = 12;
    private int mAudioFormat = 2;
    private boolean mIsPlaying = false;

    public static HardwareEarMonitorSilentTrack create() {
        return new HardwareEarMonitorSilentTrack();
    }

    public void StartAudioTrack() {
        if (this.mIsPlaying || this.mPlaybackThread != null) {
            return;
        }
        this.mIsPlaying = true;
        PlaybackThread playbackThread = new PlaybackThread();
        this.mPlaybackThread = playbackThread;
        playbackThread.start();
    }

    public void StopAudioTrack() {
        PlaybackThread playbackThread = this.mPlaybackThread;
        if (playbackThread != null) {
            this.mIsPlaying = false;
            playbackThread.closeThread();
            try {
                this.mPlaybackThread.join();
            } catch (Throwable th) {
                LiteavLog.m996e(TAG, "mPlaybackThread join,Throwable ex : %s", th.getMessage());
            }
            this.mPlaybackThread = null;
        }
    }

    public class PlaybackThread extends Thread {
        private boolean isStop = false;

        PlaybackThread() {
        }

        public synchronized void closeThread() {
            this.isStop = true;
        }

        @Override
        public void run() {
            int minBufferSize = AudioTrack.getMinBufferSize(HardwareEarMonitorSilentTrack.DEFAULT_SAMPLE_RATE, HardwareEarMonitorSilentTrack.this.mChannelConfig, HardwareEarMonitorSilentTrack.this.mAudioFormat);
            AudioTrack audioTrack = new AudioTrack(3, HardwareEarMonitorSilentTrack.DEFAULT_SAMPLE_RATE, HardwareEarMonitorSilentTrack.this.mChannelConfig, HardwareEarMonitorSilentTrack.this.mAudioFormat, minBufferSize, 1);
            if (audioTrack.getState() == 1) {
                audioTrack.play();
                byte[] bArr = new byte[minBufferSize];
                for (int i = 0; i < minBufferSize; i++) {
                    bArr[i] = 0;
                }
                while (!this.isStop && !isInterrupted()) {
                    try {
                        audioTrack.write(bArr, 0, minBufferSize);
                    } catch (Throwable th) {
                        LiteavLog.m996e(HardwareEarMonitorSilentTrack.TAG, "audioTrack write,Throwable ex : %s", th.getMessage());
                    }
                }
                audioTrack.stop();
                audioTrack.flush();
            }
            audioTrack.release();
        }
    }
}
