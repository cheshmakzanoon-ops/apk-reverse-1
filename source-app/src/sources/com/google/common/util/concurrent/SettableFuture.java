package com.google.common.util.concurrent;

@ElementTypesAreNonnullByDefault
public final class SettableFuture<V> extends AbstractFuture.TrustedFuture<V> {
    public static <V> SettableFuture<V> create() {
        return new SettableFuture<>();
    }

    @Override
    public boolean set(@ParametricNullness V v) {
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

    private SettableFuture() {
    }
}
