package net.aihelp.core.p004ui.glide.load.engine.cache;

import java.io.File;

public class DiskLruCacheFactory implements DiskCache.Factory {
    private final CacheDirectoryGetter cacheDirectoryGetter;
    private final int diskCacheSize;

    public interface CacheDirectoryGetter {
        File getCacheDirectory();
    }

    public DiskLruCacheFactory(final String str, int i) {
        this(new CacheDirectoryGetter() {
            @Override
            public File getCacheDirectory() {
                return new File(str);
            }
        }, i);
    }

    public DiskLruCacheFactory(final String str, final String str2, int i) {
        this(new CacheDirectoryGetter() {
            @Override
            public File getCacheDirectory() {
                return new File(str, str2);
            }
        }, i);
    }

    public DiskLruCacheFactory(CacheDirectoryGetter cacheDirectoryGetter, int i) {
        this.diskCacheSize = i;
        this.cacheDirectoryGetter = cacheDirectoryGetter;
    }

    @Override
    public DiskCache build() {
        File cacheDirectory = this.cacheDirectoryGetter.getCacheDirectory();
        if (cacheDirectory == null) {
            return null;
        }
        if (cacheDirectory.mkdirs() || (cacheDirectory.exists() && cacheDirectory.isDirectory())) {
            return DiskLruCacheWrapper.get(cacheDirectory, this.diskCacheSize);
        }
        return null;
    }
}
