package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.graphics.drawable.BitmapDrawable;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.drawable.DrawableResource;
import net.aihelp.core.p004ui.glide.util.Util;

public class BitmapDrawableResource extends DrawableResource<BitmapDrawable> {
    private final BitmapPool bitmapPool;

    public BitmapDrawableResource(BitmapDrawable bitmapDrawable, BitmapPool bitmapPool) {
        super(bitmapDrawable);
        this.bitmapPool = bitmapPool;
    }

    @Override
    public int getSize() {
        return Util.getBitmapByteSize(((BitmapDrawable) this.drawable).getBitmap());
    }

    @Override
    public void recycle() {
        this.bitmapPool.put(((BitmapDrawable) this.drawable).getBitmap());
    }
}
