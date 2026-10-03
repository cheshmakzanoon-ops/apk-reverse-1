package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.graphics.Bitmap;
import android.os.ParcelFileDescriptor;
import java.io.File;
import net.aihelp.core.p004ui.glide.load.DecodeFormat;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.resource.NullEncoder;
import net.aihelp.core.p004ui.glide.load.resource.file.FileToStreamDecoder;
import net.aihelp.core.p004ui.glide.provider.DataLoadProvider;

public class FileDescriptorBitmapDataLoadProvider implements DataLoadProvider<ParcelFileDescriptor, Bitmap> {
    private final ResourceDecoder<File, Bitmap> cacheDecoder;
    private final FileDescriptorBitmapDecoder sourceDecoder;
    private final BitmapEncoder encoder = new BitmapEncoder();
    private final Encoder<ParcelFileDescriptor> sourceEncoder = NullEncoder.get();

    public FileDescriptorBitmapDataLoadProvider(BitmapPool bitmapPool, DecodeFormat decodeFormat) {
        this.cacheDecoder = new FileToStreamDecoder(new StreamBitmapDecoder(bitmapPool, decodeFormat));
        this.sourceDecoder = new FileDescriptorBitmapDecoder(bitmapPool, decodeFormat);
    }

    @Override
    public ResourceDecoder<File, Bitmap> getCacheDecoder() {
        return this.cacheDecoder;
    }

    @Override
    public ResourceDecoder<ParcelFileDescriptor, Bitmap> getSourceDecoder() {
        return this.sourceDecoder;
    }

    @Override
    public Encoder<ParcelFileDescriptor> getSourceEncoder() {
        return this.sourceEncoder;
    }

    @Override
    public ResourceEncoder<Bitmap> getEncoder() {
        return this.encoder;
    }
}
