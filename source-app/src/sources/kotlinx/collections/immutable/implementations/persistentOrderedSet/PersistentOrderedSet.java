package kotlinx.collections.immutable.implementations.persistentOrderedSet;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import kotlin.Metadata;
import kotlin.collections.AbstractSet;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.PersistentSet;
import kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMap;
import kotlinx.collections.immutable.internal.EndOfChain;

@Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0010\u001e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0010(\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 **\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003:\u0001*B-\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00020\t0\b¢\u0006\u0002\u0010\nJ\u001b\u0010\u0014\u001a\b\u0012\u0004\u0012\u00028\u00000\u00032\u0006\u0010\u0015\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u0016J\u001c\u0010\u0017\u001a\b\u0012\u0004\u0012\u00028\u00000\u00032\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00028\u00000\u0019H\u0016J\u000e\u0010\u001a\u001a\b\u0012\u0004\u0012\u00028\u00000\u001bH\u0016J\u000e\u0010\u001c\u001a\b\u0012\u0004\u0012\u00028\u00000\u0003H\u0016J\u0016\u0010\u001d\u001a\u00020\u001e2\u0006\u0010\u0015\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010\u001fJ\u0013\u0010 \u001a\u00020\u001e2\b\u0010!\u001a\u0004\u0018\u00010\u0005H\u0096\u0002J\b\u0010\"\u001a\u00020\u0011H\u0016J\u000f\u0010#\u001a\b\u0012\u0004\u0012\u00028\u00000$H\u0096\u0002J\u001b\u0010%\u001a\b\u0012\u0004\u0012\u00028\u00000\u00032\u0006\u0010\u0015\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u0016J\"\u0010&\u001a\b\u0012\u0004\u0012\u00028\u00000\u00032\u0012\u0010'\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00020\u001e0(H\u0016J\u001c\u0010&\u001a\b\u0012\u0004\u0012\u00028\u00000\u00032\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00028\u00000\u0019H\u0016J\u001c\u0010)\u001a\b\u0012\u0004\u0012\u00028\u00000\u00032\f\u0010\u0018\u001a\b\u0012\u0004\u0012\u00028\u00000\u0019H\u0016R\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR \u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00020\t0\bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0016\u0010\u0006\u001a\u0004\u0018\u00010\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\fR\u0014\u0010\u0010\u001a\u00020\u00118VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013¨\u0006+"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/persistentOrderedSet/PersistentOrderedSet;", "E", "Lkotlin/collections/AbstractSet;", "Lkotlinx/collections/immutable/PersistentSet;", "firstElement", "", "lastElement", "hashMap", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;", "Lkotlinx/collections/immutable/implementations/persistentOrderedSet/Links;", "(Ljava/lang/Object;Ljava/lang/Object;Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;)V", "getFirstElement$kotlinx_collections_immutable", "()Ljava/lang/Object;", "getHashMap$kotlinx_collections_immutable", "()Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMap;", "getLastElement$kotlinx_collections_immutable", "size", "", "getSize", "()I", "add", "element", "(Ljava/lang/Object;)Lkotlinx/collections/immutable/PersistentSet;", "addAll", "elements", "", "builder", "Lkotlinx/collections/immutable/PersistentSet$Builder;", "clear", "contains", "", "(Ljava/lang/Object;)Z", "equals", "other", "hashCode", "iterator", "", "remove", "removeAll", "predicate", "Lkotlin/Function1;", "retainAll", "Companion", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class PersistentOrderedSet<E> extends AbstractSet<E> implements PersistentSet<E> {

    public static final Companion INSTANCE = new Companion(null);
    private static final PersistentOrderedSet EMPTY = new PersistentOrderedSet(EndOfChain.INSTANCE, EndOfChain.INSTANCE, PersistentHashMap.INSTANCE.emptyOf$kotlinx_collections_immutable());
    private final Object firstElement;
    private final PersistentHashMap<E, Links> hashMap;
    private final Object lastElement;

    public final Object getFirstElement() {
        return this.firstElement;
    }

    public final Object getLastElement() {
        return this.lastElement;
    }

    public final PersistentHashMap<E, Links> getHashMap$kotlinx_collections_immutable() {
        return this.hashMap;
    }

    public PersistentOrderedSet(Object obj, Object obj2, PersistentHashMap<E, Links> hashMap) {
        Intrinsics.checkNotNullParameter(hashMap, "hashMap");
        this.firstElement = obj;
        this.lastElement = obj2;
        this.hashMap = hashMap;
    }

    @Override
    public int getSize() {
        return this.hashMap.size();
    }

    @Override
    public boolean contains(Object element) {
        return this.hashMap.containsKey(element);
    }

    @Override
    public PersistentSet<E> add(E element) {
        if (this.hashMap.containsKey(element)) {
            return this;
        }
        if (isEmpty()) {
            return new PersistentOrderedSet(element, element, this.hashMap.put(element, new Links()));
        }
        Object obj = this.lastElement;
        Links links = this.hashMap.get(obj);
        Intrinsics.checkNotNull(links);
        return new PersistentOrderedSet(this.firstElement, element, this.hashMap.put((E) obj, links.withNext(element)).put(element, new Links(obj)));
    }

    @Override
    public PersistentSet<E> addAll(Collection<? extends E> elements) {
        Intrinsics.checkNotNullParameter(elements, "elements");
        PersistentSet.Builder<E> builder = builder();
        builder.addAll(elements);
        return builder.build();
    }

    @Override
    public PersistentSet<E> remove(E element) {
        Links links = this.hashMap.get(element);
        if (links == null) {
            return this;
        }
        PersistentHashMap persistentHashMapRemove = this.hashMap.remove(element);
        if (links.getHasPrevious()) {
            V v = persistentHashMapRemove.get(links.getPrevious());
            Intrinsics.checkNotNull(v);
            persistentHashMapRemove = persistentHashMapRemove.put(links.getPrevious(), ((Links) v).withNext(links.getNext()));
        }
        if (links.getHasNext()) {
            V v2 = persistentHashMapRemove.get(links.getNext());
            Intrinsics.checkNotNull(v2);
            persistentHashMapRemove = persistentHashMapRemove.put(links.getNext(), ((Links) v2).withPrevious(links.getPrevious()));
        }
        return new PersistentOrderedSet(!links.getHasPrevious() ? links.getNext() : this.firstElement, !links.getHasNext() ? links.getPrevious() : this.lastElement, persistentHashMapRemove);
    }

    @Override
    public PersistentSet<E> removeAll(Collection<? extends E> elements) {
        Intrinsics.checkNotNullParameter(elements, "elements");
        PersistentSet.Builder<E> builder = builder();
        builder.removeAll(elements);
        return builder.build();
    }

    @Override
    public PersistentSet<E> removeAll(Function1<? super E, Boolean> predicate) {
        Intrinsics.checkNotNullParameter(predicate, "predicate");
        PersistentSet.Builder<E> builder = builder();
        CollectionsKt.removeAll(builder, predicate);
        return builder.build();
    }

    @Override
    public PersistentSet<E> retainAll(Collection<? extends E> elements) {
        Intrinsics.checkNotNullParameter(elements, "elements");
        PersistentSet.Builder<E> builder = builder();
        builder.retainAll(elements);
        return builder.build();
    }

    @Override
    public PersistentSet<E> clear() {
        return INSTANCE.emptyOf$kotlinx_collections_immutable();
    }

    @Override
    public Iterator<E> iterator() {
        return new PersistentOrderedSetIterator(this.firstElement, this.hashMap);
    }

    @Override
    public PersistentSet.Builder<E> builder() {
        return new PersistentOrderedSetBuilder(this);
    }

    @Override
    public boolean equals(Object other) {
        if (other == this) {
            return true;
        }
        if (!(other instanceof Set)) {
            return false;
        }
        Set set = (Set) other;
        if (size() != set.size()) {
            return false;
        }
        if (set instanceof PersistentOrderedSet) {
            return this.hashMap.getNode$kotlinx_collections_immutable().equalsWith$kotlinx_collections_immutable(((PersistentOrderedSet) other).hashMap.getNode$kotlinx_collections_immutable(), new Function2<Links, Links, Boolean>() {
                @Override
                public final Boolean invoke(Links noName_0, Links noName_1) {
                    Intrinsics.checkNotNullParameter(noName_0, "$noName_0");
                    Intrinsics.checkNotNullParameter(noName_1, "$noName_1");
                    return true;
                }
            });
        }
        if (set instanceof PersistentOrderedSetBuilder) {
            return this.hashMap.getNode$kotlinx_collections_immutable().equalsWith$kotlinx_collections_immutable(((PersistentOrderedSetBuilder) other).getHashMapBuilder$kotlinx_collections_immutable().getNode$kotlinx_collections_immutable(), new Function2<Links, Links, Boolean>() {
                @Override
                public final Boolean invoke(Links noName_0, Links noName_1) {
                    Intrinsics.checkNotNullParameter(noName_0, "$noName_0");
                    Intrinsics.checkNotNullParameter(noName_1, "$noName_1");
                    return true;
                }
            });
        }
        return super.equals(other);
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0001\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0019\u0010\u0006\u001a\b\u0012\u0004\u0012\u0002H\b0\u0007\"\u0004\b\u0001\u0010\bH\u0000¢\u0006\u0002\b\tR\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\n"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/persistentOrderedSet/PersistentOrderedSet$Companion;", "", "()V", "EMPTY", "Lkotlinx/collections/immutable/implementations/persistentOrderedSet/PersistentOrderedSet;", "", "emptyOf", "Lkotlinx/collections/immutable/PersistentSet;", "E", "emptyOf$kotlinx_collections_immutable", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final <E> PersistentSet<E> emptyOf$kotlinx_collections_immutable() {
            return PersistentOrderedSet.EMPTY;
        }
    }
}
