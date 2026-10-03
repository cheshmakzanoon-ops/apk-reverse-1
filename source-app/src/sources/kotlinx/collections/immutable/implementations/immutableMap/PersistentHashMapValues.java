package kotlinx.collections.immutable.implementations.immutableMap;

import java.util.Iterator;
import kotlin.Metadata;
import kotlin.collections.AbstractCollection;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.ImmutableCollection;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010(\n\u0000\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u0001*\u0004\b\u0001\u0010\u00022\b\u0012\u0004\u0012\u0002H\u00020\u00032\b\u0012\u0004\u0012\u0002H\u00020\u0004B\u0019\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0006¢\u0006\u0002\u0010\u0007J\u0016\u0010\f\u001a\u00020\r2\u0006\u0010\u000e\u001a\u00028\u0001H\u0096\u0002¢\u0006\u0002\u0010\u000fJ\u000f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00028\u00010\u0011H\u0096\u0002R\u001a\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\b\u001a\u00020\t8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\u000b¨\u0006\u0012"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapValues;", "K", "V", "Lkotlinx/collections/immutable/ImmutableCollection;", "Lkotlin/collections/AbstractCollection;", "map", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;", "(Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;)V", "size", "", "getSize", "()I", "contains", "", "element", "(Ljava/lang/Object;)Z", "iterator", "", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class PersistentHashMapValues<K, V> extends AbstractCollection<V> implements ImmutableCollection<V> {
    private final PersistentHashMap<K, V> map;

    public PersistentHashMapValues(PersistentHashMap<K, V> map) {
        Intrinsics.checkNotNullParameter(map, "map");
        this.map = map;
    }

    @Override
    public int getSize() {
        return this.map.size();
    }

    @Override
    public boolean contains(Object element) {
        return this.map.containsValue(element);
    }

    @Override
    public Iterator<V> iterator() {
        return new PersistentHashMapValuesIterator(this.map.getNode$kotlinx_collections_immutable());
    }
}
