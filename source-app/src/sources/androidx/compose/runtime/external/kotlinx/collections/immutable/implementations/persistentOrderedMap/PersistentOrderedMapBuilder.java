package androidx.compose.runtime.external.kotlinx.collections.immutable.implementations.persistentOrderedMap;

import androidx.compose.runtime.external.kotlinx.collections.immutable.PersistentMap;
import androidx.compose.runtime.external.kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMap;
import androidx.compose.runtime.external.kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMapBuilder;
import androidx.compose.runtime.external.kotlinx.collections.immutable.internal.CommonFunctionsKt;
import androidx.compose.runtime.external.kotlinx.collections.immutable.internal.EndOfChain;
import j$.util.Map;
import java.util.Collection;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;
import kotlin.Metadata;
import kotlin.collections.AbstractMutableMap;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010#\n\u0002\u0010'\n\u0002\b\u0003\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u001f\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\n\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u0001*\u0004\b\u0001\u0010\u00022\u000e\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u00020\u00032\u000e\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u00020\u0004B\u0019\u0012\u0012\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0006¢\u0006\u0002\u0010\u0007J\u0014\u0010\"\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010#H\u0016J\b\u0010$\u001a\u00020%H\u0016J\u0015\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010)J\u0018\u0010*\u001a\u0004\u0018\u00018\u00012\u0006\u0010(\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010+J\u001f\u0010,\u001a\u0004\u0018\u00018\u00012\u0006\u0010(\u001a\u00028\u00002\u0006\u0010-\u001a\u00028\u0001H\u0016¢\u0006\u0002\u0010.J\u0017\u0010/\u001a\u0004\u0018\u00018\u00012\u0006\u0010(\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010+J\u001b\u0010/\u001a\u00020'2\u0006\u0010(\u001a\u00028\u00002\u0006\u0010-\u001a\u00028\u0001¢\u0006\u0002\u00100R&\u0010\b\u001a\u0014\u0012\u0010\u0012\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\n0\t8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u000b\u0010\fR\"\u0010\u000f\u001a\u0004\u0018\u00010\u000e2\b\u0010\r\u001a\u0004\u0018\u00010\u000e@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R&\u0010\u0012\u001a\u0014\u0012\u0004\u0012\u00028\u0000\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00010\u00140\u0013X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u001a\u0010\u0017\u001a\b\u0012\u0004\u0012\u00028\u00000\t8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0018\u0010\fR\u0010\u0010\u0019\u001a\u0004\u0018\u00010\u000eX\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u0005\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u001a\u001a\u00020\u001b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u001c\u0010\u001dR\u001a\u0010\u001e\u001a\b\u0012\u0004\u0012\u00028\u00010\u001f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b \u0010!¨\u00061"}, d2 = {"Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/persistentOrderedMap/PersistentOrderedMapBuilder;", "K", "V", "Lkotlin/collections/AbstractMutableMap;", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/PersistentMap$Builder;", "map", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/persistentOrderedMap/PersistentOrderedMap;", "(Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/persistentOrderedMap/PersistentOrderedMap;)V", "entries", "", "", "getEntries", "()Ljava/util/Set;", "<set-?>", "", "firstKey", "getFirstKey$runtime_release", "()Ljava/lang/Object;", "hashMapBuilder", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/persistentOrderedMap/LinkedValue;", "getHashMapBuilder$runtime_release", "()Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;", "keys", "getKeys", "lastKey", "size", "", "getSize", "()I", "values", "", "getValues", "()Ljava/util/Collection;", "build", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/PersistentMap;", "clear", "", "containsKey", "", "key", "(Ljava/lang/Object;)Z", "get", "(Ljava/lang/Object;)Ljava/lang/Object;", "put", "value", "(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;", "remove", "(Ljava/lang/Object;Ljava/lang/Object;)Z", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class PersistentOrderedMapBuilder<K, V> extends AbstractMutableMap<K, V> implements PersistentMap.Builder<K, V>, Map {
    public static final int $stable = 8;
    private Object firstKey;
    private final PersistentHashMapBuilder<K, LinkedValue<V>> hashMapBuilder;
    private Object lastKey;
    private PersistentOrderedMap<K, V> map;

    @Override
    public Object compute(Object obj, BiFunction biFunction) {
        return Map.-CC.$default$compute(this, obj, biFunction);
    }

    @Override
    public Object computeIfAbsent(Object obj, Function function) {
        return Map.-CC.$default$computeIfAbsent(this, obj, function);
    }

    @Override
    public Object computeIfPresent(Object obj, BiFunction biFunction) {
        return Map.-CC.$default$computeIfPresent(this, obj, biFunction);
    }

    @Override
    public void forEach(BiConsumer biConsumer) {
        Map.-CC.$default$forEach(this, biConsumer);
    }

    @Override
    public Object getOrDefault(Object obj, Object obj2) {
        return Map.-CC.$default$getOrDefault(this, obj, obj2);
    }

    @Override
    public Object merge(Object obj, Object obj2, BiFunction biFunction) {
        return Map.-CC.$default$merge(this, obj, obj2, biFunction);
    }

    @Override
    public Object putIfAbsent(Object obj, Object obj2) {
        return Map.-CC.$default$putIfAbsent(this, obj, obj2);
    }

    @Override
    public Object replace(Object obj, Object obj2) {
        return Map.-CC.$default$replace(this, obj, obj2);
    }

    @Override
    public boolean replace(Object obj, Object obj2, Object obj3) {
        return Map.-CC.$default$replace(this, obj, obj2, obj3);
    }

    @Override
    public void replaceAll(BiFunction biFunction) {
        Map.-CC.$default$replaceAll(this, biFunction);
    }

    public PersistentOrderedMapBuilder(PersistentOrderedMap<K, V> persistentOrderedMap) {
        this.map = persistentOrderedMap;
        this.firstKey = persistentOrderedMap.getFirstKey();
        this.lastKey = this.map.getLastKey();
        this.hashMapBuilder = this.map.getHashMap$runtime_release().builder();
    }

    public final Object getFirstKey() {
        return this.firstKey;
    }

    public final PersistentHashMapBuilder<K, LinkedValue<V>> getHashMapBuilder$runtime_release() {
        return this.hashMapBuilder;
    }

    public int getSize() {
        return this.hashMapBuilder.size();
    }

    @Override
    public PersistentMap<K, V> build() {
        PersistentOrderedMap<K, V> persistentOrderedMap;
        PersistentHashMap<K, LinkedValue<V>> persistentHashMapBuild = this.hashMapBuilder.build();
        if (persistentHashMapBuild == this.map.getHashMap$runtime_release()) {
            CommonFunctionsKt.m4141assert(this.firstKey == this.map.getFirstKey());
            CommonFunctionsKt.m4141assert(this.lastKey == this.map.getLastKey());
            persistentOrderedMap = this.map;
        } else {
            persistentOrderedMap = new PersistentOrderedMap<>(this.firstKey, this.lastKey, persistentHashMapBuild);
        }
        this.map = persistentOrderedMap;
        return persistentOrderedMap;
    }

    public Set<java.util.Map.Entry<K, V>> getEntries() {
        return (Set) new PersistentOrderedMapBuilderEntries(this);
    }

    public Set<K> getKeys() {
        return new PersistentOrderedMapBuilderKeys(this);
    }

    public Collection<V> getValues() {
        return new PersistentOrderedMapBuilderValues(this);
    }

    @Override
    public boolean containsKey(Object key) {
        return this.hashMapBuilder.containsKey(key);
    }

    @Override
    public V get(Object key) {
        LinkedValue<V> linkedValue = this.hashMapBuilder.get(key);
        if (linkedValue != null) {
            return linkedValue.getValue();
        }
        return null;
    }

    @Override
    public V put(K key, V value) {
        LinkedValue<V> linkedValue = this.hashMapBuilder.get(key);
        if (linkedValue != null) {
            if (linkedValue.getValue() == value) {
                return value;
            }
            this.hashMapBuilder.put(key, linkedValue.withValue(value));
            return linkedValue.getValue();
        }
        if (isEmpty()) {
            this.firstKey = key;
            this.lastKey = key;
            this.hashMapBuilder.put(key, new LinkedValue<>(value));
            return null;
        }
        Object obj = this.lastKey;
        LinkedValue<V> linkedValue2 = this.hashMapBuilder.get((K) obj);
        Intrinsics.checkNotNull(linkedValue2);
        LinkedValue<V> linkedValue3 = linkedValue2;
        CommonFunctionsKt.m4141assert(!linkedValue3.getHasNext());
        this.hashMapBuilder.put(obj, linkedValue3.withNext(key));
        this.hashMapBuilder.put(key, new LinkedValue<>(value, obj));
        this.lastKey = key;
        return null;
    }

    @Override
    public V remove(Object key) {
        LinkedValue<V> linkedValueRemove = this.hashMapBuilder.remove(key);
        if (linkedValueRemove == null) {
            return null;
        }
        if (linkedValueRemove.getHasPrevious()) {
            LinkedValue<V> linkedValue = this.hashMapBuilder.get(linkedValueRemove.getPrevious());
            Intrinsics.checkNotNull(linkedValue);
            this.hashMapBuilder.put(linkedValueRemove.getPrevious(), linkedValue.withNext(linkedValueRemove.getNext()));
        } else {
            this.firstKey = linkedValueRemove.getNext();
        }
        if (linkedValueRemove.getHasNext()) {
            LinkedValue<V> linkedValue2 = this.hashMapBuilder.get(linkedValueRemove.getNext());
            Intrinsics.checkNotNull(linkedValue2);
            this.hashMapBuilder.put(linkedValueRemove.getNext(), linkedValue2.withPrevious(linkedValueRemove.getPrevious()));
        } else {
            this.lastKey = linkedValueRemove.getPrevious();
        }
        return linkedValueRemove.getValue();
    }

    @Override
    public final boolean remove(Object key, Object value) {
        LinkedValue<V> linkedValue = this.hashMapBuilder.get(key);
        if (linkedValue == null || !Intrinsics.areEqual(linkedValue.getValue(), value)) {
            return false;
        }
        remove(key);
        return true;
    }

    @Override
    public void clear() {
        this.hashMapBuilder.clear();
        this.firstKey = EndOfChain.INSTANCE;
        this.lastKey = EndOfChain.INSTANCE;
    }
}
