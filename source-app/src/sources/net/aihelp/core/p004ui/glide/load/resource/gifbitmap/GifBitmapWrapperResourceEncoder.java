package net.aihelp.core.p004ui.glide.load.resource.gifbitmap;

import android.graphics.Bitmap;
import java.io.OutputStream;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.resource.gif.GifDrawable;

public class GifBitmapWrapperResourceEncoder implements ResourceEncoder<GifBitmapWrapper> {
    private final ResourceEncoder<Bitmap> bitmapEncoder;
    private final ResourceEncoder<GifDrawable> gifEncoder;

    private String f95id;

    public GifBitmapWrapperResourceEncoder(ResourceEncoder<Bitmap> resourceEncoder, ResourceEncoder<GifDrawable> resourceEncoder2) {
        this.bitmapEncoder = resourceEncoder;
        this.gifEncoder = resourceEncoder2;
    }

    @Override
    public boolean encode(Resource<GifBitmapWrapper> resource, OutputStream outputStream) {
        GifBitmapWrapper gifBitmapWrapper = resource.get();
        Resource<Bitmap> bitmapResource = gifBitmapWrapper.getBitmapResource();
        if (bitmapResource != null) {
            return this.bitmapEncoder.encode(bitmapResource, outputStream);
        }
        return this.gifEncoder.encode(gifBitmapWrapper.getGifResource(), outputStream);
    }

    @Override
    public String getId() {
        if (this.f95id == null) {
            this.f95id = this.bitmapEncoder.getId() + this.gifEncoder.getId();
        }
        return this.f95id;
    }
}
