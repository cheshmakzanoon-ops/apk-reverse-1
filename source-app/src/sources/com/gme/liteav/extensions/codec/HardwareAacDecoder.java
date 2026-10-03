package com.gme.liteav.extensions.codec;

import android.media.MediaFormat;
import com.gme.liteav.base.Log;
import java.nio.ByteBuffer;

public class HardwareAacDecoder {

    private final AacMediaCodecWrapper f782a = new AacMediaCodecWrapper(AacMediaCodecWrapper.EnumC1060a.f780b);

    public boolean init(int i, int i2, ByteBuffer byteBuffer) {
        MediaFormat mediaFormatCreateAudioFormat = MediaFormat.createAudioFormat("audio/mp4a-latm", i, i2);
        mediaFormatCreateAudioFormat.setString("mime", "audio/mp4a-latm");
        mediaFormatCreateAudioFormat.setByteBuffer("csd-0", byteBuffer);
        return this.f782a.m1041a(mediaFormatCreateAudioFormat);
    }

    public ByteBuffer decode(ByteBuffer byteBuffer) {
        return this.f782a.processFrame(byteBuffer);
    }

    public int getOutputSampleRate() {
        MediaFormat mediaFormat = this.f782a.f775c;
        if (mediaFormat == null) {
            return -1;
        }
        try {
            return mediaFormat.getInteger("sample-rate");
        } catch (Exception e) {
            Log.m948e("HardwareAacDecoder", "getOutputSampleRate failed. ".concat(String.valueOf(e)), new Object[0]);
            return -1;
        }
    }

    public int getOutputChannelCount() {
        MediaFormat mediaFormat = this.f782a.f775c;
        if (mediaFormat == null) {
            return -1;
        }
        try {
            return mediaFormat.getInteger("channel-count");
        } catch (Exception e) {
            Log.m948e("HardwareAacDecoder", "getOutputChannelCount failed. ".concat(String.valueOf(e)), new Object[0]);
            return -1;
        }
    }

    public int getCacheSize() {
        return this.f782a.f776d;
    }

    public void unInit() {
        this.f782a.m1040a();
    }

    public void reset() {
        AacMediaCodecWrapper aacMediaCodecWrapper = this.f782a;
        if (aacMediaCodecWrapper.f774b != null) {
            try {
                aacMediaCodecWrapper.f774b.stop();
                aacMediaCodecWrapper.f774b.reset();
            } catch (Exception e) {
                Log.m948e(aacMediaCodecWrapper.f773a, "codec stop failed.".concat(String.valueOf(e)), new Object[0]);
                aacMediaCodecWrapper.m1040a();
            }
            aacMediaCodecWrapper.f776d = 0;
            aacMediaCodecWrapper.f775c = null;
        }
    }
}
