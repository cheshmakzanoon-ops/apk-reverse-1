package net.aihelp.core.p004ui.glide.load.resource.gif;

import android.content.Context;
import java.io.File;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.model.StreamEncoder;
import net.aihelp.core.p004ui.glide.load.resource.file.FileToStreamDecoder;
import net.aihelp.core.p004ui.glide.provider.DataLoadProvider;

public class GifDrawableLoadProvider implements DataLoadProvider<InputStream, GifDrawable> {
    private final FileToStreamDecoder<GifDrawable> cacheDecoder;
    private final GifResourceDecoder decoder;
    private final GifResourceEncoder encoder;
    private final StreamEncoder sourceEncoder;

    public GifDrawableLoadProvider(Context context, BitmapPool bitmapPool) {
        GifResourceDecoder gifResourceDecoder = new GifResourceDecoder(context, bitmapPool);
        this.decoder = gifResourceDecoder;
        this.cacheDecoder = new FileToStreamDecoder<>(gifResourceDecoder);
        this.encoder = new GifResourceEncoder(bitmapPool);
        this.sourceEncoder = new StreamEncoder();
    }

    @Override
    public ResourceDecoder<File, GifDrawable> getCacheDecoder() {
        return this.cacheDecoder;
    }

    @Override
    public ResourceDecoder<InputStream, GifDrawable> getSourceDecoder() {
        return this.decoder;
    }

    @Override
    public Encoder<InputStream> getSourceEncoder() {
        return this.sourceEncoder;
    }

    @Override
    public ResourceEncoder<GifDrawable> getEncoder() {
        return this.encoder;
    }
}
