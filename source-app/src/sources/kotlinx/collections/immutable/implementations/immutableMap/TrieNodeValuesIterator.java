package kotlinx.collections.immutable.implementations.immutableMap;

import kotlin.Metadata;
import kotlinx.collections.immutable.internal.CommonFunctionsKt;

@Metadata(m17d1 = {"\u0000\u0010\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000*\u0006\b\u0000\u0010\u0001 \u0001*\u0006\b\u0001\u0010\u0002 \u00012\u0014\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u0002H\u00020\u0003B\u0005¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0005\u001a\u00028\u0001H\u0096\u0002¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableMap/TrieNodeValuesIterator;", "K", "V", "Lkotlinx/collections/immutable/implementations/immutableMap/TrieNodeBaseIterator;", "()V", "next", "()Ljava/lang/Object;", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class TrieNodeValuesIterator<K, V> extends TrieNodeBaseIterator<K, V, V> {
    @Override
    public V next() {
        CommonFunctionsKt.m1793assert(hasNextKey());
        setIndex(getIndex() + 2);
        return (V) getBuffer()[getIndex() - 1];
    }
}
