package com.google.common.collect;

import com.google.common.base.Preconditions;
import java.util.Map;

@ElementTypesAreNonnullByDefault
class SingletonImmutableTable<R, C, V> extends ImmutableTable<R, C, V> {
    final C singleColumnKey;
    final R singleRowKey;
    final V singleValue;

    @Override
    public int size() {
        return 1;
    }

    SingletonImmutableTable(R r, C c, V v) {
        this.singleRowKey = (R) Preconditions.checkNotNull(r);
        this.singleColumnKey = (C) Preconditions.checkNotNull(c);
        this.singleValue = (V) Preconditions.checkNotNull(v);
    }

    SingletonImmutableTable(Table.Cell<R, C, V> cell) {
        this(cell.getRowKey(), cell.getColumnKey(), cell.getValue());
    }

    @Override
    public ImmutableMap<R, V> column(C c) {
        Preconditions.checkNotNull(c);
        if (containsColumn(c)) {
            return ImmutableMap.m180of(this.singleRowKey, (Object) this.singleValue);
        }
        return ImmutableMap.m179of();
    }

    @Override
    public ImmutableMap<C, Map<R, V>> columnMap() {
        return ImmutableMap.m180of(this.singleColumnKey, ImmutableMap.m180of(this.singleRowKey, (Object) this.singleValue));
    }

    @Override
    public ImmutableMap<R, Map<C, V>> rowMap() {
        return ImmutableMap.m180of(this.singleRowKey, ImmutableMap.m180of(this.singleColumnKey, (Object) this.singleValue));
    }

    @Override
    public ImmutableSet<Table.Cell<R, C, V>> createCellSet() {
        return ImmutableSet.m208of(cellOf(this.singleRowKey, this.singleColumnKey, this.singleValue));
    }

    @Override
    public ImmutableCollection<V> createValues() {
        return ImmutableSet.m208of(this.singleValue);
    }

    @Override
    ImmutableTable.SerializedForm createSerializedForm() {
        return ImmutableTable.SerializedForm.create(this, new int[]{0}, new int[]{0});
    }
}
