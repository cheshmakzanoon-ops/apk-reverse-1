package cz.msebera.android.httpclient.impl.client.cache;

import cz.msebera.android.httpclient.client.cache.HttpCacheEntry;
import cz.msebera.android.httpclient.client.cache.HttpCacheStorage;
import cz.msebera.android.httpclient.client.cache.HttpCacheUpdateCallback;
import java.io.IOException;

public class BasicHttpCacheStorage implements HttpCacheStorage {
    private final CacheMap entries;

    public BasicHttpCacheStorage(CacheConfig cacheConfig) {
        this.entries = new CacheMap(cacheConfig.getMaxCacheEntries());
    }

    @Override
    public synchronized void putEntry(String str, HttpCacheEntry httpCacheEntry) throws IOException {
        this.entries.put(str, httpCacheEntry);
    }

    @Override
    public synchronized HttpCacheEntry getEntry(String str) throws IOException {
        return this.entries.get(str);
    }

    @Override
    public synchronized void removeEntry(String str) throws IOException {
        this.entries.remove(str);
    }

    @Override
    public synchronized void updateEntry(String str, HttpCacheUpdateCallback httpCacheUpdateCallback) throws IOException {
        this.entries.put(str, httpCacheUpdateCallback.update(this.entries.get(str)));
    }
}
