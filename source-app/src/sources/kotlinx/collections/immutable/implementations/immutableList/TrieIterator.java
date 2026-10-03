package kotlinx.collections.immutable.implementations.immutableList;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\b\b\u0000\u0018\u0000*\u0006\b\u0000\u0010\u0001 \u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B-\u0012\u000e\u0010\u0003\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0004\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\u0006\u0010\t\u001a\u00020\u0007¢\u0006\u0002\u0010\nJ\r\u0010\u000f\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010\u0010J\u0018\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\u0013\u001a\u00020\u0007H\u0002J\u0010\u0010\u0014\u001a\u00020\u00122\u0006\u0010\u0015\u001a\u00020\u0007H\u0002J\u000e\u0010\u0016\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010\u0010J\r\u0010\u0017\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u0010J7\u0010\u0018\u001a\u00020\u00122\u000e\u0010\u0003\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u00042\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u00072\u0006\u0010\t\u001a\u00020\u0007H\u0000¢\u0006\u0004\b\u0019\u0010\nR\u000e\u0010\t\u001a\u00020\u0007X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010\r\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0004X\u0082\u000e¢\u0006\u0004\n\u0002\u0010\u000e¨\u0006\u001a"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableList/TrieIterator;", "E", "Lkotlinx/collections/immutable/implementations/immutableList/AbstractListIterator;", "root", "", "", "index", "", "size", "height", "([Ljava/lang/Object;III)V", "isInRightEdge", "", ClientCookie.PATH_ATTR, "[Ljava/lang/Object;", "elementAtCurrentIndex", "()Ljava/lang/Object;", "fillPath", "", "startLevel", "fillPathIfNeeded", "indexPredicate", "next", "previous", "reset", "reset$kotlinx_collections_immutable", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class TrieIterator<E> extends AbstractListIterator<E> {
    private int height;
    private boolean isInRightEdge;
    private Object[] path;

    public TrieIterator(Object[] root, int i, int i2, int i3) {
        super(i, i2);
        Intrinsics.checkNotNullParameter(root, "root");
        this.height = i3;
        Object[] objArr = new Object[i3];
        this.path = objArr;
        ?? r5 = i == i2 ? 1 : 0;
        this.isInRightEdge = r5;
        objArr[0] = root;
        fillPath(i - r5, 1);
    }

    public final void reset$kotlinx_collections_immutable(Object[] root, int index, int size, int height) {
        Intrinsics.checkNotNullParameter(root, "root");
        setIndex(index);
        setSize(size);
        this.height = height;
        if (this.path.length < height) {
            this.path = new Object[height];
        }
        this.path[0] = root;
        ?? r0 = index == size ? 1 : 0;
        this.isInRightEdge = r0;
        fillPath(index - r0, 1);
    }

    private final void fillPath(int index, int startLevel) {
        int i = (this.height - startLevel) * 5;
        while (startLevel < this.height) {
            Object[] objArr = this.path;
            Object obj = objArr[startLevel - 1];
            if (obj == null) {
                throw new NullPointerException("null cannot be cast to non-null type kotlin.Array<kotlin.Any?>");
            }
            objArr[startLevel] = ((Object[]) obj)[UtilsKt.indexSegment(index, i)];
            i -= 5;
            startLevel++;
        }
    }

    private final void fillPathIfNeeded(int indexPredicate) {
        int i = 0;
        while (UtilsKt.indexSegment(getIndex(), i) == indexPredicate) {
            i += 5;
        }
        if (i > 0) {
            fillPath(getIndex(), ((this.height - 1) - (i / 5)) + 1);
        }
    }

    private final E elementAtCurrentIndex() {
        int index = getIndex() & 31;
        Object obj = this.path[this.height - 1];
        if (obj != null) {
            return (E) ((Object[]) obj)[index];
        }
        throw new NullPointerException("null cannot be cast to non-null type kotlin.Array<E of kotlinx.collections.immutable.implementations.immutableList.TrieIterator>");
    }

    @Override
    public E next() {
        if (!hasNext()) {
            throw new NoSuchElementException();
        }
        E eElementAtCurrentIndex = elementAtCurrentIndex();
        setIndex(getIndex() + 1);
        if (getIndex() == getSize()) {
            this.isInRightEdge = true;
            return eElementAtCurrentIndex;
        }
        fillPathIfNeeded(0);
        return eElementAtCurrentIndex;
    }

    @Override
    public E previous() {
        if (!hasPrevious()) {
            throw new NoSuchElementException();
        }
        setIndex(getIndex() - 1);
        if (this.isInRightEdge) {
            this.isInRightEdge = false;
            return elementAtCurrentIndex();
        }
        fillPathIfNeeded(31);
        return elementAtCurrentIndex();
    }
}
