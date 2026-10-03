package net.aihelp.core.p004ui.glide.load.model.file_descriptor;

import android.content.Context;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.data.DataFetcher;
import net.aihelp.core.p004ui.glide.load.data.FileDescriptorAssetPathFetcher;
import net.aihelp.core.p004ui.glide.load.data.FileDescriptorLocalUriFetcher;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.GlideUrl;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.UriLoader;

public class FileDescriptorUriLoader extends UriLoader<ParcelFileDescriptor> implements FileDescriptorModelLoader<Uri> {

    public static class Factory implements ModelLoaderFactory<Uri, ParcelFileDescriptor> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<Uri, ParcelFileDescriptor> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new FileDescriptorUriLoader(context, genericLoaderFactory.buildModelLoader(GlideUrl.class, ParcelFileDescriptor.class));
        }
    }

    public FileDescriptorUriLoader(Context context) {
        this(context, Glide.buildFileDescriptorModelLoader(GlideUrl.class, context));
    }

    public FileDescriptorUriLoader(Context context, ModelLoader<GlideUrl, ParcelFileDescriptor> modelLoader) {
        super(context, modelLoader);
    }

    @Override
    protected DataFetcher<ParcelFileDescriptor> getLocalUriFetcher(Context context, Uri uri) {
        return new FileDescriptorLocalUriFetcher(context, uri);
    }

    @Override
    protected DataFetcher<ParcelFileDescriptor> getAssetPathFetcher(Context context, String str) {
        return new FileDescriptorAssetPathFetcher(context.getApplicationContext().getAssets(), str);
    }
}
