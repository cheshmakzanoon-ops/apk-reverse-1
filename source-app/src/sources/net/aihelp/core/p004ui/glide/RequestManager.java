package net.aihelp.core.p004ui.glide;

import android.content.Context;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.os.ParcelFileDescriptor;
import java.io.File;
import java.io.InputStream;
import java.net.URL;
import java.util.Iterator;
import java.util.UUID;
import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.load.engine.DiskCacheStrategy;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.model.file_descriptor.FileDescriptorModelLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.MediaStoreStreamLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.StreamByteArrayLoader;
import net.aihelp.core.p004ui.glide.load.model.stream.StreamModelLoader;
import net.aihelp.core.p004ui.glide.manager.ConnectivityMonitor;
import net.aihelp.core.p004ui.glide.manager.ConnectivityMonitorFactory;
import net.aihelp.core.p004ui.glide.manager.Lifecycle;
import net.aihelp.core.p004ui.glide.manager.LifecycleListener;
import net.aihelp.core.p004ui.glide.manager.RequestManagerTreeNode;
import net.aihelp.core.p004ui.glide.manager.RequestTracker;
import net.aihelp.core.p004ui.glide.signature.ApplicationVersionSignature;
import net.aihelp.core.p004ui.glide.signature.MediaStoreSignature;
import net.aihelp.core.p004ui.glide.signature.StringSignature;
import net.aihelp.core.p004ui.glide.util.Util;

public class RequestManager implements LifecycleListener {
    private final Context context;
    private final Glide glide;
    private final Lifecycle lifecycle;
    private DefaultOptions options;
    private final OptionsApplier optionsApplier;
    private final RequestTracker requestTracker;
    private final RequestManagerTreeNode treeNode;

    public interface DefaultOptions {
        <T> void apply(GenericRequestBuilder<T, ?, ?, ?> genericRequestBuilder);
    }

    public RequestManager(Context context, Lifecycle lifecycle, RequestManagerTreeNode requestManagerTreeNode) {
        this(context, lifecycle, requestManagerTreeNode, new RequestTracker(), new ConnectivityMonitorFactory());
    }

    RequestManager(Context context, final Lifecycle lifecycle, RequestManagerTreeNode requestManagerTreeNode, RequestTracker requestTracker, ConnectivityMonitorFactory connectivityMonitorFactory) {
        this.context = context.getApplicationContext();
        this.lifecycle = lifecycle;
        this.treeNode = requestManagerTreeNode;
        this.requestTracker = requestTracker;
        this.glide = Glide.get(context);
        this.optionsApplier = new OptionsApplier();
        ConnectivityMonitor connectivityMonitorBuild = connectivityMonitorFactory.build(context, new RequestManagerConnectivityListener(requestTracker));
        if (Util.isOnBackgroundThread()) {
            new Handler(Looper.getMainLooper()).post(new Runnable() {
                @Override
                public void run() {
                    lifecycle.addListener(RequestManager.this);
                }
            });
        } else {
            lifecycle.addListener(this);
        }
        lifecycle.addListener(connectivityMonitorBuild);
    }

    public void onTrimMemory(int i) {
        this.glide.trimMemory(i);
    }

    public void onLowMemory() {
        this.glide.clearMemory();
    }

    public void setDefaultOptions(DefaultOptions defaultOptions) {
        this.options = defaultOptions;
    }

    public boolean isPaused() {
        Util.assertMainThread();
        return this.requestTracker.isPaused();
    }

    public void pauseRequests() {
        Util.assertMainThread();
        this.requestTracker.pauseRequests();
    }

    public void pauseRequestsRecursive() {
        Util.assertMainThread();
        pauseRequests();
        Iterator<RequestManager> it = this.treeNode.getDescendants().iterator();
        while (it.hasNext()) {
            it.next().pauseRequests();
        }
    }

    public void resumeRequests() {
        Util.assertMainThread();
        this.requestTracker.resumeRequests();
    }

    public void resumeRequestsRecursive() {
        Util.assertMainThread();
        resumeRequests();
        Iterator<RequestManager> it = this.treeNode.getDescendants().iterator();
        while (it.hasNext()) {
            it.next().resumeRequests();
        }
    }

    @Override
    public void onStart() {
        resumeRequests();
    }

    @Override
    public void onStop() {
        pauseRequests();
    }

    @Override
    public void onDestroy() {
        this.requestTracker.clearRequests();
    }

