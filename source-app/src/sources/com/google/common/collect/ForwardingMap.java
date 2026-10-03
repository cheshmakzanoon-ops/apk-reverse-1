package com.google.common.collect;

import com.google.common.base.Objects;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingMap<K, V> extends ForwardingObject implements Map<K, V> {
    @Override
    public abstract Map<K, V> delegate();

    protected ForwardingMap() {
    }

    @Override
    public int size() {
        return delegate().size();
    }

    @Override
    public boolean isEmpty() {
        return delegate().isEmpty();
    }

    @CheckForNull
    public V remove(@CheckForNull Object obj) {
        return delegate().remove(obj);
    }

    public void clear() {
        delegate().clear();
    }

    @Override
    public boolean containsKey(@CheckForNull Object obj) {
        return delegate().containsKey(obj);
    }

    public boolean containsValue(@CheckForNull Object obj) {
        return delegate().containsValue(obj);
    }

    @Override
    @CheckForNull
    public V get(@CheckForNull Object obj) {
        return delegate().get(obj);
    }

    @CheckForNull
    public V put(@ParametricNullness K k, @ParametricNullness V v) {
        return delegate().put(k, v);
    }

    public void putAll(Map<? extends K, ? extends V> map) {
        delegate().putAll(map);
    }

    public Set<K> keySet() {
        return delegate().keySet();
    }

    public Collection<V> values() {
        return delegate().values();
    }

    public Set<Map.Entry<K, V>> entrySet() {
        return delegate().entrySet();
    }

    @Override
    public boolean equals(@CheckForNull Object obj) {
        return obj == this || delegate().equals(obj);
    }

    @Override
    public int hashCode() {
        return delegate().hashCode();
    }

    protected void standardPutAll(Map<? extends K, ? extends V> map) {
        Maps.putAllImpl(this, map);
    }

    @CheckForNull
    protected V standardRemove(@CheckForNull Object obj) {
        Iterator<Map.Entry<K, V>> it = entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<K, V> next = it.next();
            if (Objects.equal(next.getKey(), obj)) {
                V value = next.getValue();
                it.remove();
                return value;
            }
        }
        return null;
    }

    protected void standardClear() {
        Iterators.clear(entrySet().iterator());
    }

    protected class StandardKeySet extends Maps.KeySet<K, V> {
        public StandardKeySet(ForwardingMap forwardingMap) {
            super(forwardingMap);
        }
    }

    protected boolean standardContainsKey(@CheckForNull Object obj) {
        return Maps.containsKeyImpl(this, obj);
    }

    protected class StandardValues extends Maps.Values<K, V> {
        public StandardValues(ForwardingMap forwardingMap) {
            super(forwardingMap);
        }
    }

    protected boolean standardContainsValue(@CheckForNull Object obj) {
        return Maps.containsValueImpl(this, obj);
    }

    protected abstract class StandardEntrySet extends Maps.EntrySet<K, V> {
        public StandardEntrySet() {
        }

        @Override
        Map<K, V> map() {
            return ForwardingMap.this;
        }
    }

    protected boolean standardIsEmpty() {
        return !entrySet().iterator().hasNext();
    }

    protected boolean standardEquals(@CheckForNull Object obj) {
        return Maps.equalsImpl(this, obj);
    }

    protected int standardHashCode() {
        return Sets.hashCodeImpl(entrySet());
    }

    protected String standardToString() {
        return Maps.toStringImpl(this);
    }
}
