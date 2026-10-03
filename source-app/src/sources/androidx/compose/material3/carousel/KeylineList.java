package androidx.compose.material3.carousel;

import j$.lang.Iterable;
import j$.util.Spliterator;
import j$.util.stream.Stream;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.NoSuchElementException;
import java.util.function.Consumer;
import java.util.function.IntFunction;
import java.util.function.Predicate;
import java.util.function.UnaryOperator;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.CollectionToArray;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.markers.KMappedMarker;
import kotlin.ranges.IntRange;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\u0015\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010\u001e\n\u0002\b\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0007\n\u0002\b\f\n\u0002\u0010(\n\u0002\b\u0003\n\u0002\u0010*\n\u0002\b\u0005\b\u0000\u0018\u0000 =2\b\u0012\u0004\u0012\u00020\u00020\u0001:\u0001=B\u0015\b\u0000\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001¢\u0006\u0002\u0010\u0004J\u0011\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020\u0002H\u0096\u0003J\u0017\u0010!\u001a\u00020\u001f2\f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\u00020#H\u0096\u0001J\u0013\u0010$\u001a\u00020\u001f2\b\u0010%\u001a\u0004\u0018\u00010&H\u0096\u0002J\u000e\u0010'\u001a\u00020\t2\u0006\u0010\u001c\u001a\u00020(J\u0011\u0010)\u001a\u00020\u00022\u0006\u0010*\u001a\u00020\tH\u0096\u0003J\u000e\u0010+\u001a\u00020\u00022\u0006\u0010,\u001a\u00020(J\u000e\u0010-\u001a\u00020\u00022\u0006\u0010,\u001a\u00020(J\b\u0010.\u001a\u00020\tH\u0016J\u0011\u0010/\u001a\u00020\t2\u0006\u0010 \u001a\u00020\u0002H\u0096\u0001J\t\u00100\u001a\u00020\u001fH\u0096\u0001J\u0006\u00101\u001a\u00020\u001fJ\u000e\u00102\u001a\u00020\u001f2\u0006\u00103\u001a\u00020(J\u000f\u00104\u001a\b\u0012\u0004\u0012\u00020\u000205H\u0096\u0003J\u000e\u00106\u001a\u00020\t2\u0006\u0010\u001c\u001a\u00020(J\u0011\u00107\u001a\u00020\t2\u0006\u0010 \u001a\u00020\u0002H\u0096\u0001J\u000f\u00108\u001a\b\u0012\u0004\u0012\u00020\u000209H\u0096\u0001J\u0017\u00108\u001a\b\u0012\u0004\u0012\u00020\u0002092\u0006\u0010*\u001a\u00020\tH\u0096\u0001J\u001f\u0010:\u001a\b\u0012\u0004\u0012\u00020\u00020\u00012\u0006\u0010;\u001a\u00020\t2\u0006\u0010<\u001a\u00020\tH\u0096\u0001R\u0011\u0010\u0005\u001a\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\f\u001a\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\r\u0010\u0007R\u0011\u0010\u000e\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000bR\u0011\u0010\u0010\u001a\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0011\u0010\u0007R\u0011\u0010\u0012\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000bR\u0011\u0010\u0014\u001a\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0015\u0010\u0007R\u0011\u0010\u0016\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u000bR\u0011\u0010\u0018\u001a\u00020\u00028F¢\u0006\u0006\u001a\u0004\b\u0019\u0010\u0007R\u0011\u0010\u001a\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u000bR\u0012\u0010\u001c\u001a\u00020\tX\u0096\u0005¢\u0006\u0006\u001a\u0004\b\u001d\u0010\u000b¨\u0006>"}, d2 = {"Landroidx/compose/material3/carousel/KeylineList;", "", "Landroidx/compose/material3/carousel/Keyline;", "keylines", "(Ljava/util/List;)V", "firstFocal", "getFirstFocal", "()Landroidx/compose/material3/carousel/Keyline;", "firstFocalIndex", "", "getFirstFocalIndex", "()I", "firstNonAnchor", "getFirstNonAnchor", "firstNonAnchorIndex", "getFirstNonAnchorIndex", "lastFocal", "getLastFocal", "lastFocalIndex", "getLastFocalIndex", "lastNonAnchor", "getLastNonAnchor", "lastNonAnchorIndex", "getLastNonAnchorIndex", "pivot", "getPivot", "pivotIndex", "getPivotIndex", "size", "getSize", "contains", "", "element", "containsAll", "elements", "", "equals", "other", "", "firstIndexAfterFocalRangeWithSize", "", "get", "index", "getKeylineAfter", "unadjustedOffset", "getKeylineBefore", "hashCode", "indexOf", "isEmpty", "isFirstFocalItemAtStartOfContainer", "isLastFocalItemAtEndOfContainer", "carouselMainAxisSize", "iterator", "", "lastIndexBeforeFocalRangeWithSize", "lastIndexOf", "listIterator", "", "subList", "fromIndex", "toIndex", "Companion", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class KeylineList implements List<Keyline>, KMappedMarker, j$.util.List {
    private final List<Keyline> $$delegate_0;
    private final int firstFocalIndex;
    private final int firstNonAnchorIndex;
    private final int lastFocalIndex;
    private final int lastNonAnchorIndex;
    private final int pivotIndex;

    public static final Companion INSTANCE = new Companion(null);
    public static final int $stable = 8;
    private static final KeylineList Empty = new KeylineList(CollectionsKt.emptyList());

    public void add2(int i, Keyline keyline) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public void add(int i, Keyline keyline) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    public boolean add(Keyline keyline) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public boolean add(Object obj) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public boolean addAll(int i, Collection<? extends Keyline> collection) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public boolean addAll(Collection<? extends Keyline> collection) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public void clear() {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    public boolean contains(Keyline element) {
        return this.$$delegate_0.contains(element);
    }

    @Override
    public boolean containsAll(Collection<? extends Object> elements) {
        return this.$$delegate_0.containsAll(elements);
    }

    @Override
    public void forEach(Consumer consumer) {
        Iterable.-CC.$default$forEach(this, consumer);
    }

    @Override
    public Keyline get(int index) {
        return this.$$delegate_0.get(index);
    }

    public int getSize() {
        return this.$$delegate_0.size();
    }

    public int indexOf(Keyline element) {
        return this.$$delegate_0.indexOf(element);
    }

    @Override
    public boolean isEmpty() {
        return this.$$delegate_0.isEmpty();
    }

    @Override
    public Iterator<Keyline> iterator() {
        return this.$$delegate_0.iterator();
    }

    public int lastIndexOf(Keyline element) {
        return this.$$delegate_0.lastIndexOf(element);
    }

    @Override
    public ListIterator<Keyline> listIterator() {
        return this.$$delegate_0.listIterator();
    }

    @Override
    public ListIterator<Keyline> listIterator(int index) {
        return this.$$delegate_0.listIterator(index);
    }

    @Override
    public Stream parallelStream() {
        return j$.util.Collection.-CC.$default$parallelStream(this);
    }

    @Override
    public java.util.stream.Stream parallelStream() {
        return Stream.Wrapper.convert(parallelStream());
    }

    @Override
    public Keyline remove(int i) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public Keyline remove(int i) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public boolean remove(Object obj) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public boolean removeAll(Collection<? extends Object> collection) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public boolean removeIf(Predicate predicate) {
        return j$.util.Collection.-CC.$default$removeIf(this, predicate);
    }

    @Override
    public void replaceAll(UnaryOperator<Keyline> unaryOperator) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public boolean retainAll(Collection<? extends Object> collection) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    public Keyline set2(int i, Keyline keyline) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public Keyline set(int i, Keyline keyline) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public void sort(Comparator<? super Keyline> comparator) {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    @Override
    public Spliterator spliterator() {
        return j$.util.List.-CC.$default$spliterator(this);
    }

    @Override
    public java.util.Spliterator spliterator() {
        return Spliterator.Wrapper.convert(spliterator());
    }

    @Override
    public Stream stream() {
        return j$.util.Collection.-CC.$default$stream(this);
    }

    @Override
    public java.util.stream.Stream stream() {
        return Stream.Wrapper.convert(stream());
    }

    @Override
    public List<Keyline> subList(int fromIndex, int toIndex) {
        return this.$$delegate_0.subList(fromIndex, toIndex);
    }

    @Override
    public Object[] toArray() {
        return CollectionToArray.toArray(this);
    }

    @Override
    public Object[] toArray(IntFunction intFunction) {
        return j$.util.Collection.-CC.$default$toArray(this, intFunction);
    }

    @Override
    public <T> T[] toArray(T[] tArr) {
        return (T[]) CollectionToArray.toArray(this, tArr);
    }

    public KeylineList(List<Keyline> list) {
        int iNextIndex;
        int iNextIndex2;
        this.$$delegate_0 = list;
        KeylineList keylineList = this;
        Iterator<Keyline> it = keylineList.iterator();
        int i = 0;
        int i2 = 0;
        while (true) {
            iNextIndex = -1;
            if (!it.hasNext()) {
                i2 = -1;
                break;
            } else if (it.next().isPivot()) {
                break;
            } else {
                i2++;
            }
        }
        this.pivotIndex = i2;
        Iterator<Keyline> it2 = keylineList.iterator();
        int i3 = 0;
        while (true) {
            if (!it2.hasNext()) {
                i3 = -1;
                break;
            } else if (!it2.next().isAnchor()) {
                break;
            } else {
                i3++;
            }
        }
        this.firstNonAnchorIndex = i3;
        ListIterator<Keyline> listIterator = keylineList.listIterator(keylineList.size());
        while (true) {
            if (!listIterator.hasPrevious()) {
                iNextIndex2 = -1;
                break;
            } else if (!listIterator.previous().isAnchor()) {
                iNextIndex2 = listIterator.nextIndex();
                break;
            }
        }
        this.lastNonAnchorIndex = iNextIndex2;
        Iterator<Keyline> it3 = keylineList.iterator();
        while (true) {
            if (!it3.hasNext()) {
                i = -1;
                break;
            } else if (it3.next().isFocal()) {
                break;
            } else {
                i++;
            }
        }
        this.firstFocalIndex = i;
        ListIterator<Keyline> listIterator2 = keylineList.listIterator(keylineList.size());
        while (listIterator2.hasPrevious()) {
            if (listIterator2.previous().isFocal()) {
                iNextIndex = listIterator2.nextIndex();
                break;
            }
        }
        this.lastFocalIndex = iNextIndex;
    }

    @Override
    public final boolean contains(Object obj) {
        if (obj instanceof Keyline) {
            return contains((Keyline) obj);
        }
        return false;
    }

    @Override
    public final int indexOf(Object obj) {
        if (obj instanceof Keyline) {
            return indexOf((Keyline) obj);
        }
        return -1;
    }

    @Override
    public final int lastIndexOf(Object obj) {
        if (obj instanceof Keyline) {
            return lastIndexOf((Keyline) obj);
        }
        return -1;
    }

    @Override
    public final int size() {
        return getSize();
    }

    public final int getPivotIndex() {
        return this.pivotIndex;
    }

    public final Keyline getPivot() {
        return get(this.pivotIndex);
    }

    public final int getFirstNonAnchorIndex() {
        return this.firstNonAnchorIndex;
    }

    public final Keyline getFirstNonAnchor() {
        return get(this.firstNonAnchorIndex);
    }

    public final int getLastNonAnchorIndex() {
        return this.lastNonAnchorIndex;
    }

    public final Keyline getLastNonAnchor() {
        return get(this.lastNonAnchorIndex);
    }

    public final int getFirstFocalIndex() {
        return this.firstFocalIndex;
    }

    public final Keyline getFirstFocal() {
        Keyline keyline = (Keyline) CollectionsKt.getOrNull(this, this.firstFocalIndex);
        if (keyline != null) {
            return keyline;
        }
        throw new NoSuchElementException("All KeylineLists must have at least one focal keyline");
    }

    public final int getLastFocalIndex() {
        return this.lastFocalIndex;
    }

    public final Keyline getLastFocal() {
        Keyline keyline = (Keyline) CollectionsKt.getOrNull(this, this.lastFocalIndex);
        if (keyline != null) {
            return keyline;
        }
        throw new NoSuchElementException("All KeylineLists must have at least one focal keyline");
    }

    public final boolean isFirstFocalItemAtStartOfContainer() {
        return getFirstFocal().getOffset() - (getFirstFocal().getSize() / ((float) 2)) >= 0.0f && Intrinsics.areEqual(getFirstFocal(), getFirstNonAnchor());
    }

    public final boolean isLastFocalItemAtEndOfContainer(float carouselMainAxisSize) {
        return getLastFocal().getOffset() + (getLastFocal().getSize() / ((float) 2)) <= carouselMainAxisSize && Intrinsics.areEqual(getLastFocal(), getLastNonAnchor());
    }

    public final int firstIndexAfterFocalRangeWithSize(float size) {
        Object next;
        KeylineList keylineList = this;
        Iterator it = new IntRange(this.lastFocalIndex, CollectionsKt.getLastIndex(keylineList)).iterator();
        do {
            if (!it.hasNext()) {
                next = null;
                break;
            }
            next = it.next();
        } while (get(((Number) next).intValue()).getSize() != size);
        Integer num = (Integer) next;
        return num != null ? num.intValue() : CollectionsKt.getLastIndex(keylineList);
    }

    public final int lastIndexBeforeFocalRangeWithSize(float size) {
        Object next;
        Iterator it = RangesKt.downTo(this.firstFocalIndex - 1, 0).iterator();
        do {
            if (!it.hasNext()) {
                next = null;
                break;
            }
            next = it.next();
        } while (get(((Number) next).intValue()).getSize() != size);
        Integer num = (Integer) next;
        if (num != null) {
            return num.intValue();
        }
        return 0;
    }

    public final Keyline getKeylineBefore(float unadjustedOffset) {
        int size = size() - 1;
        if (size >= 0) {
            while (true) {
                int i = size - 1;
                Keyline keyline = get(size);
                if (keyline.getUnadjustedOffset() < unadjustedOffset) {
                    return keyline;
                }
                if (i >= 0) {
                    size = i;
                }
            }
        }
        return (Keyline) CollectionsKt.first(this);
    }

    public final Keyline getKeylineAfter(float unadjustedOffset) {
        Keyline keyline;
        KeylineList keylineList = this;
        int size = keylineList.size();
        int i = 0;
        while (true) {
            if (i >= size) {
                keyline = null;
                break;
            }
            keyline = keylineList.get(i);
            if (keyline.getUnadjustedOffset() >= unadjustedOffset) {
                break;
            }
            i++;
        }
        Keyline keyline2 = keyline;
        return keyline2 == null ? (Keyline) CollectionsKt.last(keylineList) : keyline2;
    }

    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof KeylineList)) {
            return false;
        }
        KeylineList keylineList = (KeylineList) other;
        if (size() != keylineList.size()) {
            return false;
        }
        KeylineList keylineList2 = this;
        int size = keylineList2.size();
        for (int i = 0; i < size; i++) {
            if (!Intrinsics.areEqual(keylineList2.get(i), keylineList.get(i))) {
                return false;
            }
        }
        return true;
    }

    @Override
    public int hashCode() {
        KeylineList keylineList = this;
        int size = keylineList.size();
        int iHashCode = 0;
        for (int i = 0; i < size; i++) {
            iHashCode += keylineList.get(i).hashCode() * 31;
        }
        return iHashCode;
    }

    @Metadata(d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0007"}, d2 = {"Landroidx/compose/material3/carousel/KeylineList$Companion;", "", "()V", "Empty", "Landroidx/compose/material3/carousel/KeylineList;", "getEmpty", "()Landroidx/compose/material3/carousel/KeylineList;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KeylineList getEmpty() {
            return KeylineList.Empty;
        }
    }
}
