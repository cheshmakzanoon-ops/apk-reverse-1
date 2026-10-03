package net.aihelp.core.p004ui.glide.load.resource.transcode;

import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.resource.bytes.BytesResource;
import net.aihelp.core.p004ui.glide.load.resource.gif.GifDrawable;

public class GifDrawableBytesTranscoder implements ResourceTranscoder<GifDrawable, byte[]> {
    @Override
    public Resource<byte[]> transcode(Resource<GifDrawable> resource) {
        return new BytesResource(resource.get().getData());
    }

    @Override
    public String getId() {
        return "GifDrawableBytesTranscoder.net.aihelp.core.ui.glide.load.resource.transcode";
    }
}
