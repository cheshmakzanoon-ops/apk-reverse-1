package net.aihelp.core.p004ui.glide.load.resource.gifbitmap;

import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.resource.gif.GifDrawable;

public class GifBitmapWrapper {
    private final Resource<Bitmap> bitmapResource;
    private final Resource<GifDrawable> gifResource;

    public GifBitmapWrapper(Resource<Bitmap> resource, Resource<GifDrawable> resource2) {
        if (resource != null && resource2 != null) {
            throw new IllegalArgumentException("Can only contain either a bitmap resource or a gif resource, not both");
        }
        if (resource == null && resource2 == null) {
            throw new IllegalArgumentException("Must contain either a bitmap resource or a gif resource");
        }
        this.bitmapResource = resource;
        this.gifResource = resource2;
    }

    public int getSize() {
        Resource<Bitmap> resource = this.bitmapResource;
        if (resource != null) {
            return resource.getSize();
        }
        return this.gifResource.getSize();
    }

    public Resource<Bitmap> getBitmapResource() {
        return this.bitmapResource;
    }

    public Resource<GifDrawable> getGifResource() {
        return this.gifResource;
    }
}
