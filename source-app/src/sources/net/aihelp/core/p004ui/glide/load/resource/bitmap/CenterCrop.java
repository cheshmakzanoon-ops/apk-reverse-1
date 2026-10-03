package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.content.Context;
import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;

public class CenterCrop extends BitmapTransformation {
    public CenterCrop(Context context) {
        super(context);
    }

    public CenterCrop(BitmapPool bitmapPool) {
        super(bitmapPool);
    }

    @Override
    protected Bitmap transform(BitmapPool bitmapPool, Bitmap bitmap, int i, int i2) {
        Bitmap bitmap2 = bitmapPool.get(i, i2, bitmap.getConfig() != null ? bitmap.getConfig() : Bitmap.Config.ARGB_8888);
        Bitmap bitmapCenterCrop = TransformationUtils.centerCrop(bitmap2, bitmap, i, i2);
        if (bitmap2 != null && bitmap2 != bitmapCenterCrop && !bitmapPool.put(bitmap2)) {
            bitmap2.recycle();
        }
        return bitmapCenterCrop;
    }

    @Override
    public String getId() {
        return "CenterCrop.net.aihelp.core.ui.glide.load.resource.bitmap";
    }
}
