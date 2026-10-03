package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.content.Context;
import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;

public class FitCenter extends BitmapTransformation {
    public FitCenter(Context context) {
        super(context);
    }

    public FitCenter(BitmapPool bitmapPool) {
        super(bitmapPool);
    }

    @Override
    protected Bitmap transform(BitmapPool bitmapPool, Bitmap bitmap, int i, int i2) {
        return TransformationUtils.fitCenter(bitmap, bitmapPool, i, i2);
    }

    @Override
    public String getId() {
        return "FitCenter.net.aihelp.core.ui.glide.load.resource.bitmap";
    }
}
