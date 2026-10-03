package net.aihelp.core.p004ui.glide.load.data;

import android.content.res.AssetManager;
import android.util.Log;
import java.io.IOException;
import net.aihelp.core.p004ui.glide.Priority;

public abstract class AssetPathFetcher<T> implements DataFetcher<T> {
    private static final String TAG = "AssetUriFetcher";
    private final AssetManager assetManager;
    private final String assetPath;
    private T data;

    @Override
    public void cancel() {
    }

    protected abstract void close(T t) throws IOException;

    protected abstract T loadResource(AssetManager assetManager, String str) throws IOException;

    public AssetPathFetcher(AssetManager assetManager, String str) {
        this.assetManager = assetManager;
        this.assetPath = str;
    }

    @Override
    public T loadData(Priority priority) throws Exception {
        T tLoadResource = loadResource(this.assetManager, this.assetPath);
        this.data = tLoadResource;
        return tLoadResource;
    }

    @Override
    public void cleanup() {
        T t = this.data;
        if (t == null) {
            return;
        }
        try {
            close(t);
        } catch (IOException e) {
            if (Log.isLoggable(TAG, 2)) {
                Log.v(TAG, "Failed to close data", e);
            }
        }
    }

    @Override
    public String getId() {
        return this.assetPath;
    }
}
