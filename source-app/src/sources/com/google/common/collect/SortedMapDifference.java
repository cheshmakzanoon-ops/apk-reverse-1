package com.google.common.collect;

import java.util.SortedMap;

@ElementTypesAreNonnullByDefault
public interface SortedMapDifference<K, V> extends MapDifference<K, V> {
    @Override
    SortedMap<K, MapDifference.ValueDifference<V>> entriesDiffering();

    @Override
    SortedMap<K, V> entriesInCommon();

    @Override
    SortedMap<K, V> entriesOnlyOnLeft();

    @Override
    SortedMap<K, V> entriesOnlyOnRight();

    public final class CC {
    }
}
