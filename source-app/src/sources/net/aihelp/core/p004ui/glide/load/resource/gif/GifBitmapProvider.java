package net.aihelp.core.p004ui.glide.load.resource.gif;

import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.gifdecoder.GifDecoder;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;

class GifBitmapProvider implements GifDecoder.BitmapProvider {
    private final BitmapPool bitmapPool;

    public GifBitmapProvider(BitmapPool bitmapPool) {
        this.bitmapPool = bitmapPool;
    }

    @Override
    public Bitmap obtain(int i, int i2, Bitmap.Config config) {
        return this.bitmapPool.getDirty(i, i2, config);
    }

    @Override
    public void release(Bitmap bitmap) {
        if (this.bitmapPool.put(bitmap)) {
            return;
        }
        bitmap.recycle();
    }
}
