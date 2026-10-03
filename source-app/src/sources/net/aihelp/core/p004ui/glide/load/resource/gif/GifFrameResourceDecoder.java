package net.aihelp.core.p004ui.glide.load.resource.gif;

import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.gifdecoder.GifDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.BitmapResource;

class GifFrameResourceDecoder implements ResourceDecoder<GifDecoder, Bitmap> {
    private final BitmapPool bitmapPool;

    public GifFrameResourceDecoder(BitmapPool bitmapPool) {
        this.bitmapPool = bitmapPool;
    }

    @Override
    public Resource<Bitmap> decode(GifDecoder gifDecoder, int i, int i2) {
        return BitmapResource.obtain(gifDecoder.getNextFrame(), this.bitmapPool);
    }

    @Override
    public String getId() {
        return "GifFrameResourceDecoder.net.aihelp.core.ui.glide.load.resource.gif";
    }
}
