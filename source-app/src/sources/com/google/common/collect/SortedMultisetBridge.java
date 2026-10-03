package com.google.common.collect;

import java.util.SortedSet;

@ElementTypesAreNonnullByDefault
interface SortedMultisetBridge<E> extends Multiset<E> {
    @Override
    SortedSet<E> elementSet();

    public final class CC {
    }
}
