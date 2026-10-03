package net.aihelp.core.p004ui.glide.load.model;

import android.util.Log;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.util.ByteArrayPool;

public class StreamEncoder implements Encoder<InputStream> {
    private static final String TAG = "StreamEncoder";

    @Override
    public boolean encode(InputStream inputStream, OutputStream outputStream) {
        byte[] bytes = ByteArrayPool.get().getBytes();
        while (true) {
            try {
                try {
                    int i = inputStream.read(bytes);
                    if (i != -1) {
                        outputStream.write(bytes, 0, i);
                    } else {
                        ByteArrayPool.get().releaseBytes(bytes);
                        return true;
                    }
                } catch (IOException e) {
                    if (Log.isLoggable(TAG, 3)) {
                        Log.d(TAG, "Failed to encode data onto the OutputStream", e);
                    }
                    ByteArrayPool.get().releaseBytes(bytes);
                    return false;
                }
            } catch (Throwable th) {
                ByteArrayPool.get().releaseBytes(bytes);
                throw th;
            }
            ByteArrayPool.get().releaseBytes(bytes);
            throw th;
        }
    }

    @Override
    public String getId() {
        return "";
    }
}
