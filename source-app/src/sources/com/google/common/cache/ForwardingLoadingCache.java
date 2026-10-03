package com.google.common.cache;

import com.google.common.base.Preconditions;
import com.google.common.collect.ImmutableMap;
import java.util.concurrent.ExecutionException;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingLoadingCache<K, V> extends ForwardingCache<K, V> implements LoadingCache<K, V> {
    @Override
    public abstract LoadingCache<K, V> delegate();

    protected ForwardingLoadingCache() {
    }

    @Override
    public V get(K k) throws ExecutionException {
        return delegate().get(k);
    }

    @Override
    public V getUnchecked(K k) {
        return delegate().getUnchecked(k);
    }

    @Override
    public ImmutableMap<K, V> getAll(Iterable<? extends K> iterable) throws ExecutionException {
        return delegate().getAll(iterable);
    }

    @Override
    public V apply(K k) {
        return delegate().apply(k);
    }

    @Override
    public void refresh(K k) {
        delegate().refresh(k);
    }

    public static abstract class SimpleForwardingLoadingCache<K, V> extends ForwardingLoadingCache<K, V> {
        private final LoadingCache<K, V> delegate;

        protected SimpleForwardingLoadingCache(LoadingCache<K, V> loadingCache) {
            this.delegate = (LoadingCache) Preconditions.checkNotNull(loadingCache);
        }

        @Override
        public final LoadingCache<K, V> delegate() {
            return this.delegate;
        }
    }
}
