package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.drawable.DrawableResource;
import net.aihelp.core.p004ui.glide.util.Util;

public class GlideBitmapDrawableResource extends DrawableResource<GlideBitmapDrawable> {
    private final BitmapPool bitmapPool;

    public GlideBitmapDrawableResource(GlideBitmapDrawable glideBitmapDrawable, BitmapPool bitmapPool) {
        super(glideBitmapDrawable);
        this.bitmapPool = bitmapPool;
    }

    @Override
    public int getSize() {
        return Util.getBitmapByteSize(((GlideBitmapDrawable) this.drawable).getBitmap());
    }

    @Override
    public void recycle() {
        this.bitmapPool.put(((GlideBitmapDrawable) this.drawable).getBitmap());
    }
}
