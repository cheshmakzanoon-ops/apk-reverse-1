package net.aihelp.core.p004ui.glide.load.engine.cache;

import java.io.File;
import net.aihelp.core.p004ui.glide.load.Key;

public class DiskCacheAdapter implements DiskCache {
    @Override
    public void clear() {
    }

    @Override
    public void delete(Key key) {
    }

    @Override
    public File get(Key key) {
        return null;
    }

    @Override
    public void put(Key key, DiskCache.Writer writer) {
    }
}