    public <A, T> GenericModelRequest<A, T> using(ModelLoader<A, T> modelLoader, Class<T> cls) {
        return new GenericModelRequest<>(modelLoader, cls);
    }

    public <T> ImageModelRequest<T> using(StreamModelLoader<T> streamModelLoader) {
        return new ImageModelRequest<>(streamModelLoader);
    }

    public ImageModelRequest<byte[]> using(StreamByteArrayLoader streamByteArrayLoader) {
        return new ImageModelRequest<>(streamByteArrayLoader);
    }

    public <T> VideoModelRequest<T> using(FileDescriptorModelLoader<T> fileDescriptorModelLoader) {
        return new VideoModelRequest<>(fileDescriptorModelLoader);
    }

    public DrawableTypeRequest<String> load(String str) {
        return (DrawableTypeRequest) fromString().load(str);
    }

    public DrawableTypeRequest<String> fromString() {
        return loadGeneric(String.class);
    }

    public DrawableTypeRequest<Uri> load(Uri uri) {
        return (DrawableTypeRequest) fromUri().load(uri);
    }

    public DrawableTypeRequest<Uri> fromUri() {
        return loadGeneric(Uri.class);
    }

    @Deprecated
    public DrawableTypeRequest<Uri> loadFromMediaStore(Uri uri, String str, long j, int i) {
        return (DrawableTypeRequest) loadFromMediaStore(uri).signature((Key) new MediaStoreSignature(str, j, i));
    }

    public DrawableTypeRequest<Uri> loadFromMediaStore(Uri uri) {
        return (DrawableTypeRequest) fromMediaStore().load(uri);
    }

    public DrawableTypeRequest<Uri> fromMediaStore() {
        return (DrawableTypeRequest) this.optionsApplier.apply(new DrawableTypeRequest(Uri.class, new MediaStoreStreamLoader(this.context, Glide.buildStreamModelLoader(Uri.class, this.context)), Glide.buildFileDescriptorModelLoader(Uri.class, this.context), this.context, this.glide, this.requestTracker, this.lifecycle, this.optionsApplier));
    }

    public DrawableTypeRequest<File> load(File file) {
        return (DrawableTypeRequest) fromFile().load(file);
    }

    public DrawableTypeRequest<File> fromFile() {
        return loadGeneric(File.class);
    }

    public DrawableTypeRequest<Integer> load(Integer num) {
        return (DrawableTypeRequest) fromResource().load(num);
    }

    public DrawableTypeRequest<Integer> fromResource() {
        return (DrawableTypeRequest) loadGeneric(Integer.class).signature(ApplicationVersionSignature.obtain(this.context));
    }

    @Deprecated
    public DrawableTypeRequest<URL> load(URL url) {
        return (DrawableTypeRequest) fromUrl().load(url);
    }

    @Deprecated
    public DrawableTypeRequest<URL> fromUrl() {
        return loadGeneric(URL.class);
    }

    @Deprecated
    public DrawableTypeRequest<byte[]> load(byte[] bArr, String str) {
        return (DrawableTypeRequest) load(bArr).signature((Key) new StringSignature(str));
    }

    public DrawableTypeRequest<byte[]> load(byte[] bArr) {
        return (DrawableTypeRequest) fromBytes().load(bArr);
    }

    public DrawableTypeRequest<byte[]> fromBytes() {
        return (DrawableTypeRequest) loadGeneric(byte[].class).signature((Key) new StringSignature(UUID.randomUUID().toString())).diskCacheStrategy(DiskCacheStrategy.NONE).skipMemoryCache(true);
    }

    public <T> DrawableTypeRequest<T> load(T t) {
        return (DrawableTypeRequest) loadGeneric(getSafeClass(t)).load(t);
    }

    public <T> DrawableTypeRequest<T> from(Class<T> cls) {
        return loadGeneric(cls);
    }

    private <T> DrawableTypeRequest<T> loadGeneric(Class<T> cls) {
        ModelLoader modelLoaderBuildStreamModelLoader = Glide.buildStreamModelLoader((Class) cls, this.context);
        ModelLoader modelLoaderBuildFileDescriptorModelLoader = Glide.buildFileDescriptorModelLoader((Class) cls, this.context);
        if (cls != null && modelLoaderBuildStreamModelLoader == null && modelLoaderBuildFileDescriptorModelLoader == null) {
            throw new IllegalArgumentException("Unknown type " + cls + ". You must provide a Model of a type for which there is a registered ModelLoader, if you are using a custom model, you must first call Glide#register with a ModelLoaderFactory for your custom model class");
        }
        return (DrawableTypeRequest) this.optionsApplier.apply(new DrawableTypeRequest(cls, modelLoaderBuildStreamModelLoader, modelLoaderBuildFileDescriptorModelLoader, this.context, this.glide, this.requestTracker, this.lifecycle, this.optionsApplier));
    }

