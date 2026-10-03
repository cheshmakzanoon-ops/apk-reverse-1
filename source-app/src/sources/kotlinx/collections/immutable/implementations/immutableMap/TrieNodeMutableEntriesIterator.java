package kotlinx.collections.immutable.implementations.immutableMap;

import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.internal.CommonFunctionsKt;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010'\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u0001*\u0004\b\u0001\u0010\u00022 \u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u00020\u00040\u0003B\u0019\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0006¢\u0006\u0002\u0010\u0007J\u0015\u0010\b\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0004H\u0096\u0002R\u001a\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\t"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableMap/TrieNodeMutableEntriesIterator;", "K", "V", "Lkotlinx/collections/immutable/implementations/immutableMap/TrieNodeBaseIterator;", "", "parentIterator", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilderEntriesIterator;", "(Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilderEntriesIterator;)V", "next", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class TrieNodeMutableEntriesIterator<K, V> extends TrieNodeBaseIterator<K, V, Map.Entry<K, V>> {
    private final PersistentHashMapBuilderEntriesIterator<K, V> parentIterator;

    public TrieNodeMutableEntriesIterator(PersistentHashMapBuilderEntriesIterator<K, V> parentIterator) {
        Intrinsics.checkNotNullParameter(parentIterator, "parentIterator");
        this.parentIterator = parentIterator;
    }

    @Override
    public Map.Entry<K, V> next() {
        CommonFunctionsKt.m1793assert(hasNextKey());
        setIndex(getIndex() + 2);
        return new MutableMapEntry(this.parentIterator, getBuffer()[getIndex() - 2], getBuffer()[getIndex() - 1]);
    }
}
