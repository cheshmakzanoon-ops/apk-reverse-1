package net.aihelp.core.p004ui.glide.load.model;

import android.os.ParcelFileDescriptor;
import java.io.InputStream;
import java.io.OutputStream;
import net.aihelp.core.p004ui.glide.load.Encoder;

public class ImageVideoWrapperEncoder implements Encoder<ImageVideoWrapper> {
    private final Encoder<ParcelFileDescriptor> fileDescriptorEncoder;

    private String f89id;
    private final Encoder<InputStream> streamEncoder;

    public ImageVideoWrapperEncoder(Encoder<InputStream> encoder, Encoder<ParcelFileDescriptor> encoder2) {
        this.streamEncoder = encoder;
        this.fileDescriptorEncoder = encoder2;
    }

    @Override
    public boolean encode(ImageVideoWrapper imageVideoWrapper, OutputStream outputStream) {
        if (imageVideoWrapper.getStream() != null) {
            return this.streamEncoder.encode(imageVideoWrapper.getStream(), outputStream);
        }
        return this.fileDescriptorEncoder.encode(imageVideoWrapper.getFileDescriptor(), outputStream);
    }

    @Override
    public String getId() {
        if (this.f89id == null) {
            this.f89id = this.streamEncoder.getId() + this.fileDescriptorEncoder.getId();
        }
        return this.f89id;
    }
}
