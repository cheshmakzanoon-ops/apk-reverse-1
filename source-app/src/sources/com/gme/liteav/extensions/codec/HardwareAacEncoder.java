package com.gme.liteav.extensions.codec;

import android.media.MediaFormat;
import java.nio.ByteBuffer;

public class HardwareAacEncoder {

    private final AacMediaCodecWrapper f783a = new AacMediaCodecWrapper(AacMediaCodecWrapper.EnumC1060a.f779a);

    public boolean init(int i, int i2, int i3) {
        MediaFormat mediaFormatCreateAudioFormat = MediaFormat.createAudioFormat("audio/mp4a-latm", i, i2);
        mediaFormatCreateAudioFormat.setInteger("bitrate", i3);
        mediaFormatCreateAudioFormat.setInteger("aac-profile", 2);
        return this.f783a.m1041a(mediaFormatCreateAudioFormat);
    }

    public ByteBuffer encode(ByteBuffer byteBuffer) {
        return this.f783a.processFrame(byteBuffer);
    }

    public void unInit() {
        this.f783a.m1040a();
    }
}
