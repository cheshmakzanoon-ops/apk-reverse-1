package com.gme.liteav.audio.musicdecoder;

import android.content.Context;
import android.media.MediaCodec;
import android.media.MediaCrypto;
import android.media.MediaExtractor;
import android.media.MediaFormat;
import android.net.Uri;
import android.text.TextUtils;
import android.view.Surface;
import com.gme.liteav.base.ContextUtils;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.nio.ByteBuffer;
import java.util.concurrent.TimeUnit;

@JNINamespace("liteav::audio")
public class MediaCodecBridge {
    private static final String TAG = "MediaCodecBridge";
    private static final long TIMEOUT_MS = 400;
    private final Context mContext = ContextUtils.getApplicationContext();
    private boolean mDecodeEOS;
    private MediaFormat mFormat;
    private long mLongestDurationUs;
    private MediaCodec mMediaCodec;
    private MediaExtractor mMediaExtractor;
    private String mMime;
    private int mRawDataSize;
    private int mTrackCount;
    private int mTrackIndex;

    public boolean initAndStart(String str) {
        if (this.mMediaCodec != null || !initMediaExtractor(str) || !initMediaCodec()) {
            return false;
        }
        try {
            this.mMediaCodec.start();
            return true;
        } catch (Throwable th) {
            Log.m948e(TAG, "Cannot start the audio codec" + th.getMessage(), th);
            return false;
        }
    }

    public boolean seekTo(long j) {
        MediaExtractor mediaExtractor;
        if (this.mMediaCodec == null || (mediaExtractor = this.mMediaExtractor) == null || j > this.mLongestDurationUs) {
            return false;
        }
        try {
            mediaExtractor.seekTo(j, 2);
            return true;
        } catch (Throwable th) {
            Log.m948e(TAG, "Failed to seek: " + th.getMessage(), th);
            return false;
        }
    }

    public ByteBuffer processFrame() {
        MediaCodec mediaCodec = this.mMediaCodec;
        if (mediaCodec == null) {
            return null;
        }
        try {
            int iDequeueInputBuffer = mediaCodec.dequeueInputBuffer(TIMEOUT_MS);
            if (iDequeueInputBuffer < 0) {
                return null;
            }
            ByteBuffer byteBuffer = this.mMediaCodec.getInputBuffers()[iDequeueInputBuffer];
            int sampleData = byteBuffer != null ? this.mMediaExtractor.readSampleData(byteBuffer, 0) : -1;
            if (sampleData <= 0) {
                this.mMediaCodec.queueInputBuffer(iDequeueInputBuffer, 0, 0, 0L, 4);
            } else {
                this.mRawDataSize += sampleData;
                this.mMediaCodec.queueInputBuffer(iDequeueInputBuffer, 0, sampleData, this.mMediaExtractor.getSampleTime(), 0);
                this.mMediaExtractor.advance();
            }
            return drainData();
        } catch (Throwable th) {
            Log.m948e(TAG, "Failed to process frame: " + th.getMessage(), th);
            return null;
        }
    }

    private ByteBuffer drainData() {
        for (int i = 0; i < 3; i++) {
            ByteBuffer byteBufferDequeueOutputBuffer = dequeueOutputBuffer();
            if (byteBufferDequeueOutputBuffer != null) {
                return byteBufferDequeueOutputBuffer;
            }
        }
        return null;
    }

    private ByteBuffer dequeueOutputBuffer() {
        ByteBuffer outputBuffer;
        if (this.mDecodeEOS) {
            return null;
        }
        try {
            MediaCodec.BufferInfo bufferInfo = new MediaCodec.BufferInfo();
            int iDequeueOutputBuffer = this.mMediaCodec.dequeueOutputBuffer(bufferInfo, TimeUnit.MILLISECONDS.toMicros(TIMEOUT_MS));
            if (iDequeueOutputBuffer == -1) {
                return null;
            }
            if (iDequeueOutputBuffer == -3) {
                Log.m949i(TAG, "codec output buffers changed.", new Object[0]);
                return null;
            }
            if (iDequeueOutputBuffer == -2) {
                this.mFormat = this.mMediaCodec.getOutputFormat();
                Log.m949i(TAG, "codec output format changed: " + this.mFormat, new Object[0]);
                return null;
            }
            if (iDequeueOutputBuffer < 0) {
                Log.m948e(TAG, "unexpected result from dequeueOutputBuffer: ".concat(String.valueOf(iDequeueOutputBuffer)), new Object[0]);
                return null;
            }
            if ((bufferInfo.flags & 4) != 0) {
                Log.m949i(TAG, "Decode to EOS", new Object[0]);
                this.mDecodeEOS = true;
                return null;
            }
            if (LiteavSystemInfo.getSystemOSVersionInt() >= 21) {
                outputBuffer = this.mMediaCodec.getOutputBuffer(iDequeueOutputBuffer);
            } else {
                outputBuffer = this.mMediaCodec.getOutputBuffers()[iDequeueOutputBuffer];
            }
            ByteBuffer byteBufferAllocateDirect = ByteBuffer.allocateDirect(bufferInfo.size);
            byteBufferAllocateDirect.put(outputBuffer);
            this.mMediaCodec.releaseOutputBuffer(iDequeueOutputBuffer, false);
            return byteBufferAllocateDirect;
        } catch (Throwable th) {
            Log.m948e(TAG, "Failed to dequeue output buffer" + th.getMessage(), th);
            return null;
        }
    }

