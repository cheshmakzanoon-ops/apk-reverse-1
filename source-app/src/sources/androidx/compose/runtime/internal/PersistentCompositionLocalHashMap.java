package androidx.compose.runtime.internal;

import androidx.compose.runtime.CompositionLocal;
import androidx.compose.runtime.CompositionLocalMapKt;
import androidx.compose.runtime.PersistentCompositionLocalMap;
import androidx.compose.runtime.ValueHolder;
import androidx.compose.runtime.external.kotlinx.collections.immutable.ImmutableSet;
import androidx.compose.runtime.external.kotlinx.collections.immutable.PersistentMap;
import androidx.compose.runtime.external.kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMap;
import androidx.compose.runtime.external.kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMapBuilder;
import androidx.compose.runtime.external.kotlinx.collections.immutable.implementations.immutableMap.TrieNode;
import androidx.compose.runtime.external.kotlinx.collections.immutable.internal.MutabilityOwnership;
import j$.util.Map;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010&\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\b\u0000\u0018\u0000 \u00192\u001e\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u0002\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u00040\u00012\u00020\u0005:\u0002\u0018\u0019B1\u0012\"\u0010\u0006\u001a\u001e\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u0002\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u00040\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\b\u0010\u0010\u001a\u00020\u0011H\u0016J\"\u0010\u0012\u001a\u0002H\u0013\"\u0004\b\u0000\u0010\u00132\f\u0010\u0014\u001a\b\u0012\u0004\u0012\u0002H\u00130\u0002H\u0096\u0002¢\u0006\u0002\u0010\u0015J(\u0010\u0016\u001a\u00020\u00052\u000e\u0010\u0014\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u00022\u000e\u0010\u0017\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u0004H\u0016R6\u0010\u000b\u001a$\u0012 \u0012\u001e\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u0002\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u00040\r0\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u001a"}, d2 = {"Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap;", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;", "Landroidx/compose/runtime/CompositionLocal;", "", "Landroidx/compose/runtime/ValueHolder;", "Landroidx/compose/runtime/PersistentCompositionLocalMap;", "node", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "size", "", "(Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/immutableMap/TrieNode;I)V", "entries", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/ImmutableSet;", "", "getEntries", "()Landroidx/compose/runtime/external/kotlinx/collections/immutable/ImmutableSet;", "builder", "Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap$Builder;", "get", "T", "key", "(Landroidx/compose/runtime/CompositionLocal;)Ljava/lang/Object;", "putValue", "value", "Builder", "Companion", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class PersistentCompositionLocalHashMap extends PersistentHashMap<CompositionLocal<Object>, ValueHolder<Object>> implements PersistentCompositionLocalMap, Map {
    public static final int $stable = 0;

    public static final Companion INSTANCE = new Companion(null);
    private static final PersistentCompositionLocalHashMap Empty;

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
    public Object getCurrentValue(CompositionLocal compositionLocal) {
        return CompositionLocalMapKt.read(this, compositionLocal);
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
    public boolean remove(Object obj, Object obj2) {
        return Map.-CC.$default$remove(this, obj, obj2);
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

    public boolean containsKey(CompositionLocal<Object> compositionLocal) {
        return super.containsKey(compositionLocal);
    }

    @Override
    public final boolean containsKey(Object obj) {
        if (obj instanceof CompositionLocal) {
            return containsKey((CompositionLocal<Object>) obj);
        }
        return false;
    }

    public boolean containsValue(ValueHolder<Object> valueHolder) {
        return super.containsValue((Object) valueHolder);
    }

    @Override
    public final boolean containsValue(Object obj) {
        if (obj instanceof ValueHolder) {
            return containsValue((ValueHolder<Object>) obj);
        }
        return false;
    }

    @Override
    public ValueHolder<Object> get(CompositionLocal<Object> compositionLocal) {
        return (ValueHolder) super.get(compositionLocal);
    }

    @Override
    public final ValueHolder<Object> get(Object obj) {
        if (obj instanceof CompositionLocal) {
            return get((CompositionLocal<Object>) obj);
        }
        return null;
    }

    @Override
    public final Object get(Object obj) {
        if (obj instanceof CompositionLocal) {
            return get((CompositionLocal<Object>) obj);
        }
        return null;
    }

    public ValueHolder<Object> getOrDefault(CompositionLocal<Object> compositionLocal, ValueHolder<Object> valueHolder) {
        return (ValueHolder) Map.-CC.$default$getOrDefault(this, compositionLocal, valueHolder);
    }

    public final ValueHolder getOrDefault(Object obj, ValueHolder valueHolder) {
        return !(obj instanceof CompositionLocal) ? valueHolder : getOrDefault((CompositionLocal<Object>) obj, (ValueHolder<Object>) valueHolder);
    }

    @Override
    public final Object getOrDefault(Object obj, Object obj2) {
        return !(obj instanceof CompositionLocal) ? obj2 : getOrDefault((CompositionLocal<Object>) obj, (ValueHolder<Object>) obj2);
    }

    public PersistentCompositionLocalHashMap(TrieNode<CompositionLocal<Object>, ValueHolder<Object>> trieNode, int i) {
        super(trieNode, i);
    }

    @Override
    public ImmutableSet<java.util.Map.Entry<CompositionLocal<Object>, ValueHolder<Object>>> getEntries() {
        return super.getEntries();
    }

    @Override
    public <T> T get(CompositionLocal<T> key) {
        return (T) CompositionLocalMapKt.read(this, key);
    }

    @Override
    public PersistentCompositionLocalMap putValue(CompositionLocal<Object> key, ValueHolder<Object> value) {
        TrieNode.ModificationResult<CompositionLocal<Object>, ValueHolder<Object>> modificationResultPut = getNode$runtime_release().put(key.hashCode(), key, value, 0);
        return modificationResultPut == null ? this : new PersistentCompositionLocalHashMap(modificationResultPut.getNode(), size() + modificationResultPut.getSizeDelta());
    }

    @Override
    public PersistentMap.Builder<CompositionLocal<Object>, ValueHolder<Object>> builder2() {
        return new Builder(this);
    }

    @Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0007\u0018\u00002\u001e\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u0002\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00030\u00040\u00012\u00020\u0005B\r\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\b\u0010\f\u001a\u00020\u0007H\u0016R\u001a\u0010\u0006\u001a\u00020\u0007X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\b¨\u0006\r"}, d2 = {"Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap$Builder;", "Landroidx/compose/runtime/external/kotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;", "Landroidx/compose/runtime/CompositionLocal;", "", "Landroidx/compose/runtime/ValueHolder;", "Landroidx/compose/runtime/PersistentCompositionLocalMap$Builder;", "map", "Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap;", "(Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap;)V", "getMap$runtime_release", "()Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap;", "setMap$runtime_release", "build", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Builder extends PersistentHashMapBuilder<CompositionLocal<Object>, ValueHolder<Object>> implements PersistentCompositionLocalMap.Builder, Map {
        public static final int $stable = 8;
        private PersistentCompositionLocalHashMap map;

        public boolean containsKey(CompositionLocal<Object> compositionLocal) {
            return super.containsKey(compositionLocal);
        }

        @Override
        public final boolean containsKey(Object obj) {
            if (obj instanceof CompositionLocal) {
                return containsKey((CompositionLocal<Object>) obj);
            }
            return false;
        }

        public boolean containsValue(ValueHolder<Object> valueHolder) {
            return super.containsValue((Object) valueHolder);
        }

        @Override
        public final boolean containsValue(Object obj) {
            if (obj instanceof ValueHolder) {
                return containsValue((ValueHolder<Object>) obj);
            }
            return false;
        }

        public ValueHolder<Object> get(CompositionLocal<Object> compositionLocal) {
            return (ValueHolder) super.get(compositionLocal);
        }

        @Override
        public final ValueHolder<Object> get(Object obj) {
            if (obj instanceof CompositionLocal) {
                return get((CompositionLocal<Object>) obj);
            }
            return null;
        }

        @Override
        public final Object get(Object obj) {
            if (obj instanceof CompositionLocal) {
                return get((CompositionLocal<Object>) obj);
            }
            return null;
        }

        public ValueHolder<Object> getOrDefault(CompositionLocal<Object> compositionLocal, ValueHolder<Object> valueHolder) {
            return (ValueHolder) Map.-CC.$default$getOrDefault(this, compositionLocal, valueHolder);
        }

        public final ValueHolder getOrDefault(Object obj, ValueHolder valueHolder) {
            return !(obj instanceof CompositionLocal) ? valueHolder : getOrDefault((CompositionLocal<Object>) obj, (ValueHolder<Object>) valueHolder);
        }

        @Override
        public final Object getOrDefault(Object obj, Object obj2) {
            return !(obj instanceof CompositionLocal) ? obj2 : getOrDefault((CompositionLocal<Object>) obj, (ValueHolder<Object>) obj2);
        }

        public ValueHolder<Object> remove(CompositionLocal<Object> compositionLocal) {
            return (ValueHolder) super.remove(compositionLocal);
        }

        @Override
        public final ValueHolder<Object> remove(Object obj) {
            if (obj instanceof CompositionLocal) {
                return remove((CompositionLocal<Object>) obj);
            }
            return null;
        }

        @Override
        public final Object remove(Object obj) {
            if (obj instanceof CompositionLocal) {
                return remove((CompositionLocal<Object>) obj);
            }
            return null;
        }

        public final PersistentCompositionLocalHashMap getMap() {
            return this.map;
        }

        public final void setMap$runtime_release(PersistentCompositionLocalHashMap persistentCompositionLocalHashMap) {
            this.map = persistentCompositionLocalHashMap;
        }

        public Builder(PersistentCompositionLocalHashMap persistentCompositionLocalHashMap) {
            super(persistentCompositionLocalHashMap);
            this.map = persistentCompositionLocalHashMap;
        }

        @Override
        public PersistentMap<CompositionLocal<Object>, ValueHolder<Object>> build2() {
            PersistentCompositionLocalHashMap persistentCompositionLocalHashMap;
            if (getNode$runtime_release() == this.map.getNode$runtime_release()) {
                persistentCompositionLocalHashMap = this.map;
            } else {
                setOwnership(new MutabilityOwnership());
                persistentCompositionLocalHashMap = new PersistentCompositionLocalHashMap(getNode$runtime_release(), size());
            }
            this.map = persistentCompositionLocalHashMap;
            return persistentCompositionLocalHashMap;
        }
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0017\u0010\u0003\u001a\u00020\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0005\u0010\u0002\u001a\u0004\b\u0006\u0010\u0007¨\u0006\b"}, d2 = {"Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap$Companion;", "", "()V", "Empty", "Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap;", "getEmpty$annotations", "getEmpty", "()Landroidx/compose/runtime/internal/PersistentCompositionLocalHashMap;", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        public static void getEmpty$annotations() {
        }

        private Companion() {
        }

        public final PersistentCompositionLocalHashMap getEmpty() {
            return PersistentCompositionLocalHashMap.Empty;
        }
    }

    static {
        TrieNode eMPTY$runtime_release = TrieNode.INSTANCE.getEMPTY$runtime_release();
        Intrinsics.checkNotNull(eMPTY$runtime_release, "null cannot be cast to non-null type androidx.compose.runtime.external.kotlinx.collections.immutable.implementations.immutableMap.TrieNode<androidx.compose.runtime.CompositionLocal<kotlin.Any?>, androidx.compose.runtime.ValueHolder<kotlin.Any?>>");
        Empty = new PersistentCompositionLocalHashMap(eMPTY$runtime_release, 0);
    }
}
