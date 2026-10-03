package com.google.common.collect;

import com.google.common.base.Function;
import com.google.common.base.Objects;
import com.google.common.base.Preconditions;
import com.google.common.base.Supplier;
import java.io.Serializable;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public final class Tables {
    private static final Function<? extends Map<?, ?>, ? extends Map<?, ?>> UNMODIFIABLE_WRAPPER = new Function<Map<Object, Object>, Map<Object, Object>>() {
        @Override
        public Map<Object, Object> apply(Map<Object, Object> map) {
            return Collections.unmodifiableMap(map);
        }
    };

    private Tables() {
    }

    public static <R, C, V> Table.Cell<R, C, V> immutableCell(@ParametricNullness R r, @ParametricNullness C c, @ParametricNullness V v) {
        return new ImmutableCell(r, c, v);
    }

    static final class ImmutableCell<R, C, V> extends AbstractCell<R, C, V> implements Serializable {
        private static final long serialVersionUID = 0;

        @ParametricNullness
        private final C columnKey;

        @ParametricNullness
        private final R rowKey;

        @ParametricNullness
        private final V value;

        ImmutableCell(@ParametricNullness R r, @ParametricNullness C c, @ParametricNullness V v) {
            this.rowKey = r;
            this.columnKey = c;
            this.value = v;
        }

        @Override
        @ParametricNullness
        public R getRowKey() {
            return this.rowKey;
        }

        @Override
        @ParametricNullness
        public C getColumnKey() {
            return this.columnKey;
        }

        @Override
        @ParametricNullness
        public V getValue() {
            return this.value;
        }
    }

    static abstract class AbstractCell<R, C, V> implements Table.Cell<R, C, V> {
        AbstractCell() {
        }

        @Override
        public boolean equals(@CheckForNull Object obj) {
            if (obj == this) {
                return true;
            }
            if (!(obj instanceof Table.Cell)) {
                return false;
            }
            Table.Cell cell = (Table.Cell) obj;
            return Objects.equal(getRowKey(), cell.getRowKey()) && Objects.equal(getColumnKey(), cell.getColumnKey()) && Objects.equal(getValue(), cell.getValue());
        }

        @Override
        public int hashCode() {
            return Objects.hashCode(getRowKey(), getColumnKey(), getValue());
        }

        public String toString() {
            String strValueOf = String.valueOf(getRowKey());
            String strValueOf2 = String.valueOf(getColumnKey());
            String strValueOf3 = String.valueOf(getValue());
            StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 4 + String.valueOf(strValueOf2).length() + String.valueOf(strValueOf3).length());
            sb.append("(");
            sb.append(strValueOf);
            sb.append(",");
            sb.append(strValueOf2);
            sb.append(")=");
            sb.append(strValueOf3);
            return sb.toString();
        }
    }

    public static <R, C, V> Table<C, R, V> transpose(Table<R, C, V> table) {
        if (table instanceof TransposeTable) {
            return ((TransposeTable) table).original;
        }
        return new TransposeTable(table);
    }

    private static class TransposeTable<C, R, V> extends AbstractTable<C, R, V> {
        private static final Function<Table.Cell<?, ?, ?>, Table.Cell<?, ?, ?>> TRANSPOSE_CELL = new Function<Table.Cell<?, ?, ?>, Table.Cell<?, ?, ?>>() {
            @Override
            public Table.Cell<?, ?, ?> apply(Table.Cell<?, ?, ?> cell) {
                return Tables.immutableCell(cell.getColumnKey(), cell.getRowKey(), cell.getValue());
            }
        };
        final Table<R, C, V> original;

        TransposeTable(Table<R, C, V> table) {
            this.original = (Table) Preconditions.checkNotNull(table);
        }

        @Override
        public void clear() {
            this.original.clear();
        }

        @Override
        public Map<C, V> column(@ParametricNullness R r) {
            return this.original.row(r);
        }

        @Override
        public Set<R> columnKeySet() {
            return this.original.rowKeySet();
        }

        @Override
        public Map<R, Map<C, V>> columnMap() {
            return this.original.rowMap();
        }

        @Override
        public boolean contains(@CheckForNull Object obj, @CheckForNull Object obj2) {
            return this.original.contains(obj2, obj);
        }

        @Override
        public boolean containsColumn(@CheckForNull Object obj) {
            return this.original.containsRow(obj);
        }

        @Override
        public boolean containsRow(@CheckForNull Object obj) {
            return this.original.containsColumn(obj);
        }

        @Override
        public boolean containsValue(@CheckForNull Object obj) {
            return this.original.containsValue(obj);
        }

        @Override
        @CheckForNull
        public V get(@CheckForNull Object obj, @CheckForNull Object obj2) {
            return this.original.get(obj2, obj);
        }

        @Override
        @CheckForNull
        public V put(@ParametricNullness C c, @ParametricNullness R r, @ParametricNullness V v) {
            return this.original.put(r, c, v);
        }

        @Override
        public void putAll(Table<? extends C, ? extends R, ? extends V> table) {
            this.original.putAll(Tables.transpose(table));
        }

        @Override
        @CheckForNull
        public V remove(@CheckForNull Object obj, @CheckForNull Object obj2) {
            return this.original.remove(obj2, obj);
        }

        @Override
        public Map<R, V> row(@ParametricNullness C c) {
            return this.original.column(c);
        }

        @Override
        public Set<C> rowKeySet() {
            return this.original.columnKeySet();
        }

        @Override
        public Map<C, Map<R, V>> rowMap() {
            return this.original.columnMap();
        }

        @Override
        public int size() {
            return this.original.size();
        }

        @Override
        public Collection<V> values() {
            return this.original.values();
        }

        @Override
        Iterator<Table.Cell<C, R, V>> cellIterator() {
            return Iterators.transform(this.original.cellSet().iterator(), TRANSPOSE_CELL);
        }
    }

    public static <R, C, V> Table<R, C, V> newCustomTable(Map<R, Map<C, V>> map, Supplier<? extends Map<C, V>> supplier) {
        Preconditions.checkArgument(map.isEmpty());
        Preconditions.checkNotNull(supplier);
        return new StandardTable(map, supplier);
    }

    public static <R, C, V1, V2> Table<R, C, V2> transformValues(Table<R, C, V1> table, Function<? super V1, V2> function) {
        return new TransformedTable(table, function);
    }

    private static class TransformedTable<R, C, V1, V2> extends AbstractTable<R, C, V2> {
        final Table<R, C, V1> fromTable;
        final Function<? super V1, V2> function;

        TransformedTable(Table<R, C, V1> table, Function<? super V1, V2> function) {
            this.fromTable = (Table) Preconditions.checkNotNull(table);
            this.function = (Function) Preconditions.checkNotNull(function);
        }

        @Override
        public boolean contains(@CheckForNull Object obj, @CheckForNull Object obj2) {
            return this.fromTable.contains(obj, obj2);
        }

        @Override
        @CheckForNull
        public V2 get(@CheckForNull Object obj, @CheckForNull Object obj2) {
            if (contains(obj, obj2)) {
                return this.function.apply((Object) NullnessCasts.uncheckedCastNullableTToT(this.fromTable.get(obj, obj2)));
            }
            return null;
        }

        @Override
        public int size() {
            return this.fromTable.size();
        }

        @Override
        public void clear() {
            this.fromTable.clear();
        }

        @Override
        @CheckForNull
        public V2 put(@ParametricNullness R r, @ParametricNullness C c, @ParametricNullness V2 v2) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void putAll(Table<? extends R, ? extends C, ? extends V2> table) {
            throw new UnsupportedOperationException();
        }

        @Override
        @CheckForNull
        public V2 remove(@CheckForNull Object obj, @CheckForNull Object obj2) {
            if (contains(obj, obj2)) {
                return this.function.apply((Object) NullnessCasts.uncheckedCastNullableTToT(this.fromTable.remove(obj, obj2)));
            }
            return null;
        }

        @Override
        public Map<C, V2> row(@ParametricNullness R r) {
            return Maps.transformValues(this.fromTable.row(r), this.function);
        }

        @Override
        public Map<R, V2> column(@ParametricNullness C c) {
            return Maps.transformValues(this.fromTable.column(c), this.function);
        }

        Function<Table.Cell<R, C, V1>, Table.Cell<R, C, V2>> cellFunction() {
            return new Function<Table.Cell<R, C, V1>, Table.Cell<R, C, V2>>() {
                @Override
                public Table.Cell<R, C, V2> apply(Table.Cell<R, C, V1> cell) {
                    return Tables.immutableCell(cell.getRowKey(), cell.getColumnKey(), TransformedTable.this.function.apply(cell.getValue()));
                }
            };
        }

        @Override
        Iterator<Table.Cell<R, C, V2>> cellIterator() {
            return Iterators.transform(this.fromTable.cellSet().iterator(), cellFunction());
        }

        @Override
        public Set<R> rowKeySet() {
            return this.fromTable.rowKeySet();
        }

        @Override
        public Set<C> columnKeySet() {
            return this.fromTable.columnKeySet();
        }

        @Override
        Collection<V2> createValues() {
            return Collections2.transform(this.fromTable.values(), this.function);
        }

        @Override
        public Map<R, Map<C, V2>> rowMap() {
            return Maps.transformValues(this.fromTable.rowMap(), new Function<Map<C, V1>, Map<C, V2>>() {
                @Override
                public Map<C, V2> apply(Map<C, V1> map) {
                    return Maps.transformValues(map, TransformedTable.this.function);
                }
            });
        }

        @Override
        public Map<C, Map<R, V2>> columnMap() {
            return Maps.transformValues(this.fromTable.columnMap(), new Function<Map<R, V1>, Map<R, V2>>() {
                @Override
                public Map<R, V2> apply(Map<R, V1> map) {
                    return Maps.transformValues(map, TransformedTable.this.function);
                }
            });
        }
    }

    public static <R, C, V> Table<R, C, V> unmodifiableTable(Table<? extends R, ? extends C, ? extends V> table) {
        return new UnmodifiableTable(table);
    }

    private static class UnmodifiableTable<R, C, V> extends ForwardingTable<R, C, V> implements Serializable {
        private static final long serialVersionUID = 0;
        final Table<? extends R, ? extends C, ? extends V> delegate;

        UnmodifiableTable(Table<? extends R, ? extends C, ? extends V> table) {
            this.delegate = (Table) Preconditions.checkNotNull(table);
        }

        @Override
        public Table<R, C, V> delegate() {
            return this.delegate;
        }

        @Override
        public Set<Table.Cell<R, C, V>> cellSet() {
            return Collections.unmodifiableSet(super.cellSet());
        }

        @Override
        public void clear() {
            throw new UnsupportedOperationException();
        }

        @Override
        public Map<R, V> column(@ParametricNullness C c) {
            return Collections.unmodifiableMap(super.column(c));
        }

        @Override
        public Set<C> columnKeySet() {
            return Collections.unmodifiableSet(super.columnKeySet());
        }

        @Override
        public Map<C, Map<R, V>> columnMap() {
            return Collections.unmodifiableMap(Maps.transformValues(super.columnMap(), Tables.unmodifiableWrapper()));
        }

        @Override
        @CheckForNull
        public V put(@ParametricNullness R r, @ParametricNullness C c, @ParametricNullness V v) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void putAll(Table<? extends R, ? extends C, ? extends V> table) {
            throw new UnsupportedOperationException();
        }

        @Override
        @CheckForNull
        public V remove(@CheckForNull Object obj, @CheckForNull Object obj2) {
            throw new UnsupportedOperationException();
        }

        @Override
        public Map<C, V> row(@ParametricNullness R r) {
            return Collections.unmodifiableMap(super.row(r));
        }

        @Override
        public Set<R> rowKeySet() {
            return Collections.unmodifiableSet(super.rowKeySet());
        }

        @Override
        public Map<R, Map<C, V>> rowMap() {
            return Collections.unmodifiableMap(Maps.transformValues(super.rowMap(), Tables.unmodifiableWrapper()));
        }

        @Override
        public Collection<V> values() {
            return Collections.unmodifiableCollection(super.values());
        }
    }

    public static <R, C, V> RowSortedTable<R, C, V> unmodifiableRowSortedTable(RowSortedTable<R, ? extends C, ? extends V> rowSortedTable) {
        return new UnmodifiableRowSortedMap(rowSortedTable);
    }

    static final class UnmodifiableRowSortedMap<R, C, V> extends UnmodifiableTable<R, C, V> implements RowSortedTable<R, C, V> {
        private static final long serialVersionUID = 0;

        public UnmodifiableRowSortedMap(RowSortedTable<R, ? extends C, ? extends V> rowSortedTable) {
            super(rowSortedTable);
        }

        @Override
        public RowSortedTable<R, C, V> delegate() {
            return (RowSortedTable) super.delegate();
        }

        @Override
        public SortedMap<R, Map<C, V>> rowMap() {
            return Collections.unmodifiableSortedMap(Maps.transformValues((SortedMap) delegate().rowMap(), Tables.unmodifiableWrapper()));
        }

        @Override
        public SortedSet<R> rowKeySet() {
            return Collections.unmodifiableSortedSet(delegate().rowKeySet());
        }
    }

    public static <K, V> Function<Map<K, V>, Map<K, V>> unmodifiableWrapper() {
        return (Function<Map<K, V>, Map<K, V>>) UNMODIFIABLE_WRAPPER;
    }

    public static <R, C, V> Table<R, C, V> synchronizedTable(Table<R, C, V> table) {
        return Synchronized.table(table, null);
    }

    static boolean equalsImpl(Table<?, ?, ?> table, @CheckForNull Object obj) {
        if (obj == table) {
            return true;
        }
        if (obj instanceof Table) {
            return table.cellSet().equals(((Table) obj).cellSet());
        }
        return false;
    }
}
