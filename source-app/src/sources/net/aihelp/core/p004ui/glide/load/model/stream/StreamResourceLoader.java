package net.aihelp.core.p004ui.glide.load.model.stream;

import android.content.Context;
import android.net.Uri;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ResourceLoader;

public class StreamResourceLoader extends ResourceLoader<InputStream> implements StreamModelLoader<Integer> {

    public static class Factory implements ModelLoaderFactory<Integer, InputStream> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<Integer, InputStream> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new StreamResourceLoader(context, genericLoaderFactory.buildModelLoader(Uri.class, InputStream.class));
        }
    }

    public StreamResourceLoader(Context context) {
        this(context, Glide.buildStreamModelLoader(Uri.class, context));
    }

    public StreamResourceLoader(Context context, ModelLoader<Uri, InputStream> modelLoader) {
        super(context, modelLoader);
    }
}
