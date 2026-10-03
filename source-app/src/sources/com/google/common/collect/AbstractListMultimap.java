package com.google.common.collect;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
abstract class AbstractListMultimap<K, V> extends AbstractMapBasedMultimap<K, V> implements ListMultimap<K, V> {
    private static final long serialVersionUID = 6588350623831699109L;

    @Override
    public abstract List<V> createCollection();

    protected AbstractListMultimap(Map<K, Collection<V>> map) {
        super(map);
    }

    @Override
    public List<V> createUnmodifiableEmptyCollection() {
        return Collections.emptyList();
    }

    @Override
    <E> Collection<E> unmodifiableCollectionSubclass(Collection<E> collection) {
        return Collections.unmodifiableList((List) collection);
    }

    @Override
    Collection<V> wrapCollection(@ParametricNullness K k, Collection<V> collection) {
        return wrapList(k, (List) collection, null);
    }

    @Override
    public List<V> get(@ParametricNullness K k) {
        return (List) super.get((Object) k);
    }

    @Override
    public List<V> removeAll(@CheckForNull Object obj) {
        return (List) super.removeAll(obj);
    }

    @Override
    public List<V> replaceValues(@ParametricNullness K k, Iterable<? extends V> iterable) {
        return (List) super.replaceValues((Object) k, (Iterable) iterable);
    }

    @Override
    public boolean put(@ParametricNullness K k, @ParametricNullness V v) {
        return super.put(k, v);
    }

    @Override
    public Map<K, Collection<V>> asMap() {
        return super.asMap();
    }

    @Override
    public boolean equals(@CheckForNull Object obj) {
        return super.equals(obj);
    }
}
