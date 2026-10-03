package net.aihelp.core.p004ui.glide;

import android.graphics.Bitmap;
import android.os.ParcelFileDescriptor;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.model.ImageVideoModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ImageVideoWrapper;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.resource.transcode.BitmapBytesTranscoder;
import net.aihelp.core.p004ui.glide.load.resource.transcode.ResourceTranscoder;
import net.aihelp.core.p004ui.glide.provider.FixedLoadProvider;

public class BitmapTypeRequest<ModelType> extends BitmapRequestBuilder<ModelType, Bitmap> {
    private final ModelLoader<ModelType, ParcelFileDescriptor> fileDescriptorModelLoader;
    private final Glide glide;
    private final RequestManager.OptionsApplier optionsApplier;
    private final ModelLoader<ModelType, InputStream> streamModelLoader;

    private static <A, R> FixedLoadProvider<A, ImageVideoWrapper, Bitmap, R> buildProvider(Glide glide, ModelLoader<A, InputStream> modelLoader, ModelLoader<A, ParcelFileDescriptor> modelLoader2, Class<R> cls, ResourceTranscoder<Bitmap, R> resourceTranscoder) {
        if (modelLoader == null && modelLoader2 == null) {
            return null;
        }
        if (resourceTranscoder == null) {
            resourceTranscoder = glide.buildTranscoder(Bitmap.class, cls);
        }
        return new FixedLoadProvider<>(new ImageVideoModelLoader(modelLoader, modelLoader2), resourceTranscoder, glide.buildDataProvider(ImageVideoWrapper.class, Bitmap.class));
    }

    BitmapTypeRequest(GenericRequestBuilder<ModelType, ?, ?, ?> genericRequestBuilder, ModelLoader<ModelType, InputStream> modelLoader, ModelLoader<ModelType, ParcelFileDescriptor> modelLoader2, RequestManager.OptionsApplier optionsApplier) {
        super(buildProvider(genericRequestBuilder.glide, modelLoader, modelLoader2, Bitmap.class, null), Bitmap.class, genericRequestBuilder);
        this.streamModelLoader = modelLoader;
        this.fileDescriptorModelLoader = modelLoader2;
        this.glide = genericRequestBuilder.glide;
        this.optionsApplier = optionsApplier;
    }

    public <R> BitmapRequestBuilder<ModelType, R> transcode(ResourceTranscoder<Bitmap, R> resourceTranscoder, Class<R> cls) {
        return (BitmapRequestBuilder) this.optionsApplier.apply(new BitmapRequestBuilder(buildProvider(this.glide, this.streamModelLoader, this.fileDescriptorModelLoader, cls, resourceTranscoder), cls, this));
    }

    public BitmapRequestBuilder<ModelType, byte[]> toBytes() {
        return (BitmapRequestBuilder<ModelType, byte[]>) transcode(new BitmapBytesTranscoder(), byte[].class);
    }

    public BitmapRequestBuilder<ModelType, byte[]> toBytes(Bitmap.CompressFormat compressFormat, int i) {
        return (BitmapRequestBuilder<ModelType, byte[]>) transcode(new BitmapBytesTranscoder(compressFormat, i), byte[].class);
    }
}
