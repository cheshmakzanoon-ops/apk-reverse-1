package zendesk.p026ui.android.internal;

import android.content.Context;
import android.os.Build;
import coil.ComponentRegistry;
import coil.ImageLoader;
import coil.decode.GifDecoder;
import coil.decode.ImageDecoderDecoder;
import coil.decode.SvgDecoder;
import coil.disk.DiskCache;
import coil.memory.MemoryCache;
import coil.util.Logger;
import java.io.File;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.p002io.FilesKt;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Response;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\u00020\u0001:\u0001\u0010B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000e\u0010\u000b\u001a\u00020\n2\u0006\u0010\f\u001a\u00020\rJ\u000e\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\t\u001a\u00020\nR\u000e\u0010\u0003\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\u0006X\u0082T¢\u0006\u0002\n\u0000R\u0010\u0010\t\u001a\u0004\u0018\u00010\nX\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lzendesk/ui/android/internal/ImageLoaderFactory;", "", "()V", "CACHE_MAX_SIZE_20MB", "", "CACHE_NAME", "", "HEADER_ACCEPT", "HEADER_ACCEPT_VALUES", "imageLoader", "Lcoil/ImageLoader;", "getImageLoader", "context", "Landroid/content/Context;", "setImageLoader", "", "CustomImagesHeaderInterceptor", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ImageLoaderFactory {
    private static final long CACHE_MAX_SIZE_20MB = 20000000;
    private static final String CACHE_NAME = "zendesk_conversationkit_image_cache";
    private static final String HEADER_ACCEPT = "Accept";
    private static final String HEADER_ACCEPT_VALUES = "*/*";
    private static ImageLoader imageLoader;
    public static final ImageLoaderFactory INSTANCE = new ImageLoaderFactory();
    public static final int $stable = 8;

    private ImageLoaderFactory() {
    }

    public final void setImageLoader(ImageLoader imageLoader2) {
        Intrinsics.checkNotNullParameter(imageLoader2, "imageLoader");
        imageLoader = imageLoader2;
    }

    public final ImageLoader getImageLoader(final Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        ImageLoader imageLoader2 = imageLoader;
        if (imageLoader2 != null) {
            return imageLoader2;
        }
        ImageLoader.Builder builderMemoryCache = new ImageLoader.Builder(context).okHttpClient(new Function0<OkHttpClient>() {
            @Override
            public final OkHttpClient invoke() {
                return new OkHttpClient.Builder().addInterceptor(new CustomImagesHeaderInterceptor()).build();
            }
        }).diskCache(new Function0<DiskCache>() {
            {
                super(0);
            }

            @Override
            public final DiskCache invoke() {
                DiskCache.Builder builderMaxSizeBytes = new DiskCache.Builder().maxSizeBytes(ImageLoaderFactory.CACHE_MAX_SIZE_20MB);
                File cacheDir = context.getCacheDir();
                Intrinsics.checkNotNullExpressionValue(cacheDir, "getCacheDir(...)");
                return builderMaxSizeBytes.directory(FilesKt.resolve(cacheDir, ImageLoaderFactory.CACHE_NAME)).build();
            }
        }).memoryCache(new Function0<MemoryCache>() {
            {
                super(0);
            }

            @Override
            public final MemoryCache invoke() {
                return new MemoryCache.Builder(context).build();
            }
        });
        ComponentRegistry.Builder builder = new ComponentRegistry.Builder();
        if (Build.VERSION.SDK_INT >= 28) {
            builder.add(new ImageDecoderDecoder.Factory(false, 1, (DefaultConstructorMarker) null));
        }
        builder.add(new GifDecoder.Factory(false, 1, (DefaultConstructorMarker) null));
        builder.add(new SvgDecoder.Factory(false, 1, (DefaultConstructorMarker) null));
        ImageLoader imageLoaderBuild = builderMemoryCache.components(builder.build()).logger(new Logger() {
            private int level = 3;

            public int getLevel() {
                return this.level;
            }

            public void setLevel(int i) {
                this.level = i;
            }

            public void log(String tag, int priority, String message, Throwable throwable) {
                Intrinsics.checkNotNullParameter(tag, "tag");
                zendesk.logger.Logger.m221i(tag, message, new Object[0]);
            }
        }).build();
        imageLoader = imageLoaderBuild;
        return imageLoaderBuild;
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0002\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0016¨\u0006\u0007"}, m18d2 = {"Lzendesk/ui/android/internal/ImageLoaderFactory$CustomImagesHeaderInterceptor;", "Lokhttp3/Interceptor;", "()V", "intercept", "Lokhttp3/Response;", "chain", "Lokhttp3/Interceptor$Chain;", "zendesk.ui_ui-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class CustomImagesHeaderInterceptor implements Interceptor {
        @Override
        public Response intercept(Interceptor.Chain chain) {
            Intrinsics.checkNotNullParameter(chain, "chain");
            return chain.proceed(chain.request().newBuilder().addHeader("Accept", ImageLoaderFactory.HEADER_ACCEPT_VALUES).build());
        }
    }
}
