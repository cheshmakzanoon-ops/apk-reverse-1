package kotlinx.collections.immutable.implementations.immutableSet;

import java.util.Collection;
import java.util.Iterator;
import kotlin.Metadata;
import kotlin.collections.AbstractMutableSet;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.PersistentSet;
import kotlinx.collections.immutable.internal.DeltaCounter;
import kotlinx.collections.immutable.internal.MutabilityOwnership;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u001e\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0010)\n\u0002\b\u0004\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003B\u0013\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005¢\u0006\u0002\u0010\u0006J\u0015\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u001cJ\u0016\u0010\u001d\u001a\u00020\u001a2\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00028\u00000\u001fH\u0016J\u000e\u0010 \u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0016J\b\u0010!\u001a\u00020\"H\u0016J\u0016\u0010#\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010\u001cJ\u0016\u0010$\u001a\u00020\u001a2\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00028\u00000\u001fH\u0016J\u000f\u0010%\u001a\b\u0012\u0004\u0012\u00028\u00000&H\u0096\u0002J\u0015\u0010'\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u001cJ\u0016\u0010(\u001a\u00020\u001a2\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00028\u00000\u001fH\u0016J\u0016\u0010)\u001a\u00020\u001a2\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00028\u00000\u001fH\u0016R\u001e\u0010\t\u001a\u00020\b2\u0006\u0010\u0007\u001a\u00020\b@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR*\u0010\r\u001a\b\u0012\u0004\u0012\u00028\u00000\f2\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00000\f@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u001e\u0010\u0011\u001a\u00020\u00102\u0006\u0010\u0007\u001a\u00020\u0010@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0014\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R$\u0010\u0015\u001a\u00020\b2\u0006\u0010\u0014\u001a\u00020\b@VX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u000b\"\u0004\b\u0017\u0010\u0018¨\u0006*"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableSet/PersistentHashSetBuilder;", "E", "Lkotlin/collections/AbstractMutableSet;", "Lkotlinx/collections/immutable/PersistentSet$Builder;", "set", "Lkotlinx/collections/immutable/implementations/immutableSet/PersistentHashSet;", "(Lkotlinx/collections/immutable/implementations/immutableSet/PersistentHashSet;)V", "<set-?>", "", "modCount", "getModCount$kotlinx_collections_immutable", "()I", "Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "node", "getNode$kotlinx_collections_immutable", "()Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "Lkotlinx/collections/immutable/internal/MutabilityOwnership;", "ownership", "getOwnership$kotlinx_collections_immutable", "()Lkotlinx/collections/immutable/internal/MutabilityOwnership;", "value", "size", "getSize", "setSize", "(I)V", "add", "", "element", "(Ljava/lang/Object;)Z", "addAll", "elements", "", "build", "clear", "", "contains", "containsAll", "iterator", "", "remove", "removeAll", "retainAll", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class PersistentHashSetBuilder<E> extends AbstractMutableSet<E> implements PersistentSet.Builder<E> {
    private int modCount;
    private TrieNode<E> node;
    private MutabilityOwnership ownership;
    private PersistentHashSet<E> set;
    private int size;

    public PersistentHashSetBuilder(PersistentHashSet<E> set) {
        Intrinsics.checkNotNullParameter(set, "set");
        this.set = set;
        this.ownership = new MutabilityOwnership();
        this.node = this.set.getNode$kotlinx_collections_immutable();
        this.size = this.set.size();
    }

    public final MutabilityOwnership getOwnership() {
        return this.ownership;
    }

    public final TrieNode<E> getNode$kotlinx_collections_immutable() {
        return this.node;
    }

    public final int getModCount() {
        return this.modCount;
    }

    @Override
    public int getSize() {
        return this.size;
    }

    public void setSize(int i) {
        this.size = i;
        this.modCount++;
    }

    @Override
    public PersistentHashSet<E> build() {
        PersistentHashSet<E> persistentHashSet;
        if (this.node == this.set.getNode$kotlinx_collections_immutable()) {
            persistentHashSet = this.set;
        } else {
            this.ownership = new MutabilityOwnership();
            persistentHashSet = new PersistentHashSet<>(this.node, size());
        }
        this.set = persistentHashSet;
        return persistentHashSet;
    }

    @Override
    public boolean contains(Object element) {
        return this.node.contains(element == null ? 0 : element.hashCode(), element, 0);
    }

    @Override
    public boolean add(E element) {
        int size = size();
        this.node = this.node.mutableAdd(element == null ? 0 : element.hashCode(), element, 0, this);
        return size != size();
    }

    @Override
    public boolean addAll(Collection<? extends E> elements) {
        Intrinsics.checkNotNullParameter(elements, "elements");
        PersistentHashSet<E> persistentHashSetBuild = elements instanceof PersistentHashSet ? (PersistentHashSet) elements : null;
        if (persistentHashSetBuild == null) {
            PersistentHashSetBuilder persistentHashSetBuilder = elements instanceof PersistentHashSetBuilder ? (PersistentHashSetBuilder) elements : null;
            persistentHashSetBuild = persistentHashSetBuilder == null ? null : persistentHashSetBuilder.build();
        }
        if (persistentHashSetBuild != null) {
            DeltaCounter deltaCounter = new DeltaCounter(0, 1, null);
            int size = size();
            TrieNode<E> trieNodeMutableAddAll = this.node.mutableAddAll(persistentHashSetBuild.getNode$kotlinx_collections_immutable(), 0, deltaCounter, this);
            int size2 = (elements.size() + size) - deltaCounter.getCount();
            if (size != size2) {
                this.node = trieNodeMutableAddAll;
                setSize(size2);
            }
            return size != size();
        }
        return super.addAll(elements);
    }

    @Override
    public boolean retainAll(Collection<? extends Object> elements) {
        Intrinsics.checkNotNullParameter(elements, "elements");
        PersistentHashSet<E> persistentHashSetBuild = elements instanceof PersistentHashSet ? (PersistentHashSet) elements : null;
        if (persistentHashSetBuild == null) {
            PersistentHashSetBuilder persistentHashSetBuilder = elements instanceof PersistentHashSetBuilder ? (PersistentHashSetBuilder) elements : null;
            persistentHashSetBuild = persistentHashSetBuilder == null ? null : persistentHashSetBuilder.build();
        }
        if (persistentHashSetBuild != null) {
            DeltaCounter deltaCounter = new DeltaCounter(0, 1, null);
            int size = size();
            Object objMutableRetainAll = this.node.mutableRetainAll(persistentHashSetBuild.getNode$kotlinx_collections_immutable(), 0, deltaCounter, this);
            int count = deltaCounter.getCount();
            if (count == 0) {
                clear();
            } else if (count != size) {
                if (objMutableRetainAll != null) {
                    this.node = (TrieNode) objMutableRetainAll;
                    setSize(count);
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.PersistentHashSetBuilder>");
                }
            }
            return size != size();
        }
        return super.retainAll(elements);
    }

    @Override
    public boolean removeAll(Collection<? extends Object> elements) {
        Intrinsics.checkNotNullParameter(elements, "elements");
        PersistentHashSet<E> persistentHashSetBuild = elements instanceof PersistentHashSet ? (PersistentHashSet) elements : null;
        if (persistentHashSetBuild == null) {
            PersistentHashSetBuilder persistentHashSetBuilder = elements instanceof PersistentHashSetBuilder ? (PersistentHashSetBuilder) elements : null;
            persistentHashSetBuild = persistentHashSetBuilder == null ? null : persistentHashSetBuilder.build();
        }
        if (persistentHashSetBuild != null) {
            DeltaCounter deltaCounter = new DeltaCounter(0, 1, null);
            int size = size();
            Object objMutableRemoveAll = this.node.mutableRemoveAll(persistentHashSetBuild.getNode$kotlinx_collections_immutable(), 0, deltaCounter, this);
            int count = size - deltaCounter.getCount();
            if (count == 0) {
                clear();
            } else if (count != size) {
                if (objMutableRemoveAll != null) {
                    this.node = (TrieNode) objMutableRemoveAll;
                    setSize(count);
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.PersistentHashSetBuilder>");
                }
            }
            return size != size();
        }
        return super.removeAll(elements);
    }

    @Override
    public boolean containsAll(Collection<? extends Object> elements) {
        Intrinsics.checkNotNullParameter(elements, "elements");
        if (elements instanceof PersistentHashSet) {
            return this.node.containsAll(((PersistentHashSet) elements).getNode$kotlinx_collections_immutable(), 0);
        }
        if (elements instanceof PersistentHashSetBuilder) {
            return this.node.containsAll(((PersistentHashSetBuilder) elements).node, 0);
        }
        return super.containsAll(elements);
    }

    @Override
    public boolean remove(Object element) {
        int size = size();
        this.node = this.node.mutableRemove(element == null ? 0 : element.hashCode(), element, 0, this);
        return size != size();
    }

    @Override
    public void clear() {
        this.node = TrieNode.INSTANCE.getEMPTY$kotlinx_collections_immutable();
        setSize(0);
    }

    @Override
    public Iterator<E> iterator() {
        return new PersistentHashSetMutableIterator(this);
    }
}
