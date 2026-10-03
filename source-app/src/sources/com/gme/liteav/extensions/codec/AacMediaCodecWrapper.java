package com.gme.liteav.extensions.codec;

import android.media.MediaCodec;
import android.media.MediaCrypto;
import android.media.MediaFormat;
import android.view.Surface;
import com.gme.liteav.base.Log;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.concurrent.TimeUnit;

public class AacMediaCodecWrapper {

    final String f773a;

    MediaCodec f774b;

    MediaFormat f775c;

    int f776d = 0;

    private final int f777e;

    private final MediaCodec.BufferInfo f778f;

    public static final class EnumC1060a {

        public static final int f779a = 1;

        public static final int f780b = 2;

        private static final int[] f781c = {1, 2};
    }

    public AacMediaCodecWrapper(int i) {
        this.f777e = i;
        this.f773a = i == EnumC1060a.f779a ? "HardwareAacEncoder" : "HardwareAacDecoder";
        this.f778f = new MediaCodec.BufferInfo();
    }

    public final boolean m1041a(MediaFormat mediaFormat) {
        if (mediaFormat == null) {
            return false;
        }
        try {
            int i = this.f777e == EnumC1060a.f779a ? 1 : 0;
            if (this.f774b == null) {
                if (i != 0) {
                    this.f774b = MediaCodec.createEncoderByType("audio/mp4a-latm");
                } else {
                    this.f774b = MediaCodec.createDecoderByType("audio/mp4a-latm");
                }
            }
            this.f774b.configure(mediaFormat, (Surface) null, (MediaCrypto) null, i);
            this.f774b.start();
            return true;
        } catch (IOException e) {
            Log.m948e(this.f773a, "create codec failed. ".concat(String.valueOf(e)), new Object[0]);
            m1040a();
            return false;
        }
    }

    public ByteBuffer processFrame(ByteBuffer byteBuffer) {
        MediaCodec mediaCodec = this.f774b;
        if (mediaCodec != null && byteBuffer != null) {
            try {
                ByteBuffer[] inputBuffers = mediaCodec.getInputBuffers();
                if (inputBuffers == null || inputBuffers.length <= 0) {
                    Log.m948e(this.f773a, "get invalid input buffers.", new Object[0]);
                } else {
                    int iDequeueInputBuffer = this.f774b.dequeueInputBuffer(TimeUnit.MILLISECONDS.toMicros(5L));
                    if (iDequeueInputBuffer >= 0) {
                        int iRemaining = byteBuffer.remaining();
                        inputBuffers[iDequeueInputBuffer].put(byteBuffer);
                        this.f774b.queueInputBuffer(iDequeueInputBuffer, 0, iRemaining, 0L, 0);
                        this.f776d++;
                    }
                }
            } catch (Exception e) {
                Log.m948e(this.f773a, "feedData failed. ".concat(String.valueOf(e)), new Object[0]);
            }
            int i = (this.f777e != EnumC1060a.f780b || this.f776d > 2) ? 3 : 1;
            for (int i2 = 0; i2 < i; i2++) {
                ByteBuffer byteBufferM1039b = m1039b();
                if (byteBufferM1039b != null) {
                    return byteBufferM1039b;
                }
            }
        }
        return null;
    }

    private ByteBuffer m1039b() {
        ByteBuffer outputBuffer;
        try {
            int iDequeueOutputBuffer = this.f774b.dequeueOutputBuffer(this.f778f, TimeUnit.MILLISECONDS.toMicros(5L));
            if (iDequeueOutputBuffer == -1) {
                return null;
            }
            if (iDequeueOutputBuffer == -3) {
                Log.m949i(this.f773a, "codec output buffers changed.", new Object[0]);
                return null;
            }
            if (iDequeueOutputBuffer == -2) {
                this.f775c = this.f774b.getOutputFormat();
                Log.m949i(this.f773a, "codec output format changed: " + this.f775c, new Object[0]);
                return null;
            }
            if (iDequeueOutputBuffer < 0) {
                Log.m948e(this.f773a, "unexpected result from dequeueOutputBuffer: ".concat(String.valueOf(iDequeueOutputBuffer)), new Object[0]);
                return null;
            }
            if (LiteavSystemInfo.getSystemOSVersionInt() >= 21) {
                outputBuffer = this.f774b.getOutputBuffer(iDequeueOutputBuffer);
            } else {
                outputBuffer = this.f774b.getOutputBuffers()[iDequeueOutputBuffer];
            }
            ByteBuffer byteBufferAllocateDirect = ByteBuffer.allocateDirect(this.f778f.size);
            byteBufferAllocateDirect.put(outputBuffer);
            this.f774b.releaseOutputBuffer(iDequeueOutputBuffer, false);
            int i = this.f776d;
            if (i > 0) {
                this.f776d = i - 1;
            }
            return byteBufferAllocateDirect;
        } catch (Exception e) {
            Log.m948e(this.f773a, "dequeueOutputBuffer failed. ".concat(String.valueOf(e)), new Object[0]);
            return null;
        }
    }

    public final void m1040a() {
        MediaCodec mediaCodec = this.f774b;
        if (mediaCodec == null) {
            return;
        }
        try {
            mediaCodec.stop();
        } catch (Exception e) {
            Log.m948e(this.f773a, "codec stop failed.".concat(String.valueOf(e)), new Object[0]);
        }
        try {
            this.f774b.release();
        } catch (Exception e2) {
            Log.m948e(this.f773a, "codec release failed.".concat(String.valueOf(e2)), new Object[0]);
        }
        this.f774b = null;
        this.f776d = 0;
    }
}
