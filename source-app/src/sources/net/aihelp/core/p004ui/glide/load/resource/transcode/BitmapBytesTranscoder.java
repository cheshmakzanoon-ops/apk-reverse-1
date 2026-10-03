package net.aihelp.core.p004ui.glide.load.resource.transcode;

import android.graphics.Bitmap;
import java.io.ByteArrayOutputStream;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.resource.bytes.BytesResource;

public class BitmapBytesTranscoder implements ResourceTranscoder<Bitmap, byte[]> {
    private final Bitmap.CompressFormat compressFormat;
    private final int quality;

    public BitmapBytesTranscoder() {
        this(Bitmap.CompressFormat.JPEG, 100);
    }

    public BitmapBytesTranscoder(Bitmap.CompressFormat compressFormat, int i) {
        this.compressFormat = compressFormat;
        this.quality = i;
    }

    @Override
    public Resource<byte[]> transcode(Resource<Bitmap> resource) {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        resource.get().compress(this.compressFormat, this.quality, byteArrayOutputStream);
        resource.recycle();
        return new BytesResource(byteArrayOutputStream.toByteArray());
    }

    @Override
    public String getId() {
        return "BitmapBytesTranscoder.net.aihelp.core.ui.glide.load.resource.transcode";
    }
}
