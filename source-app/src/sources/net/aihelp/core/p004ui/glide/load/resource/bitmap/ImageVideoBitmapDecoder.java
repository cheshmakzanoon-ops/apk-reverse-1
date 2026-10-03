package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.graphics.Bitmap;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import java.io.IOException;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.model.ImageVideoWrapper;

public class ImageVideoBitmapDecoder implements ResourceDecoder<ImageVideoWrapper, Bitmap> {
    private static final String TAG = "ImageVideoDecoder";
    private final ResourceDecoder<ParcelFileDescriptor, Bitmap> fileDescriptorDecoder;
    private final ResourceDecoder<InputStream, Bitmap> streamDecoder;

    public ImageVideoBitmapDecoder(ResourceDecoder<InputStream, Bitmap> resourceDecoder, ResourceDecoder<ParcelFileDescriptor, Bitmap> resourceDecoder2) {
        this.streamDecoder = resourceDecoder;
        this.fileDescriptorDecoder = resourceDecoder2;
    }

    @Override
    public Resource<Bitmap> decode(ImageVideoWrapper imageVideoWrapper, int i, int i2) throws IOException {
        Resource<Bitmap> resourceDecode;
        ParcelFileDescriptor fileDescriptor;
        InputStream stream = imageVideoWrapper.getStream();
        if (stream != null) {
            try {
                resourceDecode = this.streamDecoder.decode(stream, i, i2);
            } catch (IOException e) {
                if (Log.isLoggable(TAG, 2)) {
                    Log.v(TAG, "Failed to load image from stream, trying FileDescriptor", e);
                }
                resourceDecode = null;
            }
        } else {
            resourceDecode = null;
        }
        return (resourceDecode != null || (fileDescriptor = imageVideoWrapper.getFileDescriptor()) == null) ? resourceDecode : this.fileDescriptorDecoder.decode(fileDescriptor, i, i2);
    }

    @Override
    public String getId() {
        return "ImageVideoBitmapDecoder.net.aihelp.core.ui.glide.load.resource.bitmap";
    }
}
