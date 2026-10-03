package net.aihelp.core.p004ui.glide.load.resource.transcode;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.GlideBitmapDrawable;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.GlideBitmapDrawableResource;

public class GlideBitmapDrawableTranscoder implements ResourceTranscoder<Bitmap, GlideBitmapDrawable> {
    private final BitmapPool bitmapPool;
    private final Resources resources;

    public GlideBitmapDrawableTranscoder(Context context) {
        this(context.getResources(), Glide.get(context).getBitmapPool());
    }

    public GlideBitmapDrawableTranscoder(Resources resources, BitmapPool bitmapPool) {
        this.resources = resources;
        this.bitmapPool = bitmapPool;
    }

    @Override
    public Resource<GlideBitmapDrawable> transcode(Resource<Bitmap> resource) {
        return new GlideBitmapDrawableResource(new GlideBitmapDrawable(this.resources, resource.get()), this.bitmapPool);
    }

    @Override
    public String getId() {
        return "GlideBitmapDrawableTranscoder.net.aihelp.core.ui.glide.load.resource.transcode";
    }
}
