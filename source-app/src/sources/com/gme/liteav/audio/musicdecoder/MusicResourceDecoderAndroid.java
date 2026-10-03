package com.gme.liteav.audio.musicdecoder;

import android.media.MediaFormat;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import java.nio.ByteBuffer;

@JNINamespace("liteav::audio")
public class MusicResourceDecoderAndroid {
    private static final String TAG = "MusicResourceDecoderAndroid";
    private String mPath;
    private int mTrackIndex = 0;
    private final MediaCodecBridge mDecoder = new MediaCodecBridge();

    public boolean start(String str) {
        this.mPath = str;
        return this.mDecoder.initAndStart(str);
    }

    public boolean seekTo(long j) {
        if (this.mDecoder.isDecodeEnd()) {
            this.mDecoder.stop();
            this.mDecoder.initAndStart(this.mPath);
            this.mDecoder.setMusicTrack(this.mTrackIndex);
        }
        return this.mDecoder.seekTo(j * 1000);
    }

    public ByteBuffer decode() {
        return this.mDecoder.processFrame();
    }

    public int getSampleRate() {
        MediaFormat outputFormat = this.mDecoder.getOutputFormat();
        if (outputFormat == null) {
            return -1;
        }
        try {
            return outputFormat.getInteger("sample-rate");
        } catch (Throwable th) {
            Log.m948e(TAG, "getSampleRate failed. " + th.getMessage(), new Object[0]);
            return -1;
        }
    }

    public int getChannelCount() {
        MediaFormat outputFormat = this.mDecoder.getOutputFormat();
        if (outputFormat == null) {
            return -1;
        }
        try {
            return outputFormat.getInteger("channel-count");
        } catch (Throwable th) {
            Log.m948e(TAG, "getChannelCount failed. " + th.getMessage(), new Object[0]);
            return -1;
        }
    }

    public long getDuration() {
        return (this.mDecoder.getLongestDuration() + 500) / 1000;
    }

    public int getBitrate() {
        MediaFormat outputFormat = this.mDecoder.getOutputFormat();
        if (outputFormat == null) {
            return -1;
        }
        try {
            return outputFormat.getInteger("bitrate");
        } catch (Throwable th) {
            Log.m948e(TAG, "getBitrate failed. " + th.getMessage(), new Object[0]);
            return -1;
        }
    }

    public int getTrackCount() {
        return this.mDecoder.getTrackCount();
    }

    public void setMusicTrack(int i) {
        this.mTrackIndex = i;
        this.mDecoder.setMusicTrack(i);
    }

    public int getTotalRawDataSize() {
        return this.mDecoder.getTotalRawDataSize();
    }

    public boolean isDecodeEnd() {
        return this.mDecoder.isDecodeEnd();
    }

    public void stop() {
        this.mDecoder.stop();
    }
}
