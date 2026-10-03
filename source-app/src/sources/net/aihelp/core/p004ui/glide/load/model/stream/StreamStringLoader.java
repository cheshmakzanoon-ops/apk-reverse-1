package net.aihelp.core.p004ui.glide.load.model.stream;

import android.content.Context;
import android.net.Uri;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.StringLoader;

public class StreamStringLoader extends StringLoader<InputStream> implements StreamModelLoader<String> {

    public static class Factory implements ModelLoaderFactory<String, InputStream> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<String, InputStream> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new StreamStringLoader((ModelLoader<Uri, InputStream>) genericLoaderFactory.buildModelLoader(Uri.class, InputStream.class));
        }
    }

    public StreamStringLoader(Context context) {
        this((ModelLoader<Uri, InputStream>) Glide.buildStreamModelLoader(Uri.class, context));
    }

    public StreamStringLoader(ModelLoader<Uri, InputStream> modelLoader) {
        super(modelLoader);
    }
}
