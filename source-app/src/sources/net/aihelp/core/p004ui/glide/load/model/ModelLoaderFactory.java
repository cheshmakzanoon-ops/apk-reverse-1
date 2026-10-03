package net.aihelp.core.p004ui.glide.load.model;

import android.content.Context;

public interface ModelLoaderFactory<T, Y> {
    ModelLoader<T, Y> build(Context context, GenericLoaderFactory genericLoaderFactory);

    void teardown();
}
