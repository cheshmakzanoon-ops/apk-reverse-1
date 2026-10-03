package net.aihelp.core.p004ui.glide.load.engine;

import android.util.Log;
import java.io.File;
import java.io.IOException;
import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.engine.cache.DiskCache;

class CacheLoader {
    private static final String TAG = "CacheLoader";
    private final DiskCache diskCache;

    public CacheLoader(DiskCache diskCache) {
        this.diskCache = diskCache;
    }

    public <Z> Resource<Z> load(Key key, ResourceDecoder<File, Z> resourceDecoder, int i, int i2) {
        File file = this.diskCache.get(key);
        Resource<Z> resourceDecode = null;
        if (file == null) {
            return null;
        }
        try {
            resourceDecode = resourceDecoder.decode(file, i, i2);
        } catch (IOException e) {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Exception decoding image from cache", e);
            }
        }
        if (resourceDecode == null) {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Failed to decode image from cache or not present in cache");
            }
            this.diskCache.delete(key);
        }
        return resourceDecode;
    }
}
