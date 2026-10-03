package net.aihelp.core.p004ui.glide.load.model;

import net.aihelp.core.p004ui.glide.load.data.DataFetcher;

public interface ModelLoader<T, Y> {
    DataFetcher<Y> getResourceFetcher(T t, int i, int i2);
}
