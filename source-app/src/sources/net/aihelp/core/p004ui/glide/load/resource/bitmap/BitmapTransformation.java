package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.content.Context;
import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.util.Util;

public abstract class BitmapTransformation implements Transformation<Bitmap> {
    private BitmapPool bitmapPool;

    protected abstract Bitmap transform(BitmapPool bitmapPool, Bitmap bitmap, int i, int i2);

    public BitmapTransformation(Context context) {
        this(Glide.get(context).getBitmapPool());
    }

    public BitmapTransformation(BitmapPool bitmapPool) {
        this.bitmapPool = bitmapPool;
    }

    @Override
    public final Resource<Bitmap> transform(Resource<Bitmap> resource, int i, int i2) {
        if (!Util.isValidDimensions(i, i2)) {
            throw new IllegalArgumentException("Cannot apply transformation on width: " + i + " or height: " + i2 + " less than or equal to zero and not Target.SIZE_ORIGINAL");
        }
        Bitmap bitmap = resource.get();
        if (i == Integer.MIN_VALUE) {
            i = bitmap.getWidth();
        }
        if (i2 == Integer.MIN_VALUE) {
            i2 = bitmap.getHeight();
        }
        Bitmap bitmapTransform = transform(this.bitmapPool, bitmap, i, i2);
        return bitmap.equals(bitmapTransform) ? resource : BitmapResource.obtain(bitmapTransform, this.bitmapPool);
    }
}
