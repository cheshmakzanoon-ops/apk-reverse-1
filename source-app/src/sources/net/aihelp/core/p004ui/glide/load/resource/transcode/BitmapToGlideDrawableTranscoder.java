package net.aihelp.core.p004ui.glide.load.resource.transcode;

import android.content.Context;
import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;

public class BitmapToGlideDrawableTranscoder implements ResourceTranscoder<Bitmap, GlideDrawable> {
    private final GlideBitmapDrawableTranscoder glideBitmapDrawableTranscoder;

    public BitmapToGlideDrawableTranscoder(Context context) {
        this(new GlideBitmapDrawableTranscoder(context));
    }

    public BitmapToGlideDrawableTranscoder(GlideBitmapDrawableTranscoder glideBitmapDrawableTranscoder) {
        this.glideBitmapDrawableTranscoder = glideBitmapDrawableTranscoder;
    }

    @Override
    public Resource<GlideDrawable> transcode(Resource<Bitmap> resource) {
        return this.glideBitmapDrawableTranscoder.transcode(resource);
    }

    @Override
    public String getId() {
        return this.glideBitmapDrawableTranscoder.getId();
    }
}
