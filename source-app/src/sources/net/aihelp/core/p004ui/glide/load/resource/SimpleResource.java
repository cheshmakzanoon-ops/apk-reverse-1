package net.aihelp.core.p004ui.glide.load.resource;

import net.aihelp.core.p004ui.glide.load.engine.Resource;

public class SimpleResource<T> implements Resource<T> {
    protected final T data;

    @Override
    public final int getSize() {
        return 1;
    }

    @Override
    public void recycle() {
    }

    public SimpleResource(T t) {
        if (t == null) {
            throw new NullPointerException("Data must not be null");
        }
        this.data = t;
    }

    @Override
    public final T get() {
        return this.data;
    }
}
