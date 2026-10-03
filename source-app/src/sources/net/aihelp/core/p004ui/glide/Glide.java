package net.aihelp.core.p004ui.glide;

import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import androidx.fragment.app.FragmentActivity;
import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.util.Collections;
import java.util.List;
import net.aihelp.core.p004ui.glide.load.DecodeFormat;
import net.aihelp.core.p004ui.glide.load.engine.Engine;
import net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle.BitmapPool;
import net.aihelp.core.p004ui.glide.load.engine.cache.DiskCache;
import net.aihelp.core.p004ui.glide.load.engine.cache.MemoryCache;
import net.aihelp.core.p004ui.glide.load.engine.prefill.BitmapPreFiller;
import net.aihelp.core.p004ui.glide.load.engine.prefill.PreFillType;
import net.aihelp.core.p004ui.glide.load.model.GenericLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.GlideUrl;
import net.aihelp.core.p004ui.glide.load.model.ImageVideoWrapper;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.ModelLoaderFactory;
import net.aihelp.core.p004ui.glide.load.model.file_descriptor.FileDescriptorFileLoader;
import net.aihelp.core.p004ui.glide.load.model.file_descriptor.FileDescriptorResourceLoader;
import net.aihelp.core.p004ui.glide.load.model.file_descriptor.FileDescriptorStringLoader;
import net.aihelp.core.p004ui.glide.load.model.file_descriptor.FileDescriptorUriLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.HttpUrlGlideUrlLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.StreamByteArrayLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.StreamFileLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.StreamResourceLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.StreamStringLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.StreamUriLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.StreamUrlLoader;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.CenterCrop;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.FileDescriptorBitmapDataLoadProvider;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.FitCenter;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.GlideBitmapDrawable;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.ImageVideoDataLoadProvider;
import net.aihelp.core.p004ui.glide.load.resource.bitmap.StreamBitmapDataLoadProvider;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;
import net.aihelp.core.p004ui.glide.load.resource.file.StreamFileDataLoadProvider;
import net.aihelp.core.p004ui.glide.load.resource.gif.GifDrawable;
import net.aihelp.core.p004ui.glide.load.resource.gif.GifDrawableLoadProvider;
import net.aihelp.core.p004ui.glide.load.resource.gifbitmap.GifBitmapWrapper;
import net.aihelp.core.p004ui.glide.load.resource.gifbitmap.GifBitmapWrapperTransformation;
import net.aihelp.core.p004ui.glide.load.resource.gifbitmap.ImageVideoGifDrawableLoadProvider;
import net.aihelp.core.p004ui.glide.load.resource.transcode.GifBitmapWrapperDrawableTranscoder;
import net.aihelp.core.p004ui.glide.load.resource.transcode.GlideBitmapDrawableTranscoder;
import net.aihelp.core.p004ui.glide.load.resource.transcode.ResourceTranscoder;
import net.aihelp.core.p004ui.glide.load.resource.transcode.TranscoderRegistry;
import net.aihelp.core.p004ui.glide.manager.RequestManagerRetriever;
import net.aihelp.core.p004ui.glide.module.GlideModule;
import net.aihelp.core.p004ui.glide.module.ManifestParser;
import net.aihelp.core.p004ui.glide.provider.DataLoadProvider;
import net.aihelp.core.p004ui.glide.provider.DataLoadProviderRegistry;
import net.aihelp.core.p004ui.glide.request.FutureTarget;
import net.aihelp.core.p004ui.glide.request.Request;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;
import net.aihelp.core.p004ui.glide.request.target.ImageViewTargetFactory;
import net.aihelp.core.p004ui.glide.request.target.Target;
import net.aihelp.core.p004ui.glide.request.target.ViewTarget;
import net.aihelp.core.p004ui.glide.util.Util;

