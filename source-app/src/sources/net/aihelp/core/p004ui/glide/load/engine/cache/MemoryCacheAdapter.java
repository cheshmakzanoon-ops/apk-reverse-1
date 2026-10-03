package net.aihelp.core.p004ui.glide.load.engine.cache;

import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class MemoryCacheAdapter implements MemoryCache {
    private MemoryCache.ResourceRemovedListener listener;

    @Override
    public void clearMemory() {
    }

    @Override
    public int getCurrentSize() {
        return 0;
    }

    @Override
    public int getMaxSize() {
        return 0;
    }

    @Override
    public Resource<?> remove(Key key) {
        return null;
    }

    @Override
    public void setSizeMultiplier(float f) {
    }

    @Override
    public void trimMemory(int i) {
    }

    @Override
    public Resource<?> put(Key key, Resource<?> resource) {
        this.listener.onResourceRemoved(resource);
        return null;
    }

    @Override
    public void setResourceRemovedListener(MemoryCache.ResourceRemovedListener resourceRemovedListener) {
        this.listener = resourceRemovedListener;
    }
}
