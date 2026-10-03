package com.google.common.collect;

import java.util.concurrent.ConcurrentMap;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingConcurrentMap<K, V> extends ForwardingMap<K, V> implements ConcurrentMap<K, V>, j$.util.concurrent.ConcurrentMap {
    @Override
    public Object compute(Object obj, BiFunction biFunction) {
        return j$.util.concurrent.ConcurrentMap.-CC.$default$compute(this, obj, biFunction);
    }

    @Override
    public Object computeIfAbsent(Object obj, Function function) {
        return j$.util.concurrent.ConcurrentMap.-CC.$default$computeIfAbsent(this, obj, function);
    }

    @Override
    public Object computeIfPresent(Object obj, BiFunction biFunction) {
        return j$.util.concurrent.ConcurrentMap.-CC.$default$computeIfPresent(this, obj, biFunction);
    }

    @Override
    public abstract ConcurrentMap<K, V> delegate();

    @Override
    public void forEach(BiConsumer biConsumer) {
        j$.util.concurrent.ConcurrentMap.-CC.$default$forEach(this, biConsumer);
    }

    @Override
    public Object getOrDefault(Object obj, Object obj2) {
        return j$.util.concurrent.ConcurrentMap.-CC.$default$getOrDefault(this, obj, obj2);
    }

    @Override
    public Object merge(Object obj, Object obj2, BiFunction biFunction) {
        return j$.util.concurrent.ConcurrentMap.-CC.$default$merge(this, obj, obj2, biFunction);
    }

    @Override
    public void replaceAll(BiFunction biFunction) {
        j$.util.concurrent.ConcurrentMap.-CC.$default$replaceAll(this, biFunction);
    }

    protected ForwardingConcurrentMap() {
    }

    @Override
    @CheckForNull
    public V putIfAbsent(K k, V v) {
        return delegate().putIfAbsent(k, v);
    }

    @Override
    public boolean remove(@CheckForNull Object obj, @CheckForNull Object obj2) {
        return delegate().remove(obj, obj2);
    }

    @Override
    @CheckForNull
    public V replace(K k, V v) {
        return delegate().replace(k, v);
    }

    @Override
    public boolean replace(K k, V v, V v2) {
        return delegate().replace(k, v, v2);
    }
}
