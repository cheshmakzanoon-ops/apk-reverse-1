package com.google.common.collect;

@ElementTypesAreNonnullByDefault
interface FilteredSetMultimap<K, V> extends FilteredMultimap<K, V>, SetMultimap<K, V> {
    @Override
    SetMultimap<K, V> unfiltered();

    public final class CC {
    }
}
