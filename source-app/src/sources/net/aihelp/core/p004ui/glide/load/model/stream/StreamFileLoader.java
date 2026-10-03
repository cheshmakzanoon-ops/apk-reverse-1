package net.aihelp.core.p004ui.glide.load.model.stream;

import android.content.Context;
import android.net.Uri;
import java.io.File;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.model.FileLoader;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;

public class StreamFileLoader extends FileLoader<InputStream> implements StreamModelLoader<File> {

    public static class Factory implements ModelLoaderFactory<File, InputStream> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<File, InputStream> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new StreamFileLoader((ModelLoader<Uri, InputStream>) genericLoaderFactory.buildModelLoader(Uri.class, InputStream.class));
        }
    }

    public StreamFileLoader(Context context) {
        this((ModelLoader<Uri, InputStream>) Glide.buildStreamModelLoader(Uri.class, context));
    }

    public StreamFileLoader(ModelLoader<Uri, InputStream> modelLoader) {
        super(modelLoader);
    }
}
