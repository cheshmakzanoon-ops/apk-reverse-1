package net.aihelp.core.p004ui.glide.load.model.stream;

import android.content.Context;
import android.net.Uri;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;
import net.aihelp.core.p004ui.glide.load.data.StreamAssetPathFetcher;
import net.aihelp.core.p004ui.glide.load.data.StreamLocalUriFetcher;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.GlideUrl;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.UriLoader;

public class StreamUriLoader extends UriLoader<InputStream> implements StreamModelLoader<Uri> {

    public static class Factory implements ModelLoaderFactory<Uri, InputStream> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<Uri, InputStream> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new StreamUriLoader(context, genericLoaderFactory.buildModelLoader(GlideUrl.class, InputStream.class));
        }
    }

    public StreamUriLoader(Context context) {
        this(context, Glide.buildStreamModelLoader(GlideUrl.class, context));
    }

    public StreamUriLoader(Context context, ModelLoader<GlideUrl, InputStream> modelLoader) {
        super(context, modelLoader);
    }

    @Override
    protected DataFetcher<InputStream> getLocalUriFetcher(Context context, Uri uri) {
        return new StreamLocalUriFetcher(context, uri);
    }

    @Override
    protected DataFetcher<InputStream> getAssetPathFetcher(Context context, String str) {
        return new StreamAssetPathFetcher(context.getApplicationContext().getAssets(), str);
    }
}
