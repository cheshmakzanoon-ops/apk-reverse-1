package net.aihelp.core.p004ui.glide.load.model.stream;

import android.content.Context;
import java.io.InputStream;
import java.net.URL;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.GlideUrl;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.UrlLoader;

public class StreamUrlLoader extends UrlLoader<InputStream> {

    public static class Factory implements ModelLoaderFactory<URL, InputStream> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<URL, InputStream> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new StreamUrlLoader(genericLoaderFactory.buildModelLoader(GlideUrl.class, InputStream.class));
        }
    }

    public StreamUrlLoader(ModelLoader<GlideUrl, InputStream> modelLoader) {
        super(modelLoader);
    }
}
