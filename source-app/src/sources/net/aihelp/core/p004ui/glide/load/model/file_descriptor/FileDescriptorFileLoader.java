package net.aihelp.core.p004ui.glide.load.model.file_descriptor;

import android.content.Context;
import android.net.Uri;
import android.os.ParcelFileDescriptor;
import java.io.File;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.model.FileLoader;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;

public class FileDescriptorFileLoader extends FileLoader<ParcelFileDescriptor> implements FileDescriptorModelLoader<File> {

    public static class Factory implements ModelLoaderFactory<File, ParcelFileDescriptor> {
        @Override
        public void teardown() {
        }

        @Override
        public ModelLoader<File, ParcelFileDescriptor> build(Context context, GenericLoaderFactory genericLoaderFactory) {
            return new FileDescriptorFileLoader((ModelLoader<Uri, ParcelFileDescriptor>) genericLoaderFactory.buildModelLoader(Uri.class, ParcelFileDescriptor.class));
        }
    }

    public FileDescriptorFileLoader(Context context) {
        this((ModelLoader<Uri, ParcelFileDescriptor>) Glide.buildFileDescriptorModelLoader(Uri.class, context));
    }

    public FileDescriptorFileLoader(ModelLoader<Uri, ParcelFileDescriptor> modelLoader) {
        super(modelLoader);
    }
}
