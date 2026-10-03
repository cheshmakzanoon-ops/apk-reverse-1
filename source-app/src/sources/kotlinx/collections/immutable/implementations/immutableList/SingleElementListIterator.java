package kotlinx.collections.immutable.implementations.immutableList;

import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0006\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B\u0015\u0012\u0006\u0010\u0003\u001a\u00028\u0000\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\b\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010\tJ\r\u0010\n\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\tR\u0010\u0010\u0003\u001a\u00028\u0000X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0007¨\u0006\u000b"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableList/SingleElementListIterator;", "E", "Lkotlinx/collections/immutable/implementations/immutableList/AbstractListIterator;", "element", "index", "", "(Ljava/lang/Object;I)V", "Ljava/lang/Object;", "next", "()Ljava/lang/Object;", "previous", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class SingleElementListIterator<E> extends AbstractListIterator<E> {
    private final E element;

    public SingleElementListIterator(E e, int i) {
        super(i, 1);
        this.element = e;
    }

    @Override
    public E next() {
        checkHasNext$kotlinx_collections_immutable();
        setIndex(getIndex() + 1);
        return this.element;
    }

    @Override
    public E previous() {
        checkHasPrevious$kotlinx_collections_immutable();
        setIndex(getIndex() - 1);
        return this.element;
    }
}
