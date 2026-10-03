package net.aihelp.core.p004ui.glide.load.resource.gif;

import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.BitmapResource;

public class GifDrawableTransformation implements Transformation<GifDrawable> {
    private final BitmapPool bitmapPool;
    private final Transformation<Bitmap> wrapped;

    public GifDrawableTransformation(Transformation<Bitmap> transformation, BitmapPool bitmapPool) {
        this.wrapped = transformation;
        this.bitmapPool = bitmapPool;
    }

    @Override
    public Resource<GifDrawable> transform(Resource<GifDrawable> resource, int i, int i2) {
        GifDrawable gifDrawable = resource.get();
        Bitmap firstFrame = resource.get().getFirstFrame();
        Bitmap bitmap = this.wrapped.transform(new BitmapResource(firstFrame, this.bitmapPool), i, i2).get();
        return !bitmap.equals(firstFrame) ? new GifDrawableResource(new GifDrawable(gifDrawable, bitmap, this.wrapped)) : resource;
    }

    @Override
    public String getId() {
        return this.wrapped.getId();
    }
}
