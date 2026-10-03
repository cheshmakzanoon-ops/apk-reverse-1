package kotlinx.collections.immutable.implementations.persistentOrderedSet;

import java.util.Iterator;
import java.util.Set;
import kotlin.Metadata;
import kotlin.collections.AbstractMutableSet;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.PersistentSet;
import kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMap;
import kotlinx.collections.immutable.implementations.immutableMap.PersistentHashMapBuilder;
import kotlinx.collections.immutable.internal.CommonFunctionsKt;
import kotlinx.collections.immutable.internal.EndOfChain;

@Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0010)\n\u0002\b\u0002\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003B\u0013\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005¢\u0006\u0002\u0010\u0006J\u0015\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u001aJ\u000e\u0010\u001b\u001a\b\u0012\u0004\u0012\u00028\u00000\u001cH\u0016J\b\u0010\u001d\u001a\u00020\u001eH\u0016J\u0016\u0010\u001f\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010\u001aJ\u0013\u0010 \u001a\u00020\u00182\b\u0010!\u001a\u0004\u0018\u00010\bH\u0096\u0002J\b\u0010\"\u001a\u00020\u0014H\u0016J\u000f\u0010#\u001a\b\u0012\u0004\u0012\u00028\u00000$H\u0096\u0002J\u0015\u0010%\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u001aR\u001c\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR \u0010\r\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00020\u000f0\u000eX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0010\u0010\u0012\u001a\u0004\u0018\u00010\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u0014\u0010\u0013\u001a\u00020\u00148VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0016¨\u0006&"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/persistentOrderedSet/PersistentOrderedSetBuilder;", "E", "Lkotlin/collections/AbstractMutableSet;", "Lkotlinx/collections/immutable/PersistentSet$Builder;", "set", "Lkotlinx/collections/immutable/implementations/persistentOrderedSet/PersistentOrderedSet;", "(Lkotlinx/collections/immutable/implementations/persistentOrderedSet/PersistentOrderedSet;)V", "firstElement", "", "getFirstElement$kotlinx_collections_immutable", "()Ljava/lang/Object;", "setFirstElement$kotlinx_collections_immutable", "(Ljava/lang/Object;)V", "hashMapBuilder", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;", "Lkotlinx/collections/immutable/implementations/persistentOrderedSet/Links;", "getHashMapBuilder$kotlinx_collections_immutable", "()Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;", "lastElement", "size", "", "getSize", "()I", "add", "", "element", "(Ljava/lang/Object;)Z", "build", "Lkotlinx/collections/immutable/PersistentSet;", "clear", "", "contains", "equals", "other", "hashCode", "iterator", "", "remove", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class PersistentOrderedSetBuilder<E> extends AbstractMutableSet<E> implements PersistentSet.Builder<E> {
    private Object firstElement;
    private final PersistentHashMapBuilder<E, Links> hashMapBuilder;
    private Object lastElement;
    private PersistentOrderedSet<E> set;

    public PersistentOrderedSetBuilder(PersistentOrderedSet<E> set) {
        Intrinsics.checkNotNullParameter(set, "set");
        this.set = set;
        this.firstElement = set.getFirstElement();
        this.lastElement = this.set.getLastElement();
        this.hashMapBuilder = this.set.getHashMap$kotlinx_collections_immutable().builder();
    }

    public final Object getFirstElement() {
        return this.firstElement;
    }

    public final void setFirstElement$kotlinx_collections_immutable(Object obj) {
        this.firstElement = obj;
    }

    public final PersistentHashMapBuilder<E, Links> getHashMapBuilder$kotlinx_collections_immutable() {
        return this.hashMapBuilder;
    }

    @Override
    public int getSize() {
        return this.hashMapBuilder.size();
    }

    @Override
    public PersistentSet<E> build() {
        PersistentOrderedSet<E> persistentOrderedSet;
        PersistentHashMap<E, Links> persistentHashMapBuild = this.hashMapBuilder.build();
        if (persistentHashMapBuild == this.set.getHashMap$kotlinx_collections_immutable()) {
            CommonFunctionsKt.m1793assert(this.firstElement == this.set.getFirstElement());
            CommonFunctionsKt.m1793assert(this.lastElement == this.set.getLastElement());
            persistentOrderedSet = this.set;
        } else {
            persistentOrderedSet = new PersistentOrderedSet<>(this.firstElement, this.lastElement, persistentHashMapBuild);
        }
        this.set = persistentOrderedSet;
        return persistentOrderedSet;
    }

    @Override
    public boolean contains(Object element) {
        return this.hashMapBuilder.containsKey(element);
    }

    @Override
    public boolean add(E element) {
        if (this.hashMapBuilder.containsKey(element)) {
            return false;
        }
        if (isEmpty()) {
            this.firstElement = element;
            this.lastElement = element;
            this.hashMapBuilder.put(element, new Links());
            return true;
        }
        Links links = this.hashMapBuilder.get(this.lastElement);
        Intrinsics.checkNotNull(links);
        this.hashMapBuilder.put(this.lastElement, links.withNext(element));
        this.hashMapBuilder.put(element, new Links(this.lastElement));
        this.lastElement = element;
        return true;
    }

    @Override
    public boolean remove(Object element) {
        Links linksRemove = this.hashMapBuilder.remove(element);
        if (linksRemove == null) {
            return false;
        }
        if (linksRemove.getHasPrevious()) {
            Links links = this.hashMapBuilder.get(linksRemove.getPrevious());
            Intrinsics.checkNotNull(links);
            this.hashMapBuilder.put(linksRemove.getPrevious(), links.withNext(linksRemove.getNext()));
        } else {
            this.firstElement = linksRemove.getNext();
        }
        if (linksRemove.getHasNext()) {
            Links links2 = this.hashMapBuilder.get(linksRemove.getNext());
            Intrinsics.checkNotNull(links2);
            this.hashMapBuilder.put(linksRemove.getNext(), links2.withPrevious(linksRemove.getPrevious()));
            return true;
        }
        this.lastElement = linksRemove.getPrevious();
        return true;
    }

    @Override
    public void clear() {
        this.hashMapBuilder.clear();
        this.firstElement = EndOfChain.INSTANCE;
        this.lastElement = EndOfChain.INSTANCE;
    }

    @Override
    public Iterator<E> iterator() {
        return new PersistentOrderedSetMutableIterator(this);
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
            return this.hashMapBuilder.getNode$kotlinx_collections_immutable().equalsWith$kotlinx_collections_immutable(((PersistentOrderedSet) other).getHashMap$kotlinx_collections_immutable().getNode$kotlinx_collections_immutable(), new Function2<Links, Links, Boolean>() {
                @Override
                public final Boolean invoke(Links noName_0, Links noName_1) {
                    Intrinsics.checkNotNullParameter(noName_0, "$noName_0");
                    Intrinsics.checkNotNullParameter(noName_1, "$noName_1");
                    return true;
                }
            });
        }
        if (set instanceof PersistentOrderedSetBuilder) {
            return this.hashMapBuilder.getNode$kotlinx_collections_immutable().equalsWith$kotlinx_collections_immutable(((PersistentOrderedSetBuilder) other).hashMapBuilder.getNode$kotlinx_collections_immutable(), new Function2<Links, Links, Boolean>() {
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
}
