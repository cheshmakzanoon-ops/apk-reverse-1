package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.util.Util;

public class BitmapResource implements Resource<Bitmap> {
    private final Bitmap bitmap;
    private final BitmapPool bitmapPool;

    public static BitmapResource obtain(Bitmap bitmap, BitmapPool bitmapPool) {
        if (bitmap == null) {
            return null;
        }
        return new BitmapResource(bitmap, bitmapPool);
    }

    public BitmapResource(Bitmap bitmap, BitmapPool bitmapPool) {
        if (bitmap == null) {
            throw new NullPointerException("Bitmap must not be null");
        }
        if (bitmapPool == null) {
            throw new NullPointerException("BitmapPool must not be null");
        }
        this.bitmap = bitmap;
        this.bitmapPool = bitmapPool;
    }

    @Override
    public Bitmap get() {
        return this.bitmap;
    }

    @Override
    public int getSize() {
        return Util.getBitmapByteSize(this.bitmap);
    }

    @Override
    public void recycle() {
        if (this.bitmapPool.put(this.bitmap)) {
            return;
        }
        this.bitmap.recycle();
    }
}
