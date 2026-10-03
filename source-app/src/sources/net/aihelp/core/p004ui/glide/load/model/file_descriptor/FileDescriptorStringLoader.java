package net.aihelp.core.p004ui.glide.load.model.file_descriptor;

import android.content.Context;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.StringLoader;

public class FileDescriptorStringLoader extends StringLoader<ParcelFileDescriptor> implements FileDescriptorModelLoader<String> {

    public static class Factory implements ModelLoaderFactory<String, ParcelFileDescriptor> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<String, ParcelFileDescriptor> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new FileDescriptorStringLoader((ModelLoader<Uri, ParcelFileDescriptor>) genericLoaderFactory.buildModelLoader(Uri.class, ParcelFileDescriptor.class));
        }
    }

    public FileDescriptorStringLoader(Context context) {
        this((ModelLoader<Uri, ParcelFileDescriptor>) Glide.buildFileDescriptorModelLoader(Uri.class, context));
    }

    public FileDescriptorStringLoader(ModelLoader<Uri, ParcelFileDescriptor> modelLoader) {
        super(modelLoader);
    }
}
