package net.aihelp.core.p004ui.glide.load.model;

import android.net.Uri;
import android.text.TextUtils;
import java.io.File;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;

public class StringLoader<T> implements ModelLoader<String, T> {
    private final ModelLoader<Uri, T> uriLoader;

    public StringLoader(ModelLoader<Uri, T> modelLoader) {
        this.uriLoader = modelLoader;
    }

    @Override
    public DataFetcher<T> getResourceFetcher(String str, int i, int i2) {
        Uri fileUri;
        if (TextUtils.isEmpty(str)) {
            return null;
        }
        if (str.startsWith("/")) {
            fileUri = toFileUri(str);
        } else {
            Uri uri = Uri.parse(str);
            fileUri = uri.getScheme() == null ? toFileUri(str) : uri;
        }
        return this.uriLoader.getResourceFetcher(fileUri, i, i2);
    }

    private static Uri toFileUri(String str) {
        return Uri.fromFile(new File(str));
    }
}
