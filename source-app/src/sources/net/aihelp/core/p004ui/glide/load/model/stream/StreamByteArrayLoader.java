package net.aihelp.core.p004ui.glide.load.model.stream;

import android.content.Context;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.data.ByteArrayFetcher;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;

public class StreamByteArrayLoader implements StreamModelLoader<byte[]> {

    private final String f90id;

    public StreamByteArrayLoader() {
        this("");
    }

    @Deprecated
    public StreamByteArrayLoader(String str) {
        this.f90id = str;
    }

    @Override
    public DataFetcher<InputStream> getResourceFetcher(byte[] bArr, int i, int i2) {
        return new ByteArrayFetcher(bArr, this.f90id);
    }

    public static class Factory implements ModelLoaderFactory<byte[], InputStream> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<byte[], InputStream> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new StreamByteArrayLoader();
        }
    }
}
