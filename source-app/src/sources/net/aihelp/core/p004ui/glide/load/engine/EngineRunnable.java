package net.aihelp.core.p004ui.glide.load.engine;

import android.util.Log;
import net.aihelp.core.p004ui.glide.Priority;
import net.aihelp.core.p004ui.glide.load.engine.executor.Prioritized;
import net.aihelp.core.p004ui.glide.request.ResourceCallback;

class EngineRunnable implements Runnable, Prioritized {
    private static final String TAG = "EngineRunnable";
    private final DecodeJob<?, ?, ?> decodeJob;
    private volatile boolean isCancelled;
    private final EngineRunnableManager manager;
    private final Priority priority;
    private Stage stage = Stage.CACHE;

    interface EngineRunnableManager extends ResourceCallback {
        void submitForSource(EngineRunnable engineRunnable);
    }

    private enum Stage {
        CACHE,
        SOURCE
    }

    public EngineRunnable(EngineRunnableManager engineRunnableManager, DecodeJob<?, ?, ?> decodeJob, Priority priority) {
        this.manager = engineRunnableManager;
        this.decodeJob = decodeJob;
        this.priority = priority;
    }

    public void cancel() {
        this.isCancelled = true;
        this.decodeJob.cancel();
    }

    @Override
    public void run() throws Exception {
        Exception errorWrappingGlideException;
        if (this.isCancelled) {
            return;
        }
        Resource<?> resourceDecode = null;
        try {
            resourceDecode = decode();
            errorWrappingGlideException = null;
        } catch (Exception e) {
            if (Log.isLoggable(TAG, 2)) {
                Log.v(TAG, "Exception decoding", e);
            }
            errorWrappingGlideException = e;
        } catch (OutOfMemoryError e2) {
            if (Log.isLoggable(TAG, 2)) {
                Log.v(TAG, "Out Of Memory Error decoding", e2);
            }
            errorWrappingGlideException = new ErrorWrappingGlideException(e2);
        }
        if (this.isCancelled) {
            if (resourceDecode != null) {
                resourceDecode.recycle();
            }
        } else if (resourceDecode == null) {
            onLoadFailed(errorWrappingGlideException);
        } else {
            onLoadComplete(resourceDecode);
        }
    }

    private boolean isDecodingFromCache() {
        return this.stage == Stage.CACHE;
    }

    private void onLoadComplete(Resource resource) {
        this.manager.onResourceReady(resource);
    }

    private void onLoadFailed(Exception exc) {
        if (isDecodingFromCache()) {
            this.stage = Stage.SOURCE;
            this.manager.submitForSource(this);
        } else {
            this.manager.onException(exc);
        }
    }

    private Resource<?> decode() throws Exception {
        if (isDecodingFromCache()) {
            return decodeFromCache();
        }
        return decodeFromSource();
    }

    private Resource<?> decodeFromCache() throws Exception {
        Resource<?> resourceDecodeResultFromCache;
        try {
            resourceDecodeResultFromCache = this.decodeJob.decodeResultFromCache();
        } catch (Exception e) {
            if (Log.isLoggable(TAG, 3)) {
                Log.d(TAG, "Exception decoding result from cache: " + e);
            }
            resourceDecodeResultFromCache = null;
        }
        return resourceDecodeResultFromCache == null ? this.decodeJob.decodeSourceFromCache() : resourceDecodeResultFromCache;
    }

    private Resource<?> decodeFromSource() throws Exception {
        return this.decodeJob.decodeFromSource();
    }

    @Override
    public int getPriority() {
        return this.priority.ordinal();
    }
}
