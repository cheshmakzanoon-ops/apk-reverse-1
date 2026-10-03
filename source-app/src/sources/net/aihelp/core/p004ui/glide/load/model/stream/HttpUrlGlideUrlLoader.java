package net.aihelp.core.p004ui.glide.load.model.stream;

import android.content.Context;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;
import net.aihelp.core.p004ui.glide.load.data.HttpUrlFetcher;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.GlideUrl;
import net.aihelp.core.p004ui.glide.load.model.ModelCache;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;

public class HttpUrlGlideUrlLoader implements StreamModelLoader<GlideUrl> {
    private final ModelCache<GlideUrl, GlideUrl> modelCache;

    public static class Factory implements ModelLoaderFactory<GlideUrl, InputStream> {
        private final ModelCache<GlideUrl, GlideUrl> modelCache = new ModelCache<>(500);

        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<GlideUrl, InputStream> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new HttpUrlGlideUrlLoader(this.modelCache);
        }
    }

    public HttpUrlGlideUrlLoader() {
        this(null);
    }

    public HttpUrlGlideUrlLoader(ModelCache<GlideUrl, GlideUrl> modelCache) {
        this.modelCache = modelCache;
    }

    @Override
    public DataFetcher<InputStream> getResourceFetcher(GlideUrl glideUrl, int i, int i2) {
        ModelCache<GlideUrl, GlideUrl> modelCache = this.modelCache;
        if (modelCache != null) {
            GlideUrl glideUrl2 = modelCache.get(glideUrl, 0, 0);
            if (glideUrl2 == null) {
                this.modelCache.put(glideUrl, 0, 0, glideUrl);
            } else {
                glideUrl = glideUrl2;
            }
        }
        return new HttpUrlFetcher(glideUrl);
    }
}