public class Glide {
    private static final String TAG = "Glide";
    private static volatile Glide glide = null;
    private static boolean modulesEnabled = true;
    private final CenterCrop bitmapCenterCrop;
    private final FitCenter bitmapFitCenter;
    private final BitmapPool bitmapPool;
    private final BitmapPreFiller bitmapPreFiller;
    private final DataLoadProviderRegistry dataLoadProviderRegistry;
    private final DecodeFormat decodeFormat;
    private final GifBitmapWrapperTransformation drawableCenterCrop;
    private final GifBitmapWrapperTransformation drawableFitCenter;
    private final Engine engine;
    private final ImageViewTargetFactory imageViewTargetFactory = new ImageViewTargetFactory();
    private final GenericLoaderFactory loaderFactory;
    private final Handler mainHandler;
    private final MemoryCache memoryCache;
    private final TranscoderRegistry transcoderRegistry;

    public static File getPhotoCacheDir(Context context) {
        return getPhotoCacheDir(context, DiskCache.Factory.DEFAULT_DISK_CACHE_DIR);
    }

    public static File getPhotoCacheDir(Context context, String str) {
        File cacheDir = context.getCacheDir();
        if (cacheDir != null) {
            File file = new File(cacheDir, str);
            if (file.mkdirs() || (file.exists() && file.isDirectory())) {
                return file;
            }
            return null;
        }
        if (Log.isLoggable(TAG, 6)) {
            Log.e(TAG, "default disk cache dir is null");
        }
        return null;
    }

    public static void setModulesEnabled(boolean z) {
        synchronized (Glide.class) {
            if (glide != null) {
                throw new IllegalArgumentException("Glide singleton already exists.");
            }
            modulesEnabled = z;
        }
    }

    public static Glide get(Context context) {
        if (glide == null) {
            synchronized (Glide.class) {
                if (glide == null) {
                    glide = new GlideBuilder(context.getApplicationContext()).createGlide();
                }
            }
        }
        return glide;
    }

    private static List<GlideModule> parseGlideModules(Context context) {
        if (modulesEnabled) {
            return new ManifestParser(context).parse();
        }
        return Collections.emptyList();
    }

    @Deprecated
    public static boolean isSetup() {
        return glide != null;
    }

    @Deprecated
    public static void setup(GlideBuilder glideBuilder) {
        if (isSetup()) {
            throw new IllegalArgumentException("Glide is already setup, check with isSetup() first");
        }
        glide = glideBuilder.createGlide();
    }

    static void tearDown() {
        glide = null;
        modulesEnabled = true;
    }

