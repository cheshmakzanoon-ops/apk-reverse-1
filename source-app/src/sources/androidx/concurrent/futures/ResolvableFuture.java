package androidx.concurrent.futures;

import com.google.common.util.concurrent.ListenableFuture;

public final class ResolvableFuture<V> extends AbstractResolvableFuture<V> {
    public static <V> ResolvableFuture<V> create() {
        return new ResolvableFuture<>();
    }

    @Override
    public boolean set(V v) {
        return super.set(v);
    }

    @Override
    public boolean setException(Throwable th) {
        return super.setException(th);
    }

    @Override
    public boolean setFuture(ListenableFuture<? extends V> listenableFuture) {
        return super.setFuture(listenableFuture);
    }

    private ResolvableFuture() {
    }
}
