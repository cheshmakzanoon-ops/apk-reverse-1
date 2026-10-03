package net.aihelp.core.p004ui.glide.load.model.file_descriptor;

import android.content.Context;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ResourceLoader;

public class FileDescriptorResourceLoader extends ResourceLoader<ParcelFileDescriptor> implements FileDescriptorModelLoader<Integer> {

    public static class Factory implements ModelLoaderFactory<Integer, ParcelFileDescriptor> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<Integer, ParcelFileDescriptor> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new FileDescriptorResourceLoader(context, genericLoaderFactory.buildModelLoader(Uri.class, ParcelFileDescriptor.class));
        }
    }

    public FileDescriptorResourceLoader(Context context) {
        this(context, Glide.buildFileDescriptorModelLoader(Uri.class, context));
    }

    public FileDescriptorResourceLoader(Context context, ModelLoader<Uri, ParcelFileDescriptor> modelLoader) {
        super(context, modelLoader);
    }
}
