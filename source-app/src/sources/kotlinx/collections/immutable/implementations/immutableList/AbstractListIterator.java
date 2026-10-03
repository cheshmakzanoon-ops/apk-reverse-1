package kotlinx.collections.immutable.implementations.immutableList;

import java.util.ListIterator;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.jvm.internal.markers.KMappedMarker;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010*\n\u0000\n\u0002\u0010\b\n\u0002\b\t\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0004\b \u0018\u0000*\u0006\b\u0000\u0010\u0001 \u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B\u0015\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0004¢\u0006\u0002\u0010\u0006J\r\u0010\r\u001a\u00020\u000eH\u0000¢\u0006\u0002\b\u000fJ\r\u0010\u0010\u001a\u00020\u000eH\u0000¢\u0006\u0002\b\u0011J\t\u0010\u0012\u001a\u00020\u0013H\u0096\u0002J\b\u0010\u0014\u001a\u00020\u0013H\u0016J\b\u0010\u0015\u001a\u00020\u0004H\u0016J\b\u0010\u0016\u001a\u00020\u0004H\u0016R\u001a\u0010\u0003\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\u001a\u0010\u0005\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\b\"\u0004\b\f\u0010\n¨\u0006\u0017"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableList/AbstractListIterator;", "E", "", "index", "", "size", "(II)V", "getIndex", "()I", "setIndex", "(I)V", "getSize", "setSize", "checkHasNext", "", "checkHasNext$kotlinx_collections_immutable", "checkHasPrevious", "checkHasPrevious$kotlinx_collections_immutable", "hasNext", "", "hasPrevious", "nextIndex", "previousIndex", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public abstract class AbstractListIterator<E> implements ListIterator<E>, KMappedMarker {
    private int index;
    private int size;

    @Override
    public void add(E e) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public E next() {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public void remove() {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public void set(E e) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    public AbstractListIterator(int i, int i2) {
        this.index = i;
        this.size = i2;
    }

    public final int getIndex() {
        return this.index;
    }

    public final int getSize() {
        return this.size;
    }

    public final void setIndex(int i) {
        this.index = i;
    }

    public final void setSize(int i) {
        this.size = i;
    }

    @Override
    public boolean hasNext() {
        return this.index < this.size;
    }

    @Override
    public boolean hasPrevious() {
        return this.index > 0;
    }

    @Override
    public int nextIndex() {
        return this.index;
    }

    @Override
    public int previousIndex() {
        return this.index - 1;
    }

    public final void checkHasNext$kotlinx_collections_immutable() {
        if (!hasNext()) {
            throw new NoSuchElementException();
        }
    }

    public final void checkHasPrevious$kotlinx_collections_immutable() {
        if (!hasPrevious()) {
            throw new NoSuchElementException();
        }
    }
}
