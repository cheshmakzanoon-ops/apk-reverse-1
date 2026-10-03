package net.aihelp.core.p004ui.glide;

import android.content.Context;
import java.util.concurrent.ExecutorService;
import net.aihelp.core.p004ui.glide.load.DecodeFormat;
import net.aihelp.core.p004ui.glide.load.engine.Engine;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.LruBitmapPool;
import net.aihelp.core.p004ui.glide.load.engine.cache.DiskCache;
import net.aihelp.core.p004ui.glide.load.engine.cache.InternalCacheDiskCacheFactory;
import net.aihelp.core.p004ui.glide.load.engine.cache.LruResourceCache;
import net.aihelp.core.p004ui.glide.load.engine.cache.MemoryCache;
import net.aihelp.core.p004ui.glide.load.engine.cache.MemorySizeCalculator;
import net.aihelp.core.p004ui.glide.load.engine.executor.FifoPriorityThreadPoolExecutor;

public class GlideBuilder {
    private BitmapPool bitmapPool;
    private final Context context;
    private DecodeFormat decodeFormat;
    private DiskCache.Factory diskCacheFactory;
    private ExecutorService diskCacheService;
    private Engine engine;
    private MemoryCache memoryCache;
    private ExecutorService sourceService;

    public GlideBuilder(Context context) {
        this.context = context.getApplicationContext();
    }

    public GlideBuilder setBitmapPool(BitmapPool bitmapPool) {
        this.bitmapPool = bitmapPool;
        return this;
    }

    public GlideBuilder setMemoryCache(MemoryCache memoryCache) {
        this.memoryCache = memoryCache;
        return this;
    }

    @Deprecated
    public GlideBuilder setDiskCache(final DiskCache diskCache) {
        return setDiskCache(new DiskCache.Factory() {
            @Override
            public DiskCache build() {
                return diskCache;
            }
        });
    }

    public GlideBuilder setDiskCache(DiskCache.Factory factory) {
        this.diskCacheFactory = factory;
        return this;
    }

    public GlideBuilder setResizeService(ExecutorService executorService) {
        this.sourceService = executorService;
        return this;
    }

    public GlideBuilder setDiskCacheService(ExecutorService executorService) {
        this.diskCacheService = executorService;
        return this;
    }

    public GlideBuilder setDecodeFormat(DecodeFormat decodeFormat) {
        this.decodeFormat = decodeFormat;
        return this;
    }

    GlideBuilder setEngine(Engine engine) {
        this.engine = engine;
        return this;
    }

    Glide createGlide() {
        if (this.sourceService == null) {
            this.sourceService = new FifoPriorityThreadPoolExecutor(Math.max(1, Runtime.getRuntime().availableProcessors()));
        }
        if (this.diskCacheService == null) {
            this.diskCacheService = new FifoPriorityThreadPoolExecutor(1);
        }
        MemorySizeCalculator memorySizeCalculator = new MemorySizeCalculator(this.context);
        if (this.bitmapPool == null) {
            this.bitmapPool = new LruBitmapPool(memorySizeCalculator.getBitmapPoolSize());
        }
        if (this.memoryCache == null) {
            this.memoryCache = new LruResourceCache(memorySizeCalculator.getMemoryCacheSize());
        }
        if (this.diskCacheFactory == null) {
            this.diskCacheFactory = new InternalCacheDiskCacheFactory(this.context);
        }
        if (this.engine == null) {
            this.engine = new Engine(this.memoryCache, this.diskCacheFactory, this.diskCacheService, this.sourceService);
        }
        if (this.decodeFormat == null) {
            this.decodeFormat = DecodeFormat.DEFAULT;
        }
        return new Glide(this.engine, this.memoryCache, this.bitmapPool, this.context, this.decodeFormat);
    }
}
