package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.content.Context;
import android.graphics.Bitmap;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.DecodeFormat;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;

public class StreamBitmapDecoder implements ResourceDecoder<InputStream, Bitmap> {

    private static final String f92ID = "StreamBitmapDecoder.net.aihelp.core.ui.glide.load.resource.bitmap";
    private BitmapPool bitmapPool;
    private DecodeFormat decodeFormat;
    private final Downsampler downsampler;

    private String f93id;

    public StreamBitmapDecoder(Context context) {
        this(Glide.get(context).getBitmapPool());
    }

    public StreamBitmapDecoder(BitmapPool bitmapPool) {
        this(bitmapPool, DecodeFormat.DEFAULT);
    }

    public StreamBitmapDecoder(Context context, DecodeFormat decodeFormat) {
        this(Glide.get(context).getBitmapPool(), decodeFormat);
    }

    public StreamBitmapDecoder(BitmapPool bitmapPool, DecodeFormat decodeFormat) {
        this(Downsampler.AT_LEAST, bitmapPool, decodeFormat);
    }

    public StreamBitmapDecoder(Downsampler downsampler, BitmapPool bitmapPool, DecodeFormat decodeFormat) {
        this.downsampler = downsampler;
        this.bitmapPool = bitmapPool;
        this.decodeFormat = decodeFormat;
    }

    @Override
    public Resource<Bitmap> decode(InputStream inputStream, int i, int i2) {
        return BitmapResource.obtain(this.downsampler.decode(inputStream, this.bitmapPool, i, i2, this.decodeFormat), this.bitmapPool);
    }

    @Override
    public String getId() {
        if (this.f93id == null) {
            this.f93id = f92ID + this.downsampler.getId() + this.decodeFormat.name();
        }
        return this.f93id;
    }
}
