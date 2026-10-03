package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.os.ParcelFileDescriptor;
import java.io.IOException;
import net.aihelp.core.p004ui.glide.load.DecodeFormat;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;

public class VideoBitmapDecoder implements BitmapDecoder<ParcelFileDescriptor> {
    private static final MediaMetadataRetrieverFactory DEFAULT_FACTORY = new MediaMetadataRetrieverFactory();
    private static final int NO_FRAME = -1;
    private MediaMetadataRetrieverFactory factory;
    private int frame;

    public VideoBitmapDecoder() {
        this(DEFAULT_FACTORY, -1);
    }

    public VideoBitmapDecoder(int i) {
        this(DEFAULT_FACTORY, checkValidFrame(i));
    }

    VideoBitmapDecoder(MediaMetadataRetrieverFactory mediaMetadataRetrieverFactory) {
        this(mediaMetadataRetrieverFactory, -1);
    }

    VideoBitmapDecoder(MediaMetadataRetrieverFactory mediaMetadataRetrieverFactory, int i) {
        this.factory = mediaMetadataRetrieverFactory;
        this.frame = i;
    }

    @Override
    public Bitmap decode(ParcelFileDescriptor parcelFileDescriptor, BitmapPool bitmapPool, int i, int i2, DecodeFormat decodeFormat) throws IOException {
        Bitmap frameAtTime;
        MediaMetadataRetriever mediaMetadataRetrieverBuild = this.factory.build();
        mediaMetadataRetrieverBuild.setDataSource(parcelFileDescriptor.getFileDescriptor());
        int i3 = this.frame;
        if (i3 >= 0) {
            frameAtTime = mediaMetadataRetrieverBuild.getFrameAtTime(i3);
        } else {
            frameAtTime = mediaMetadataRetrieverBuild.getFrameAtTime();
        }
        mediaMetadataRetrieverBuild.release();
        parcelFileDescriptor.close();
        return frameAtTime;
    }

    @Override
    public String getId() {
        return "VideoBitmapDecoder.net.aihelp.core.ui.glide.load.resource.bitmap";
    }

    static class MediaMetadataRetrieverFactory {
        MediaMetadataRetrieverFactory() {
        }

        public MediaMetadataRetriever build() {
            return new MediaMetadataRetriever();
        }
    }

    private static int checkValidFrame(int i) {
        if (i >= 0) {
            return i;
        }
        throw new IllegalArgumentException("Requested frame must be non-negative");
    }
}
