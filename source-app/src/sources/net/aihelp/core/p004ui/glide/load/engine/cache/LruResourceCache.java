package net.aihelp.core.p004ui.glide.load.engine.cache;

import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.util.LruCache;

public class LruResourceCache extends LruCache<Key, Resource<?>> implements MemoryCache {
    private MemoryCache.ResourceRemovedListener listener;

    @Override
    public Resource put(Key key, Resource resource) {
        return (Resource) super.put(key, resource);
    }

    @Override
    public Resource remove(Key key) {
        return (Resource) super.remove(key);
    }

    public LruResourceCache(int i) {
        super(i);
    }

    @Override
    public void setResourceRemovedListener(MemoryCache.ResourceRemovedListener resourceRemovedListener) {
        this.listener = resourceRemovedListener;
    }

    @Override
    public void onItemEvicted(Key key, Resource<?> resource) {
        MemoryCache.ResourceRemovedListener resourceRemovedListener = this.listener;
        if (resourceRemovedListener != null) {
            resourceRemovedListener.onResourceRemoved(resource);
        }
    }

    @Override
    public int getSize(Resource<?> resource) {
        return resource.getSize();
    }

    @Override
    public void trimMemory(int i) {
        if (i >= 60) {
            clearMemory();
        } else if (i >= 40) {
            trimToSize(getCurrentSize() / 2);
        }
    }
}
