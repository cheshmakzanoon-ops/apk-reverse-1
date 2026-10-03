package kotlinx.collections.immutable.implementations.immutableMap;

import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010&\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u0001*\u0004\b\u0001\u0010\u00022 \u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u00020\u00040\u0003B\u0019\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0006¢\u0006\u0002\u0010\u0007¨\u0006\b"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapEntriesIterator;", "K", "V", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBaseIterator;", "", "node", "Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "(Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;)V", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class PersistentHashMapEntriesIterator<K, V> extends PersistentHashMapBaseIterator<K, V, Map.Entry<? extends K, ? extends V>> {
    public PersistentHashMapEntriesIterator(TrieNode<K, V> node) {
        Intrinsics.checkNotNullParameter(node, "node");
        TrieNodeBaseIterator[] trieNodeBaseIteratorArr = new TrieNodeBaseIterator[8];
        for (int i = 0; i < 8; i++) {
            trieNodeBaseIteratorArr[i] = new TrieNodeEntriesIterator();
        }
        super(node, trieNodeBaseIteratorArr);
    }
}
