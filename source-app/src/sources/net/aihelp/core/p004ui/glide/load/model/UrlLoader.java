package net.aihelp.core.p004ui.glide.load.model;

import java.net.URL;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;

public class UrlLoader<T> implements ModelLoader<URL, T> {
    private final ModelLoader<GlideUrl, T> glideUrlLoader;

    public UrlLoader(ModelLoader<GlideUrl, T> modelLoader) {
        this.glideUrlLoader = modelLoader;
    }

    @Override
    public DataFetcher<T> getResourceFetcher(URL url, int i, int i2) {
        return this.glideUrlLoader.getResourceFetcher(new GlideUrl(url), i, i2);
    }
}
