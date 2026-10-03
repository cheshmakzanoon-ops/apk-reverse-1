package net.aihelp.core.p004ui.glide.load.model;

import android.content.Context;
import android.net.Uri;
import cz.msebera.android.httpclient.HttpHost;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;

public abstract class UriLoader<T> implements ModelLoader<Uri, T> {
    private final Context context;
    private final ModelLoader<GlideUrl, T> urlLoader;

    protected abstract DataFetcher<T> getAssetPathFetcher(Context context, String str);

    protected abstract DataFetcher<T> getLocalUriFetcher(Context context, Uri uri);

    public UriLoader(Context context, ModelLoader<GlideUrl, T> modelLoader) {
        this.context = context;
        this.urlLoader = modelLoader;
    }

    @Override
    public final DataFetcher<T> getResourceFetcher(Uri uri, int i, int i2) {
        String scheme = uri.getScheme();
        if (isLocalUri(scheme)) {
            if (AssetUriParser.isAssetUri(uri)) {
                return getAssetPathFetcher(this.context, AssetUriParser.toAssetPath(uri));
            }
            return getLocalUriFetcher(this.context, uri);
        }
        if (this.urlLoader == null || !(HttpHost.DEFAULT_SCHEME_NAME.equals(scheme) || "https".equals(scheme))) {
            return null;
        }
        return this.urlLoader.getResourceFetcher(new GlideUrl(uri.toString()), i, i2);
    }

    private static boolean isLocalUri(String str) {
        return "file".equals(str) || "content".equals(str) || "android.resource".equals(str);
    }
}
