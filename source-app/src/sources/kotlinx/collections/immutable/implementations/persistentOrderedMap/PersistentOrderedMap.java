package kotlinx.collections.immutable.implementations.persistentOrderedMap;

import java.util.Map;
import java.util.Set;
import kotlin.Metadata;
import kotlin.collections.AbstractMap;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.ImmutableCollection;
import kotlinx.collections.immutable.ImmutableSet;
import kotlinx.collections.immutable.PersistentMap;
import kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMap;
import kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMapBuilder;
import kotlinx.collections.immutable.internal.EndOfChain;

@Metadata(m17d1 = {"\u0000b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010&\n\u0002\b\n\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0007\n\u0002\u0010\"\n\u0002\b\u0006\n\u0002\u0010$\n\u0002\b\u0004\b\u0000\u0018\u0000 6*\u0004\b\u0000\u0010\u0001*\u0004\b\u0001\u0010\u00022\u000e\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u00020\u00032\u000e\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u00020\u0004:\u00016B3\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0006\u0012\u0018\u0010\b\u001a\u0014\u0012\u0004\u0012\u00028\u0000\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00010\n0\t¢\u0006\u0002\u0010\u000bJ\u0014\u0010 \u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010!H\u0016J\u0014\u0010\"\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0004H\u0016J\u0015\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010&J\u001a\u0010'\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u000e0\rH\u0002J\u0013\u0010(\u001a\u00020$2\b\u0010)\u001a\u0004\u0018\u00010\u0006H\u0096\u0002J\u0018\u0010*\u001a\u0004\u0018\u00018\u00012\u0006\u0010%\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010+J\u001a\u0010\u000f\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u000e0,H\u0001J\b\u0010-\u001a\u00020\u0019H\u0016J)\u0010.\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010%\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u0001H\u0016¢\u0006\u0002\u00100J*\u00101\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00042\u0014\u00102\u001a\u0010\u0012\u0006\b\u0001\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u000103H\u0016J!\u00104\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010%\u001a\u00028\u0000H\u0016¢\u0006\u0002\u00105J)\u00104\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u00002\u0006\u0010%\u001a\u00028\u00002\u0006\u0010/\u001a\u00028\u0001H\u0016¢\u0006\u0002\u00100R&\u0010\f\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u000e0\r8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010R\u0016\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R&\u0010\b\u001a\u0014\u0012\u0004\u0012\u00028\u0000\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00010\n0\tX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u001a\u0010\u0015\u001a\b\u0012\u0004\u0012\u00028\u00000\r8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0016\u0010\u0010R\u0016\u0010\u0007\u001a\u0004\u0018\u00010\u0006X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0012R\u0014\u0010\u0018\u001a\u00020\u00198VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001a\u0010\u001bR\u001a\u0010\u001c\u001a\b\u0012\u0004\u0012\u00028\u00010\u001d8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001e\u0010\u001f¨\u00067"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/persistentOrderedMap/PersistentOrderedMap;", "K", "V", "Lkotlin/collections/AbstractMap;", "Lkotlinx/collections/immutable/PersistentMap;", "firstKey", "", "lastKey", "hashMap", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;", "Lkotlinx/collections/immutable/implementations/persistentOrderedMap/LinkedValue;", "(Ljava/lang/Object;Ljava/lang/Object;Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;)V", "entries", "Lkotlinx/collections/immutable/ImmutableSet;", "", "getEntries", "()Lkotlinx/collections/immutable/ImmutableSet;", "getFirstKey$kotlinx_collections_immutable", "()Ljava/lang/Object;", "getHashMap$kotlinx_collections_immutable", "()Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;", "keys", "getKeys", "getLastKey$kotlinx_collections_immutable", "size", "", "getSize", "()I", "values", "Lkotlinx/collections/immutable/ImmutableCollection;", "getValues", "()Lkotlinx/collections/immutable/ImmutableCollection;", "builder", "Lkotlinx/collections/immutable/PersistentMap$Builder;", "clear", "containsKey", "", "key", "(Ljava/lang/Object;)Z", "createEntries", "equals", "other", "get", "(Ljava/lang/Object;)Ljava/lang/Object;", "", "hashCode", "put", "value", "(Ljava/lang/Object;Ljava/lang/Object;)Lkotlinx/collections/immutable/implementations/persistentOrderedMap/PersistentOrderedMap;", "putAll", "m", "", "remove", "(Ljava/lang/Object;)Lkotlinx/collections/immutable/implementations/persistentOrderedMap/PersistentOrderedMap;", "Companion", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class PersistentOrderedMap<K, V> extends AbstractMap<K, V> implements PersistentMap<K, V> {

    public static final Companion INSTANCE = new Companion(null);
    private static final PersistentOrderedMap EMPTY = new PersistentOrderedMap(EndOfChain.INSTANCE, EndOfChain.INSTANCE, PersistentHashMap.INSTANCE.emptyOf$kotlinx_collections_immutable());
    private final Object firstKey;
    private final PersistentHashMap<K, LinkedValue<V>> hashMap;
    private final Object lastKey;

    @Override
    public final ImmutableSet<Map.Entry<K, V>> entrySet() {
        return getEntries();
    }

    @Override
    public final ImmutableSet<K> keySet() {
        return getKeys();
    }

    @Override
    public final ImmutableCollection<V> values() {
        return getValues();
    }

    public final Object getFirstKey() {
        return this.firstKey;
    }

    public final Object getLastKey() {
        return this.lastKey;
    }

    public final PersistentHashMap<K, LinkedValue<V>> getHashMap$kotlinx_collections_immutable() {
        return this.hashMap;
    }

    public PersistentOrderedMap(Object obj, Object obj2, PersistentHashMap<K, LinkedValue<V>> hashMap) {
        Intrinsics.checkNotNullParameter(hashMap, "hashMap");
        this.firstKey = obj;
        this.lastKey = obj2;
        this.hashMap = hashMap;
    }

    @Override
    public int getSize() {
        return this.hashMap.size();
    }

    @Override
    public ImmutableSet<K> getKeys() {
        return new PersistentOrderedMapKeys(this);
    }

    @Override
    public ImmutableCollection<V> getValues() {
        return new PersistentOrderedMapValues(this);
    }

    @Override
    public ImmutableSet<Map.Entry<K, V>> getEntries() {
        return createEntries();
    }

    private final ImmutableSet<Map.Entry<K, V>> createEntries() {
        return new PersistentOrderedMapEntries(this);
    }

    @Override
    public final Set<Map.Entry<K, V>> getEntries() {
        return createEntries();
    }

    @Override
    public boolean containsKey(Object key) {
        return this.hashMap.containsKey(key);
    }

    @Override
    public V get(Object key) {
        LinkedValue<V> linkedValue = this.hashMap.get(key);
        if (linkedValue == null) {
            return null;
        }
        return linkedValue.getValue();
    }

    @Override
    public PersistentOrderedMap<K, V> put(K key, V value) {
        if (isEmpty()) {
            return new PersistentOrderedMap<>(key, key, this.hashMap.put((Object) key, new LinkedValue<>(value)));
        }
        LinkedValue<V> linkedValue = this.hashMap.get(key);
        if (linkedValue != null) {
            if (linkedValue.getValue() == value) {
                return this;
            }
            return new PersistentOrderedMap<>(this.firstKey, this.lastKey, this.hashMap.put((Object) key, linkedValue.withValue(value)));
        }
        Object obj = this.lastKey;
        LinkedValue<V> linkedValue2 = this.hashMap.get(obj);
        Intrinsics.checkNotNull(linkedValue2);
        return new PersistentOrderedMap<>(this.firstKey, key, this.hashMap.put((Object) obj, linkedValue2.withNext(key)).put((Object) key, new LinkedValue<>(value, obj)));
    }

    @Override
    public PersistentOrderedMap<K, V> remove(K key) {
        ?? r5;
        LinkedValue<V> linkedValue = this.hashMap.get(key);
        if (linkedValue == null) {
            return this;
        }
        PersistentHashMap<K, LinkedValue<V>> persistentHashMapRemove = this.hashMap.remove((Object) key);
        if (linkedValue.getHasPrevious()) {
            r5 = persistentHashMapRemove;
            Object obj = persistentHashMapRemove.get(linkedValue.getPrevious());
            Intrinsics.checkNotNull(obj);
            r5 = (PersistentHashMap<K, LinkedValue<V>>) persistentHashMapRemove.put(linkedValue.getPrevious(), ((LinkedValue) obj).withNext(linkedValue.getNext()));
        }
        r5 = persistentHashMapRemove;
        ?? Put = r5;
        if (linkedValue.getHasNext()) {
            Object obj2 = ((Map) r5).get(linkedValue.getNext());
            Intrinsics.checkNotNull(obj2);
            Put = r5.put(linkedValue.getNext(), ((LinkedValue) obj2).withPrevious(linkedValue.getPrevious()));
        }
        return new PersistentOrderedMap<>(!linkedValue.getHasPrevious() ? linkedValue.getNext() : this.firstKey, !linkedValue.getHasNext() ? linkedValue.getPrevious() : this.lastKey, Put);
    }

    @Override
    public PersistentOrderedMap<K, V> remove(K key, V value) {
        LinkedValue<V> linkedValue = this.hashMap.get(key);
        if (linkedValue != null && Intrinsics.areEqual(linkedValue.getValue(), value)) {
            return remove((Object) key);
        }
        return this;
    }

    @Override
    public PersistentMap<K, V> putAll(Map<? extends K, ? extends V> m) {
        Intrinsics.checkNotNullParameter(m, "m");
        PersistentMap.Builder<K, V> builder = builder();
        builder.putAll(m);
        return builder.build();
    }

    @Override
    public PersistentMap<K, V> clear() {
        return INSTANCE.emptyOf$kotlinx_collections_immutable();
    }

    @Override
    public PersistentMap.Builder<K, V> builder() {
        return new PersistentOrderedMapBuilder(this);
    }

    @Override
    public boolean equals(Object other) {
        if (other == this) {
            return true;
        }
        if (!(other instanceof Map)) {
            return false;
        }
        Map map = (Map) other;
        if (size() != map.size()) {
            return false;
        }
        if (map instanceof PersistentOrderedMap) {
            return this.hashMap.getNode$kotlinx_collections_immutable().equalsWith$kotlinx_collections_immutable(((PersistentOrderedMap) other).hashMap.getNode$kotlinx_collections_immutable(), new Function2<LinkedValue<V>, ?, Boolean>() {
                @Override
                public final Boolean invoke(LinkedValue<V> a, LinkedValue<? extends Object> b) {
                    Intrinsics.checkNotNullParameter(a, "a");
                    Intrinsics.checkNotNullParameter(b, "b");
                    return Boolean.valueOf(Intrinsics.areEqual(a.getValue(), b.getValue()));
                }
            });
        }
        if (map instanceof PersistentOrderedMapBuilder) {
            return this.hashMap.getNode$kotlinx_collections_immutable().equalsWith$kotlinx_collections_immutable(((PersistentOrderedMapBuilder) other).getHashMapBuilder$kotlinx_collections_immutable().getNode$kotlinx_collections_immutable(), new Function2<LinkedValue<V>, ?, Boolean>() {
                @Override
                public final Boolean invoke(LinkedValue<V> a, LinkedValue<? extends Object> b) {
                    Intrinsics.checkNotNullParameter(a, "a");
                    Intrinsics.checkNotNullParameter(b, "b");
                    return Boolean.valueOf(Intrinsics.areEqual(a.getValue(), b.getValue()));
                }
            });
        }
        if (map instanceof PersistentHashMap) {
            return this.hashMap.getNode$kotlinx_collections_immutable().equalsWith$kotlinx_collections_immutable(((PersistentHashMap) other).getNode$kotlinx_collections_immutable(), new Function2<LinkedValue<V>, ?, Boolean>() {
                @Override
                public Boolean invoke(Object obj, Object obj2) {
                    return invoke((LinkedValue) obj, (Object) obj2);
                }

                public final Boolean invoke(LinkedValue<V> a, Object obj) {
                    Intrinsics.checkNotNullParameter(a, "a");
                    return Boolean.valueOf(Intrinsics.areEqual(a.getValue(), obj));
                }
            });
        }
        if (map instanceof PersistentHashMapBuilder) {
            return this.hashMap.getNode$kotlinx_collections_immutable().equalsWith$kotlinx_collections_immutable(((PersistentHashMapBuilder) other).getNode$kotlinx_collections_immutable(), new Function2<LinkedValue<V>, ?, Boolean>() {
                @Override
                public Boolean invoke(Object obj, Object obj2) {
                    return invoke((LinkedValue) obj, (Object) obj2);
                }

                public final Boolean invoke(LinkedValue<V> a, Object obj) {
                    Intrinsics.checkNotNullParameter(a, "a");
                    return Boolean.valueOf(Intrinsics.areEqual(a.getValue(), obj));
                }
            });
        }
        return super.equals(other);
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0001\n\u0002\b\u0005\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J%\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u0002H\u0007\u0012\u0004\u0012\u0002H\b0\u0004\"\u0004\b\u0002\u0010\u0007\"\u0004\b\u0003\u0010\bH\u0000¢\u0006\u0002\b\tR\u001a\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\n"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/persistentOrderedMap/PersistentOrderedMap$Companion;", "", "()V", "EMPTY", "Lkotlinx/collections/immutable/implementations/persistentOrderedMap/PersistentOrderedMap;", "", "emptyOf", "K", "V", "emptyOf$kotlinx_collections_immutable", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final <K, V> PersistentOrderedMap<K, V> emptyOf$kotlinx_collections_immutable() {
            return PersistentOrderedMap.EMPTY;
        }
    }
}
