package com.google.common.collect;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public interface SetMultimap<K, V> extends Multimap<K, V> {
    @Override
    Map<K, Collection<V>> asMap();

    @Override
    Set<Map.Entry<K, V>> entries();

    @Override
    boolean equals(@CheckForNull Object obj);

    @Override
    Set<V> get(@ParametricNullness K k);

    @Override
    Set<V> removeAll(@CheckForNull Object obj);

    @Override
    Set<V> replaceValues(@ParametricNullness K k, Iterable<? extends V> iterable);

    public final class CC {
    }
}
