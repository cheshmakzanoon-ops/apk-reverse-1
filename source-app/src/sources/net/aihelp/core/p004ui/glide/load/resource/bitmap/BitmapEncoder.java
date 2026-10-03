package net.aihelp.core.p004ui.glide.load.resource.bitmap;

import android.graphics.Bitmap;
import android.util.Log;
import java.io.OutputStream;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.util.LogTime;
import net.aihelp.core.p004ui.glide.util.Util;

public class BitmapEncoder implements ResourceEncoder<Bitmap> {
    private static final int DEFAULT_COMPRESSION_QUALITY = 90;
    private static final String TAG = "BitmapEncoder";
    private Bitmap.CompressFormat compressFormat;
    private int quality;

    public BitmapEncoder() {
        this(null, DEFAULT_COMPRESSION_QUALITY);
    }

    public BitmapEncoder(Bitmap.CompressFormat compressFormat, int i) {
        this.compressFormat = compressFormat;
        this.quality = i;
    }

    @Override
    public boolean encode(Resource<Bitmap> resource, OutputStream outputStream) {
        Bitmap bitmap = resource.get();
        long logTime = LogTime.getLogTime();
        Bitmap.CompressFormat format = getFormat(bitmap);
        bitmap.compress(format, this.quality, outputStream);
        if (!Log.isLoggable(TAG, 2)) {
            return true;
        }
        Log.v(TAG, "Compressed with type: " + format + " of size " + Util.getBitmapByteSize(bitmap) + " in " + LogTime.getElapsedMillis(logTime));
        return true;
    }

    @Override
    public String getId() {
        return "BitmapEncoder.net.aihelp.core.ui.glide.load.resource.bitmap";
    }

    private Bitmap.CompressFormat getFormat(Bitmap bitmap) {
        Bitmap.CompressFormat compressFormat = this.compressFormat;
        if (compressFormat != null) {
            return compressFormat;
        }
        if (bitmap.hasAlpha()) {
            return Bitmap.CompressFormat.PNG;
        }
        return Bitmap.CompressFormat.JPEG;
    }
}