    private boolean setDataSource(String str) {
        Log.m949i(TAG, "setDataSource url:".concat(String.valueOf(str)), new Object[0]);
        if (str.startsWith("content://")) {
            try {
                if (this.mContext != null && this.mMediaExtractor != null) {
                    this.mMediaExtractor.setDataSource(this.mContext.getContentResolver().openFileDescriptor(Uri.parse(str), "r").getFileDescriptor());
                } else {
                    this.mMediaExtractor.setDataSource(str);
                }
            } catch (Throwable th) {
                Log.m948e(TAG, "setDataSource failed! error: " + th.getMessage(), th);
                return false;
            }
        } else {
            this.mMediaExtractor.setDataSource(str);
        }
        return true;
    }

    private boolean initMediaExtractor(String str) {
        if (TextUtils.isEmpty(str)) {
            return false;
        }
        this.mDecodeEOS = false;
        try {
            this.mMediaExtractor = new MediaExtractor();
            if (!setDataSource(str)) {
                return false;
            }
            this.mTrackCount = this.mMediaExtractor.getTrackCount();
            for (int i = 0; i < this.mTrackCount; i++) {
                MediaFormat trackFormat = this.mMediaExtractor.getTrackFormat(i);
                String string = trackFormat.getString("mime");
                if (!TextUtils.isEmpty(string) && string.startsWith("audio/")) {
                    long duration = getDuration(trackFormat);
                    if (this.mLongestDurationUs < duration) {
                        this.mLongestDurationUs = duration;
                    }
                }
            }
            int i2 = this.mTrackIndex;
            if (i2 != 0) {
                return selectTrack(i2);
            }
            for (int i3 = 0; i3 < this.mTrackCount; i3++) {
                if (selectTrack(i3)) {
                    return true;
                }
            }
            return false;
        } catch (Throwable th) {
            Log.m948e(TAG, "initMediaExtractor: " + th.getMessage(), th);
            this.mMediaExtractor = null;
            this.mFormat = null;
            this.mMime = null;
            return false;
        }
    }

    private boolean selectTrack(int i) {
        try {
            MediaFormat trackFormat = this.mMediaExtractor.getTrackFormat(i);
            String string = trackFormat.getString("mime");
            if (TextUtils.isEmpty(string) || !string.startsWith("audio/")) {
                return false;
            }
            this.mMediaExtractor.selectTrack(i);
            this.mTrackIndex = i;
            this.mFormat = trackFormat;
            this.mMime = string;
            return true;
        } catch (Throwable th) {
            Log.m948e(TAG, "Failed to select track: " + th.getMessage(), th);
            return false;
        }
    }

    private boolean initMediaCodec() {
        if (!TextUtils.isEmpty(this.mMime) && this.mFormat != null) {
            try {
                MediaCodec mediaCodecCreateDecoderByType = MediaCodec.createDecoderByType(this.mMime);
                this.mMediaCodec = mediaCodecCreateDecoderByType;
                mediaCodecCreateDecoderByType.configure(this.mFormat, (Surface) null, (MediaCrypto) null, 0);
                return true;
            } catch (Throwable th) {
                th.printStackTrace();
                this.mMediaCodec = null;
            }
        }
        return false;
    }

    private long getDuration(MediaFormat mediaFormat) {
        if (mediaFormat == null) {
            return -1L;
        }
        try {
            return mediaFormat.getLong("durationUs");
        } catch (Throwable th) {
            Log.m948e(TAG, "getDuration failed. " + th.getMessage(), new Object[0]);
            return -1L;
        }
    }

    public MediaFormat getOutputFormat() {
        return this.mFormat;
    }

    public long getLongestDuration() {
        return this.mLongestDurationUs;
    }

    public int getTrackCount() {
        return this.mTrackCount;
    }

    public boolean isDecodeEnd() {
        return this.mDecodeEOS;
    }

    public void setMusicTrack(int i) {
        int i2 = this.mTrackIndex;
        if (i2 == i) {
            return;
        }
        try {
            this.mMediaExtractor.unselectTrack(i2);
            if (selectTrack(i)) {
                try {
                    MediaCodec mediaCodec = this.mMediaCodec;
                    if (mediaCodec != null) {
                        mediaCodec.stop();
                        this.mMediaCodec.release();
                        this.mMediaCodec = null;
                    }
                    if (initMediaCodec()) {
                        try {
                            this.mMediaCodec.start();
                        } catch (Throwable th) {
                            Log.m948e(TAG, "Cannot start the audio codec" + th.getMessage(), th);
                        }
                    }
                } catch (Throwable th2) {
                    Log.m948e(TAG, "Failed to stop media codec: " + th2.getMessage(), th2);
                }
            }
        } catch (Throwable th3) {
            Log.m948e(TAG, "Failed to unselect track: " + th3.getMessage(), th3);
        }
    }

    public int getTotalRawDataSize() {
        return this.mRawDataSize;
    }

    public void stop() {
        MediaExtractor mediaExtractor = this.mMediaExtractor;
        if (mediaExtractor != null) {
            mediaExtractor.release();
            this.mMediaExtractor = null;
        }
        MediaCodec mediaCodec = this.mMediaCodec;
        if (mediaCodec != null) {
            mediaCodec.stop();
            this.mMediaCodec.release();
            this.mMediaCodec = null;
        }
        this.mDecodeEOS = false;
    }
}
