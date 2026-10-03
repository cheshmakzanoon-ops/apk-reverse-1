package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.graphics.Bitmap;
import java.io.File;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.DecodeFormat;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.model.StreamEncoder;
import net.aihelp.core.p004ui.glide.load.resource.file.FileToStreamDecoder;
import net.aihelp.core.p004ui.glide.provider.DataLoadProvider;

public class StreamBitmapDataLoadProvider implements DataLoadProvider<InputStream, Bitmap> {
    private final FileToStreamDecoder<Bitmap> cacheDecoder;
    private final StreamBitmapDecoder decoder;
    private final BitmapEncoder encoder;
    private final StreamEncoder sourceEncoder = new StreamEncoder();

    public StreamBitmapDataLoadProvider(BitmapPool bitmapPool, DecodeFormat decodeFormat) {
        StreamBitmapDecoder streamBitmapDecoder = new StreamBitmapDecoder(bitmapPool, decodeFormat);
        this.decoder = streamBitmapDecoder;
        this.encoder = new BitmapEncoder();
        this.cacheDecoder = new FileToStreamDecoder<>(streamBitmapDecoder);
    }

    @Override
    public ResourceDecoder<File, Bitmap> getCacheDecoder() {
        return this.cacheDecoder;
    }

    @Override
    public ResourceDecoder<InputStream, Bitmap> getSourceDecoder() {
        return this.decoder;
    }

    @Override
    public Encoder<InputStream> getSourceEncoder() {
        return this.sourceEncoder;
    }

    @Override
    public ResourceEncoder<Bitmap> getEncoder() {
        return this.encoder;
    }
}
