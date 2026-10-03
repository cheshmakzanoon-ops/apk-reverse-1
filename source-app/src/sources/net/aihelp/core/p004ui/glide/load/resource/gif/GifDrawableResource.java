package net.aihelp.core.p004ui.glide.load.resource.gif;

import net.aihelp.core.p004ui.glide.load.resource.drawable.DrawableResource;
import net.aihelp.core.p004ui.glide.util.Util;

public class GifDrawableResource extends DrawableResource<GifDrawable> {
    public GifDrawableResource(GifDrawable gifDrawable) {
        super(gifDrawable);
    }

    @Override
    public int getSize() {
        return ((GifDrawable) this.drawable).getData().length + Util.getBitmapByteSize(((GifDrawable) this.drawable).getFirstFrame());
    }

    @Override
    public void recycle() {
        ((GifDrawable) this.drawable).stop();
        ((GifDrawable) this.drawable).recycle();
    }
}
