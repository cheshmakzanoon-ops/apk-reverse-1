package net.aihelp.core.p004ui.glide;

import android.content.Context;
import android.os.ParcelFileDescriptor;
import java.io.File;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.model.ImageVideoModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ImageVideoWrapper;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;
import net.aihelp.core.p004ui.glide.load.resource.gifbitmap.GifBitmapWrapper;
import net.aihelp.core.p004ui.glide.load.resource.transcode.ResourceTranscoder;
import net.aihelp.core.p004ui.glide.manager.Lifecycle;
import net.aihelp.core.p004ui.glide.manager.RequestTracker;
import net.aihelp.core.p004ui.glide.provider.FixedLoadProvider;
import net.aihelp.core.p004ui.glide.request.FutureTarget;
import net.aihelp.core.p004ui.glide.request.target.Target;

public class DrawableTypeRequest<ModelType> extends DrawableRequestBuilder<ModelType> implements DownloadOptions {
    private final ModelLoader<ModelType, ParcelFileDescriptor> fileDescriptorModelLoader;
    private final RequestManager.OptionsApplier optionsApplier;
    private final ModelLoader<ModelType, InputStream> streamModelLoader;

    private static <A, Z, R> FixedLoadProvider<A, ImageVideoWrapper, Z, R> buildProvider(Glide glide, ModelLoader<A, InputStream> modelLoader, ModelLoader<A, ParcelFileDescriptor> modelLoader2, Class<Z> cls, Class<R> cls2, ResourceTranscoder<Z, R> resourceTranscoder) {
        if (modelLoader == null && modelLoader2 == null) {
            return null;
        }
        if (resourceTranscoder == null) {
            resourceTranscoder = glide.buildTranscoder(cls, cls2);
        }
        return new FixedLoadProvider<>(new ImageVideoModelLoader(modelLoader, modelLoader2), resourceTranscoder, glide.buildDataProvider(ImageVideoWrapper.class, cls));
    }

    DrawableTypeRequest(Class<ModelType> cls, ModelLoader<ModelType, InputStream> modelLoader, ModelLoader<ModelType, ParcelFileDescriptor> modelLoader2, Context context, Glide glide, RequestTracker requestTracker, Lifecycle lifecycle, RequestManager.OptionsApplier optionsApplier) {
        super(context, cls, buildProvider(glide, modelLoader, modelLoader2, GifBitmapWrapper.class, GlideDrawable.class, null), glide, requestTracker, lifecycle);
        this.streamModelLoader = modelLoader;
        this.fileDescriptorModelLoader = modelLoader2;
        this.optionsApplier = optionsApplier;
    }

    public BitmapTypeRequest<ModelType> asBitmap() {
        return (BitmapTypeRequest) this.optionsApplier.apply(new BitmapTypeRequest(this, this.streamModelLoader, this.fileDescriptorModelLoader, this.optionsApplier));
    }

    public GifTypeRequest<ModelType> asGif() {
        return (GifTypeRequest) this.optionsApplier.apply(new GifTypeRequest(this, this.streamModelLoader, this.optionsApplier));
    }

    @Override
    public <Y extends Target<File>> Y downloadOnly(Y y) {
        return (Y) getDownloadOnlyRequest().downloadOnly(y);
    }

    @Override
    public FutureTarget<File> downloadOnly(int i, int i2) {
        return getDownloadOnlyRequest().downloadOnly(i, i2);
    }

    private GenericTranscodeRequest<ModelType, InputStream, File> getDownloadOnlyRequest() {
        return (GenericTranscodeRequest) this.optionsApplier.apply(new GenericTranscodeRequest(File.class, this, this.streamModelLoader, InputStream.class, File.class, this.optionsApplier));
    }
}
