package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.DecodeFormat;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;

public interface BitmapDecoder<T> {
    Bitmap decode(T t, BitmapPool bitmapPool, int i, int i2, DecodeFormat decodeFormat) throws Exception;

    String getId();
}
