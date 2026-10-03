package com.google.common.cache;

import com.google.common.base.Preconditions;
import com.google.common.collect.ForwardingObject;
import com.google.common.collect.ImmutableMap;
import java.util.Map;
import java.util.concurrent.Callable;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ExecutionException;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingCache<K, V> extends ForwardingObject implements Cache<K, V> {
    @Override
    public abstract Cache<K, V> delegate();

    protected ForwardingCache() {
    }

    @Override
    @CheckForNull
    public V getIfPresent(Object obj) {
        return delegate().getIfPresent(obj);
    }

    @Override
    public V get(K k, Callable<? extends V> callable) throws ExecutionException {
        return delegate().get(k, callable);
    }

    @Override
    public ImmutableMap<K, V> getAllPresent(Iterable<? extends Object> iterable) {
        return delegate().getAllPresent(iterable);
    }

    @Override
    public void put(K k, V v) {
        delegate().put(k, v);
    }

    @Override
    public void putAll(Map<? extends K, ? extends V> map) {
        delegate().putAll(map);
    }

    @Override
    public void invalidate(Object obj) {
        delegate().invalidate(obj);
    }

    @Override
    public void invalidateAll(Iterable<? extends Object> iterable) {
        delegate().invalidateAll(iterable);
    }

    @Override
    public void invalidateAll() {
        delegate().invalidateAll();
    }

    @Override
    public long size() {
        return delegate().size();
    }

    @Override
    public CacheStats stats() {
        return delegate().stats();
    }

    @Override
    public ConcurrentMap<K, V> asMap() {
        return delegate().asMap();
    }

    @Override
    public void cleanUp() {
        delegate().cleanUp();
    }

    public static abstract class SimpleForwardingCache<K, V> extends ForwardingCache<K, V> {
        private final Cache<K, V> delegate;

        protected SimpleForwardingCache(Cache<K, V> cache) {
            this.delegate = (Cache) Preconditions.checkNotNull(cache);
        }

        @Override
        public final Cache<K, V> delegate() {
            return this.delegate;
        }
    }
}
