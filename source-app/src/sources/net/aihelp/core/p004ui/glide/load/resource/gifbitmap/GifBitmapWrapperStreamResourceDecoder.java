package net.aihelp.core.p004ui.glide.load.resource.gifbitmap;

import java.io.IOException;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.model.ImageVideoWrapper;

public class GifBitmapWrapperStreamResourceDecoder implements ResourceDecoder<InputStream, GifBitmapWrapper> {
    private final ResourceDecoder<ImageVideoWrapper, GifBitmapWrapper> gifBitmapDecoder;

    public GifBitmapWrapperStreamResourceDecoder(ResourceDecoder<ImageVideoWrapper, GifBitmapWrapper> resourceDecoder) {
        this.gifBitmapDecoder = resourceDecoder;
    }

    @Override
    public Resource<GifBitmapWrapper> decode(InputStream inputStream, int i, int i2) throws IOException {
        return this.gifBitmapDecoder.decode(new ImageVideoWrapper(inputStream, null), i, i2);
    }

    @Override
    public String getId() {
        return this.gifBitmapDecoder.getId();
    }
}