    Glide(Engine engine, MemoryCache memoryCache, BitmapPool bitmapPool, Context context, DecodeFormat decodeFormat) {
        TranscoderRegistry transcoderRegistry = new TranscoderRegistry();
        this.transcoderRegistry = transcoderRegistry;
        this.engine = engine;
        this.bitmapPool = bitmapPool;
        this.memoryCache = memoryCache;
        this.decodeFormat = decodeFormat;
        this.loaderFactory = new GenericLoaderFactory(context);
        this.mainHandler = new Handler(Looper.getMainLooper());
        this.bitmapPreFiller = new BitmapPreFiller(memoryCache, bitmapPool, decodeFormat);
        DataLoadProviderRegistry dataLoadProviderRegistry = new DataLoadProviderRegistry();
        this.dataLoadProviderRegistry = dataLoadProviderRegistry;
        StreamBitmapDataLoadProvider streamBitmapDataLoadProvider = new StreamBitmapDataLoadProvider(bitmapPool, decodeFormat);
        dataLoadProviderRegistry.register(InputStream.class, Bitmap.class, streamBitmapDataLoadProvider);
        FileDescriptorBitmapDataLoadProvider fileDescriptorBitmapDataLoadProvider = new FileDescriptorBitmapDataLoadProvider(bitmapPool, decodeFormat);
        dataLoadProviderRegistry.register(ParcelFileDescriptor.class, Bitmap.class, fileDescriptorBitmapDataLoadProvider);
        ImageVideoDataLoadProvider imageVideoDataLoadProvider = new ImageVideoDataLoadProvider(streamBitmapDataLoadProvider, fileDescriptorBitmapDataLoadProvider);
        dataLoadProviderRegistry.register(ImageVideoWrapper.class, Bitmap.class, imageVideoDataLoadProvider);
        GifDrawableLoadProvider gifDrawableLoadProvider = new GifDrawableLoadProvider(context, bitmapPool);
        dataLoadProviderRegistry.register(InputStream.class, GifDrawable.class, gifDrawableLoadProvider);
        dataLoadProviderRegistry.register(ImageVideoWrapper.class, GifBitmapWrapper.class, new ImageVideoGifDrawableLoadProvider(imageVideoDataLoadProvider, gifDrawableLoadProvider, bitmapPool));
        dataLoadProviderRegistry.register(InputStream.class, File.class, new StreamFileDataLoadProvider());
        register(File.class, ParcelFileDescriptor.class, new FileDescriptorFileLoader.Factory());
        register(File.class, InputStream.class, new StreamFileLoader.Factory());
        register(Integer.TYPE, ParcelFileDescriptor.class, new FileDescriptorResourceLoader.Factory());
        register(Integer.TYPE, InputStream.class, new StreamResourceLoader.Factory());
        register(Integer.class, ParcelFileDescriptor.class, new FileDescriptorResourceLoader.Factory());
        register(Integer.class, InputStream.class, new StreamResourceLoader.Factory());
        register(String.class, ParcelFileDescriptor.class, new FileDescriptorStringLoader.Factory());
        register(String.class, InputStream.class, new StreamStringLoader.Factory());
        register(Uri.class, ParcelFileDescriptor.class, new FileDescriptorUriLoader.Factory());
        register(Uri.class, InputStream.class, new StreamUriLoader.Factory());
        register(URL.class, InputStream.class, new StreamUrlLoader.Factory());
        register(GlideUrl.class, InputStream.class, new HttpUrlGlideUrlLoader.Factory());
        register(byte[].class, InputStream.class, new StreamByteArrayLoader.Factory());
        transcoderRegistry.register(Bitmap.class, GlideBitmapDrawable.class, new GlideBitmapDrawableTranscoder(context.getResources(), bitmapPool));
        transcoderRegistry.register(GifBitmapWrapper.class, GlideDrawable.class, new GifBitmapWrapperDrawableTranscoder(new GlideBitmapDrawableTranscoder(context.getResources(), bitmapPool)));
        CenterCrop centerCrop = new CenterCrop(bitmapPool);
        this.bitmapCenterCrop = centerCrop;
        this.drawableCenterCrop = new GifBitmapWrapperTransformation(bitmapPool, centerCrop);
        FitCenter fitCenter = new FitCenter(bitmapPool);
        this.bitmapFitCenter = fitCenter;
        this.drawableFitCenter = new GifBitmapWrapperTransformation(bitmapPool, fitCenter);
    }

    public BitmapPool getBitmapPool() {
        return this.bitmapPool;
    }

    <Z, R> ResourceTranscoder<Z, R> buildTranscoder(Class<Z> cls, Class<R> cls2) {
        return this.transcoderRegistry.get(cls, cls2);
    }

    <T, Z> DataLoadProvider<T, Z> buildDataProvider(Class<T> cls, Class<Z> cls2) {
        return this.dataLoadProviderRegistry.get(cls, cls2);
    }

    <R> Target<R> buildImageViewTarget(ImageView imageView, Class<R> cls) {
        return this.imageViewTargetFactory.buildTarget(imageView, cls);
    }

    Engine getEngine() {
        return this.engine;
    }

    CenterCrop getBitmapCenterCrop() {
        return this.bitmapCenterCrop;
    }

    FitCenter getBitmapFitCenter() {
        return this.bitmapFitCenter;
    }

    GifBitmapWrapperTransformation getDrawableCenterCrop() {
        return this.drawableCenterCrop;
    }

    GifBitmapWrapperTransformation getDrawableFitCenter() {
        return this.drawableFitCenter;
    }

    Handler getMainHandler() {
        return this.mainHandler;
    }

    DecodeFormat getDecodeFormat() {
        return this.decodeFormat;
    }

    private GenericLoaderFactory getLoaderFactory() {
        return this.loaderFactory;
    }

    public void preFillBitmapPool(PreFillType.Builder... builderArr) {
        this.bitmapPreFiller.preFill(builderArr);
    }

    public void clearMemory() {
        Util.assertMainThread();
        this.memoryCache.clearMemory();
        this.bitmapPool.clearMemory();
    }

