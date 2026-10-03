package net.aihelp.core.p004ui.glide.load.model.stream;

import android.content.Context;
import android.net.Uri;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;
import net.aihelp.core.p004ui.glide.load.data.MediaStoreThumbFetcher;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;

public class MediaStoreStreamLoader implements StreamModelLoader<Uri> {
    private final Context context;
    private final ModelLoader<Uri, InputStream> uriLoader;

    public MediaStoreStreamLoader(Context context, ModelLoader<Uri, InputStream> modelLoader) {
        this.context = context;
        this.uriLoader = modelLoader;
    }

    @Override
    public DataFetcher<InputStream> getResourceFetcher(Uri uri, int i, int i2) {
        return new MediaStoreThumbFetcher(this.context, uri, this.uriLoader.getResourceFetcher(uri, i, i2), i, i2);
    }
}
