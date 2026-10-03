package com.google.common.collect;

import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
final class DescendingImmutableSortedSet<E> extends ImmutableSortedSet<E> {
    private final ImmutableSortedSet<E> forward;

    DescendingImmutableSortedSet(ImmutableSortedSet<E> immutableSortedSet) {
        super(Ordering.from(immutableSortedSet.comparator()).reverse());
        this.forward = immutableSortedSet;
    }

    @Override
    public boolean contains(@CheckForNull Object obj) {
        return this.forward.contains(obj);
    }

    @Override
    public int size() {
        return this.forward.size();
    }

    @Override
    public UnmodifiableIterator<E> iterator() {
        return this.forward.descendingIterator();
    }

    @Override
    ImmutableSortedSet<E> headSetImpl(E e, boolean z) {
        return this.forward.tailSet((Object) e, z).descendingSet();
    }

    @Override
    ImmutableSortedSet<E> subSetImpl(E e, boolean z, E e2, boolean z2) {
        return this.forward.subSet((Object) e2, z2, (Object) e, z).descendingSet();
    }

    @Override
    ImmutableSortedSet<E> tailSetImpl(E e, boolean z) {
        return this.forward.headSet((Object) e, z).descendingSet();
    }

    @Override
    public ImmutableSortedSet<E> descendingSet() {
        return this.forward;
    }

    @Override
    public UnmodifiableIterator<E> descendingIterator() {
        return this.forward.iterator();
    }

    @Override
    ImmutableSortedSet<E> createDescendingSet() {
        throw new AssertionError("should never be called");
    }

    @Override
    @CheckForNull
    public E lower(E e) {
        return this.forward.higher(e);
    }

    @Override
    @CheckForNull
    public E floor(E e) {
        return this.forward.ceiling(e);
    }

    @Override
    @CheckForNull
    public E ceiling(E e) {
        return this.forward.floor(e);
    }

    @Override
    @CheckForNull
    public E higher(E e) {
        return this.forward.lower(e);
    }

    @Override
    int indexOf(@CheckForNull Object obj) {
        int iIndexOf = this.forward.indexOf(obj);
        return iIndexOf == -1 ? iIndexOf : (size() - 1) - iIndexOf;
    }

    @Override
    boolean isPartialView() {
        return this.forward.isPartialView();
    }
}