    public void trimMemory(int i) {
        Util.assertMainThread();
        this.memoryCache.trimMemory(i);
        this.bitmapPool.trimMemory(i);
    }

    public void clearDiskCache() {
        Util.assertBackgroundThread();
        getEngine().clearDiskCache();
    }

    public void setMemoryCategory(MemoryCategory memoryCategory) {
        Util.assertMainThread();
        this.memoryCache.setSizeMultiplier(memoryCategory.getMultiplier());
        this.bitmapPool.setSizeMultiplier(memoryCategory.getMultiplier());
    }

    public static void clear(Target<?> target) {
        Util.assertMainThread();
        Request request = target.getRequest();
        if (request != null) {
            request.clear();
            target.setRequest(null);
        }
    }

    public static void clear(FutureTarget<?> futureTarget) {
        futureTarget.clear();
    }

    public static void clear(View view) {
        clear(new ClearTarget(view));
    }

    public <T, Y> void register(Class<T> cls, Class<Y> cls2, ModelLoaderFactory<T, Y> modelLoaderFactory) {
        ModelLoaderFactory<T, Y> modelLoaderFactoryRegister = this.loaderFactory.register(cls, cls2, modelLoaderFactory);
        if (modelLoaderFactoryRegister != null) {
            modelLoaderFactoryRegister.teardown();
        }
    }

    @Deprecated
    public <T, Y> void unregister(Class<T> cls, Class<Y> cls2) {
        ModelLoaderFactory<T, Y> modelLoaderFactoryUnregister = this.loaderFactory.unregister(cls, cls2);
        if (modelLoaderFactoryUnregister != null) {
            modelLoaderFactoryUnregister.teardown();
        }
    }

    public static <T, Y> ModelLoader<T, Y> buildModelLoader(Class<T> cls, Class<Y> cls2, Context context) {
        if (cls == null) {
            if (!Log.isLoggable(TAG, 3)) {
                return null;
            }
            Log.d(TAG, "Unable to load null model, setting placeholder only");
            return null;
        }
        return get(context).getLoaderFactory().buildModelLoader(cls, cls2);
    }

    public static <T, Y> ModelLoader<T, Y> buildModelLoader(T t, Class<Y> cls, Context context) {
        return buildModelLoader((Class) (t != null ? t.getClass() : null), (Class) cls, context);
    }

    public static <T> ModelLoader<T, InputStream> buildStreamModelLoader(Class<T> cls, Context context) {
        return buildModelLoader((Class) cls, InputStream.class, context);
    }

    public static <T> ModelLoader<T, InputStream> buildStreamModelLoader(T t, Context context) {
        return buildModelLoader(t, InputStream.class, context);
    }

    public static <T> ModelLoader<T, ParcelFileDescriptor> buildFileDescriptorModelLoader(Class<T> cls, Context context) {
        return buildModelLoader((Class) cls, ParcelFileDescriptor.class, context);
    }

    public static <T> ModelLoader<T, ParcelFileDescriptor> buildFileDescriptorModelLoader(T t, Context context) {
        return buildModelLoader(t, ParcelFileDescriptor.class, context);
    }

    public static RequestManager with(Context context) {
        return RequestManagerRetriever.get().get(context);
    }

    public static RequestManager with(Activity activity) {
        return RequestManagerRetriever.get().get(activity);
    }

    public static RequestManager with(FragmentActivity fragmentActivity) {
        return RequestManagerRetriever.get().get(fragmentActivity);
    }

    public static RequestManager with(Fragment fragment) {
        return RequestManagerRetriever.get().get(fragment);
    }

    public static RequestManager with(androidx.fragment.app.Fragment fragment) {
        return RequestManagerRetriever.get().get(fragment);
    }

    private static class ClearTarget extends ViewTarget<View, Object> {
        @Override
        public void onLoadCleared(Drawable drawable) {
        }

        @Override
        public void onLoadFailed(Exception exc, Drawable drawable) {
        }

        @Override
        public void onLoadStarted(Drawable drawable) {
        }

        @Override
        public void onResourceReady(Object obj, GlideAnimation<? super Object> glideAnimation) {
        }

        public ClearTarget(View view) {
            super(view);
        }
    }
}
