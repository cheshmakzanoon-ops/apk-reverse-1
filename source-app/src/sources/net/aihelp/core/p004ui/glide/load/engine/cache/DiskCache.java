package net.aihelp.core.p004ui.glide.load.engine.cache;

import java.io.File;
import net.aihelp.core.p004ui.glide.load.Key;

public interface DiskCache {

    public interface Factory {
        public static final String DEFAULT_DISK_CACHE_DIR = "image_manager_disk_cache";
        public static final int DEFAULT_DISK_CACHE_SIZE = 262144000;

        DiskCache build();
    }

    public interface Writer {
        boolean write(File file);
    }

    void clear();

    void delete(Key key);

    File get(Key key);

    void put(Key key, Writer writer);
}
