package net.aihelp.core.p004ui.glide.load.model;

import android.net.Uri;
import java.io.File;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;

public class FileLoader<T> implements ModelLoader<File, T> {
    private final ModelLoader<Uri, T> uriLoader;

    public FileLoader(ModelLoader<Uri, T> modelLoader) {
        this.uriLoader = modelLoader;
    }

    @Override
    public DataFetcher<T> getResourceFetcher(File file, int i, int i2) {
        return this.uriLoader.getResourceFetcher(Uri.fromFile(file), i, i2);
    }
}
