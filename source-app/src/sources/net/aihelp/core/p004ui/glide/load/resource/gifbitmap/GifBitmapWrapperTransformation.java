package net.aihelp.core.p004ui.glide.load.resource.gifbitmap;

import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.gif.GifDrawable;
import net.aihelp.core.p004ui.glide.load.resource.gif.GifDrawableTransformation;

public class GifBitmapWrapperTransformation implements Transformation<GifBitmapWrapper> {
    private final Transformation<Bitmap> bitmapTransformation;
    private final Transformation<GifDrawable> gifDataTransformation;

    public GifBitmapWrapperTransformation(BitmapPool bitmapPool, Transformation<Bitmap> transformation) {
        this(transformation, new GifDrawableTransformation(transformation, bitmapPool));
    }

    GifBitmapWrapperTransformation(Transformation<Bitmap> transformation, Transformation<GifDrawable> transformation2) {
        this.bitmapTransformation = transformation;
        this.gifDataTransformation = transformation2;
    }

    @Override
    public Resource<GifBitmapWrapper> transform(Resource<GifBitmapWrapper> resource, int i, int i2) {
        Transformation<GifDrawable> transformation;
        Transformation<Bitmap> transformation2;
        Resource<Bitmap> bitmapResource = resource.get().getBitmapResource();
        Resource<GifDrawable> gifResource = resource.get().getGifResource();
        if (bitmapResource != null && (transformation2 = this.bitmapTransformation) != null) {
            Resource<Bitmap> resourceTransform = transformation2.transform(bitmapResource, i, i2);
            return !bitmapResource.equals(resourceTransform) ? new GifBitmapWrapperResource(new GifBitmapWrapper(resourceTransform, resource.get().getGifResource())) : resource;
        }
        if (gifResource == null || (transformation = this.gifDataTransformation) == null) {
            return resource;
        }
        Resource<GifDrawable> resourceTransform2 = transformation.transform(gifResource, i, i2);
        return !gifResource.equals(resourceTransform2) ? new GifBitmapWrapperResource(new GifBitmapWrapper(resource.get().getBitmapResource(), resourceTransform2)) : resource;
    }

    @Override
    public String getId() {
        return this.bitmapTransformation.getId();
    }
}
