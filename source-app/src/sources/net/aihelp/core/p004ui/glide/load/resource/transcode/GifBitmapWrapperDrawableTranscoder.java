package net.aihelp.core.p004ui.glide.load.resource.transcode;

import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.GlideBitmapDrawable;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;
import net.aihelp.core.p004ui.glide.load.resource.gifbitmap.GifBitmapWrapper;

public class GifBitmapWrapperDrawableTranscoder implements ResourceTranscoder<GifBitmapWrapper, GlideDrawable> {
    private final ResourceTranscoder<Bitmap, GlideBitmapDrawable> bitmapDrawableResourceTranscoder;

    public GifBitmapWrapperDrawableTranscoder(ResourceTranscoder<Bitmap, GlideBitmapDrawable> resourceTranscoder) {
        this.bitmapDrawableResourceTranscoder = resourceTranscoder;
    }

    @Override
    public Resource<GlideDrawable> transcode(Resource<GifBitmapWrapper> resource) {
        GifBitmapWrapper gifBitmapWrapper = resource.get();
        Resource<Bitmap> bitmapResource = gifBitmapWrapper.getBitmapResource();
        if (bitmapResource != null) {
            return this.bitmapDrawableResourceTranscoder.transcode(bitmapResource);
        }
        return gifBitmapWrapper.getGifResource();
    }

    @Override
    public String getId() {
        return "GifBitmapWrapperDrawableTranscoder.net.aihelp.core.ui.glide.load.resource.transcode";
    }
}
