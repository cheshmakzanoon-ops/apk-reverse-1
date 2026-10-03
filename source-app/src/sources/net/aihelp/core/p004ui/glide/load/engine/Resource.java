package net.aihelp.core.p004ui.glide.load.engine;

public interface Resource<Z> {
    Z get();

    int getSize();

    void recycle();
}
