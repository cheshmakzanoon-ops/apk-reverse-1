package com.google.common.collect;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingTable<R, C, V> extends ForwardingObject implements Table<R, C, V> {
    @Override
    public abstract Table<R, C, V> delegate();

    protected ForwardingTable() {
    }

    @Override
    public Set<Table.Cell<R, C, V>> cellSet() {
        return delegate().cellSet();
    }

    @Override
    public void clear() {
        delegate().clear();
    }

    @Override
    public Map<R, V> column(@ParametricNullness C c) {
        return delegate().column(c);
    }

    @Override
    public Set<C> columnKeySet() {
        return delegate().columnKeySet();
    }

    @Override
    public Map<C, Map<R, V>> columnMap() {
        return delegate().columnMap();
    }

    @Override
    public boolean contains(@CheckForNull Object obj, @CheckForNull Object obj2) {
        return delegate().contains(obj, obj2);
    }

    @Override
    public boolean containsColumn(@CheckForNull Object obj) {
        return delegate().containsColumn(obj);
    }

    @Override
    public boolean containsRow(@CheckForNull Object obj) {
        return delegate().containsRow(obj);
    }

    @Override
    public boolean containsValue(@CheckForNull Object obj) {
        return delegate().containsValue(obj);
    }

    @Override
    @CheckForNull
    public V get(@CheckForNull Object obj, @CheckForNull Object obj2) {
        return delegate().get(obj, obj2);
    }

    @Override
    public boolean isEmpty() {
        return delegate().isEmpty();
    }

    @Override
    @CheckForNull
    public V put(@ParametricNullness R r, @ParametricNullness C c, @ParametricNullness V v) {
        return delegate().put(r, c, v);
    }

    @Override
    public void putAll(Table<? extends R, ? extends C, ? extends V> table) {
        delegate().putAll(table);
    }

    @Override
    @CheckForNull
    public V remove(@CheckForNull Object obj, @CheckForNull Object obj2) {
        return delegate().remove(obj, obj2);
    }

    @Override
    public Map<C, V> row(@ParametricNullness R r) {
        return delegate().row(r);
    }

    @Override
    public Set<R> rowKeySet() {
        return delegate().rowKeySet();
    }

    @Override
    public Map<R, Map<C, V>> rowMap() {
        return delegate().rowMap();
    }

    @Override
    public int size() {
        return delegate().size();
    }

    @Override
    public Collection<V> values() {
        return delegate().values();
    }

    @Override
    public boolean equals(@CheckForNull Object obj) {
        return obj == this || delegate().equals(obj);
    }

    @Override
    public int hashCode() {
        return delegate().hashCode();
    }
}