    public static <T> Class<T> getSafeClass(T t) {
        if (t != null) {
            return (Class<T>) t.getClass();
        }
        return null;
    }

    public final class VideoModelRequest<T> {
        private final ModelLoader<T, ParcelFileDescriptor> loader;

        VideoModelRequest(ModelLoader<T, ParcelFileDescriptor> modelLoader) {
            this.loader = modelLoader;
        }

        public DrawableTypeRequest<T> load(T t) {
            return (DrawableTypeRequest) ((DrawableTypeRequest) RequestManager.this.optionsApplier.apply(new DrawableTypeRequest(RequestManager.getSafeClass(t), null, this.loader, RequestManager.this.context, RequestManager.this.glide, RequestManager.this.requestTracker, RequestManager.this.lifecycle, RequestManager.this.optionsApplier))).load(t);
        }
    }

    public final class ImageModelRequest<T> {
        private final ModelLoader<T, InputStream> loader;

        ImageModelRequest(ModelLoader<T, InputStream> modelLoader) {
            this.loader = modelLoader;
        }

        public DrawableTypeRequest<T> from(Class<T> cls) {
            return (DrawableTypeRequest) RequestManager.this.optionsApplier.apply(new DrawableTypeRequest(cls, this.loader, null, RequestManager.this.context, RequestManager.this.glide, RequestManager.this.requestTracker, RequestManager.this.lifecycle, RequestManager.this.optionsApplier));
        }

        public DrawableTypeRequest<T> load(T t) {
            return (DrawableTypeRequest) from(RequestManager.getSafeClass(t)).load(t);
        }
    }

    public final class GenericModelRequest<A, T> {
        private final Class<T> dataClass;
        private final ModelLoader<A, T> modelLoader;

        GenericModelRequest(ModelLoader<A, T> modelLoader, Class<T> cls) {
            this.modelLoader = modelLoader;
            this.dataClass = cls;
        }

        public GenericModelRequest<A, T>.GenericTypeRequest from(Class<A> cls) {
            return new GenericTypeRequest((Class) cls);
        }

        public GenericModelRequest<A, T>.GenericTypeRequest load(A a) {
            return new GenericTypeRequest(a);
        }

        public final class GenericTypeRequest {
            private final A model;
            private final Class<A> modelClass;
            private final boolean providedModel;

            GenericTypeRequest(A a) {
                this.providedModel = true;
                this.model = a;
                this.modelClass = RequestManager.getSafeClass(a);
            }

            GenericTypeRequest(Class<A> cls) {
                this.providedModel = false;
                this.model = null;
                this.modelClass = cls;
            }

            public <Z> GenericTranscodeRequest<A, T, Z> m134as(Class<Z> cls) {
                GenericTranscodeRequest<A, T, Z> genericTranscodeRequest = (GenericTranscodeRequest) RequestManager.this.optionsApplier.apply(new GenericTranscodeRequest(RequestManager.this.context, RequestManager.this.glide, this.modelClass, GenericModelRequest.this.modelLoader, GenericModelRequest.this.dataClass, cls, RequestManager.this.requestTracker, RequestManager.this.lifecycle, RequestManager.this.optionsApplier));
                if (this.providedModel) {
                    genericTranscodeRequest.load(this.model);
                }
                return genericTranscodeRequest;
            }
        }
    }

    class OptionsApplier {
        OptionsApplier() {
        }

        public <A, X extends GenericRequestBuilder<A, ?, ?, ?>> X apply(X x) {
            if (RequestManager.this.options != null) {
                RequestManager.this.options.apply(x);
            }
            return x;
        }
    }

    private static class RequestManagerConnectivityListener implements ConnectivityMonitor.ConnectivityListener {
        private final RequestTracker requestTracker;

        public RequestManagerConnectivityListener(RequestTracker requestTracker) {
            this.requestTracker = requestTracker;
        }

        @Override
        public void onConnectivityChanged(boolean z) {
            if (z) {
                this.requestTracker.restartRequests();
            }
        }
    }
}
