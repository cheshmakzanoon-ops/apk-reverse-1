package net.aihelp.core.p004ui.glide.load.engine.cache;

import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public interface MemoryCache {

    public interface ResourceRemovedListener {
        void onResourceRemoved(Resource<?> resource);
    }

    void clearMemory();

    int getCurrentSize();

    int getMaxSize();

    Resource<?> put(Key key, Resource<?> resource);

    Resource<?> remove(Key key);

    void setResourceRemovedListener(ResourceRemovedListener resourceRemovedListener);

    void setSizeMultiplier(float f);

    void trimMemory(int i);
}
