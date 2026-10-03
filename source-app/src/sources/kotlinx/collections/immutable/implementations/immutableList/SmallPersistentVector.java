package kotlinx.collections.immutable.implementations.immutableList;

import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.ListIterator;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.ImmutableList;
import kotlinx.collections.immutable.PersistentList;
import kotlinx.collections.immutable.internal.CommonFunctionsKt;
import kotlinx.collections.immutable.internal.ListImplementation;

@Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u001e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010*\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0004\b\u0000\u0018\u0000 (*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003:\u0001(B\u0015\u0012\u000e\u0010\u0004\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00060\u0005¢\u0006\u0002\u0010\u0007J\u001b\u0010\r\u001a\b\u0012\u0004\u0012\u00028\u00000\u000e2\u0006\u0010\u000f\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u0010J#\u0010\r\u001a\b\u0012\u0004\u0012\u00028\u00000\u000e2\u0006\u0010\u0011\u001a\u00020\n2\u0006\u0010\u000f\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u0012J$\u0010\u0013\u001a\b\u0012\u0004\u0012\u00028\u00000\u000e2\u0006\u0010\u0011\u001a\u00020\n2\f\u0010\u0014\u001a\b\u0012\u0004\u0012\u00028\u00000\u0015H\u0016J\u001c\u0010\u0013\u001a\b\u0012\u0004\u0012\u00028\u00000\u000e2\f\u0010\u0016\u001a\b\u0012\u0004\u0012\u00028\u00000\u0015H\u0016J\u001d\u0010\u0017\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00060\u00052\u0006\u0010\t\u001a\u00020\nH\u0002¢\u0006\u0002\u0010\u0018J\u000e\u0010\u0019\u001a\b\u0012\u0004\u0012\u00028\u00000\u001aH\u0016J\u0016\u0010\u001b\u001a\u00028\u00002\u0006\u0010\u0011\u001a\u00020\nH\u0096\u0002¢\u0006\u0002\u0010\u001cJ\u0015\u0010\u001d\u001a\u00020\n2\u0006\u0010\u000f\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u001eJ\u0015\u0010\u001f\u001a\u00020\n2\u0006\u0010\u000f\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u001eJ\u0016\u0010 \u001a\b\u0012\u0004\u0012\u00028\u00000!2\u0006\u0010\u0011\u001a\u00020\nH\u0016J\"\u0010\"\u001a\b\u0012\u0004\u0012\u00028\u00000\u000e2\u0012\u0010#\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00020%0$H\u0016J\u0016\u0010&\u001a\b\u0012\u0004\u0012\u00028\u00000\u000e2\u0006\u0010\u0011\u001a\u00020\nH\u0016J#\u0010'\u001a\b\u0012\u0004\u0012\u00028\u00000\u000e2\u0006\u0010\u0011\u001a\u00020\n2\u0006\u0010\u000f\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u0012R\u0018\u0010\u0004\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00060\u0005X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\bR\u0014\u0010\t\u001a\u00020\n8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u000b\u0010\f¨\u0006)"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableList/SmallPersistentVector;", "E", "Lkotlinx/collections/immutable/ImmutableList;", "Lkotlinx/collections/immutable/implementations/immutableList/AbstractPersistentList;", "buffer", "", "", "([Ljava/lang/Object;)V", "[Ljava/lang/Object;", "size", "", "getSize", "()I", "add", "Lkotlinx/collections/immutable/PersistentList;", "element", "(Ljava/lang/Object;)Lkotlinx/collections/immutable/PersistentList;", "index", "(ILjava/lang/Object;)Lkotlinx/collections/immutable/PersistentList;", "addAll", "c", "", "elements", "bufferOfSize", "(I)[Ljava/lang/Object;", "builder", "Lkotlinx/collections/immutable/PersistentList$Builder;", "get", "(I)Ljava/lang/Object;", "indexOf", "(Ljava/lang/Object;)I", "lastIndexOf", "listIterator", "", "removeAll", "predicate", "Lkotlin/Function1;", "", "removeAt", "set", "Companion", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class SmallPersistentVector<E> extends AbstractPersistentList<E> implements ImmutableList<E> {

    public static final Companion INSTANCE = new Companion(null);
    private static final SmallPersistentVector EMPTY = new SmallPersistentVector(new Object[0]);
    private final Object[] buffer;

    public SmallPersistentVector(Object[] buffer) {
        Intrinsics.checkNotNullParameter(buffer, "buffer");
        this.buffer = buffer;
        CommonFunctionsKt.m1793assert(buffer.length <= 32);
    }

    @Override
    public int getSize() {
        return this.buffer.length;
    }

    private final Object[] bufferOfSize(int size) {
        return new Object[size];
    }

    @Override
    public PersistentList<E> add(E element) {
        if (size() < 32) {
            Object[] objArrCopyOf = Arrays.copyOf(this.buffer, size() + 1);
            Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
            objArrCopyOf[size()] = element;
            return new SmallPersistentVector(objArrCopyOf);
        }
        return new PersistentVector(this.buffer, UtilsKt.presizedBufferWith(element), size() + 1, 0);
    }

    @Override
    public PersistentList<E> addAll(Collection<? extends E> elements) {
        Intrinsics.checkNotNullParameter(elements, "elements");
        if (size() + elements.size() <= 32) {
            Object[] objArrCopyOf = Arrays.copyOf(this.buffer, size() + elements.size());
            Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
            int size = size();
            Iterator<? extends E> it = elements.iterator();
            while (it.hasNext()) {
                objArrCopyOf[size] = it.next();
                size++;
            }
            return new SmallPersistentVector(objArrCopyOf);
        }
        PersistentList.Builder<E> builder = builder();
        builder.addAll(elements);
        return builder.build();
    }

    @Override
    public PersistentList<E> removeAll(Function1<? super E, Boolean> predicate) {
        Intrinsics.checkNotNullParameter(predicate, "predicate");
        Object[] objArrCopyOf = this.buffer;
        int size = size();
        int size2 = size();
        int i = size;
        int i2 = 0;
        boolean z = false;
        while (i2 < size2) {
            int i3 = i2 + 1;
            Object obj = this.buffer[i2];
            if (predicate.invoke(obj).booleanValue()) {
                if (!z) {
                    Object[] objArr = this.buffer;
                    objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
                    Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
                    z = true;
                    i = i2;
                }
            } else if (z) {
                i2 = i + 1;
                objArrCopyOf[i] = obj;
                i = i2;
            }
            i2 = i3;
        }
        if (i == size()) {
            return this;
        }
        if (i == 0) {
            return EMPTY;
        }
        return new SmallPersistentVector(ArraysKt.copyOfRange(objArrCopyOf, 0, i));
    }

    @Override
    public PersistentList<E> addAll(int index, Collection<? extends E> c) {
        Intrinsics.checkNotNullParameter(c, "c");
        ListImplementation.checkPositionIndex$kotlinx_collections_immutable(index, size());
        if (size() + c.size() <= 32) {
            Object[] objArrBufferOfSize = bufferOfSize(size() + c.size());
            ArraysKt.copyInto$default(this.buffer, objArrBufferOfSize, 0, 0, index, 6, (Object) null);
            ArraysKt.copyInto(this.buffer, objArrBufferOfSize, c.size() + index, index, size());
            Iterator<? extends E> it = c.iterator();
            while (it.hasNext()) {
                objArrBufferOfSize[index] = it.next();
                index++;
            }
            return new SmallPersistentVector(objArrBufferOfSize);
        }
        PersistentList.Builder<E> builder = builder();
        builder.addAll(index, c);
        return builder.build();
    }

    @Override
    public PersistentList<E> add(int index, E element) {
        ListImplementation.checkPositionIndex$kotlinx_collections_immutable(index, size());
        if (index == size()) {
            return add((Object) element);
        }
        if (size() < 32) {
            Object[] objArrBufferOfSize = bufferOfSize(size() + 1);
            ArraysKt.copyInto$default(this.buffer, objArrBufferOfSize, 0, 0, index, 6, (Object) null);
            ArraysKt.copyInto(this.buffer, objArrBufferOfSize, index + 1, index, size());
            objArrBufferOfSize[index] = element;
            return new SmallPersistentVector(objArrBufferOfSize);
        }
        Object[] objArr = this.buffer;
        Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
        ArraysKt.copyInto(this.buffer, objArrCopyOf, index + 1, index, size() - 1);
        objArrCopyOf[index] = element;
        return new PersistentVector(objArrCopyOf, UtilsKt.presizedBufferWith(this.buffer[31]), size() + 1, 0);
    }

    @Override
    public PersistentList<E> removeAt(int index) {
        ListImplementation.checkElementIndex$kotlinx_collections_immutable(index, size());
        if (size() == 1) {
            return EMPTY;
        }
        Object[] objArrCopyOf = Arrays.copyOf(this.buffer, size() - 1);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
        ArraysKt.copyInto(this.buffer, objArrCopyOf, index, index + 1, size());
        return new SmallPersistentVector(objArrCopyOf);
    }

    @Override
    public PersistentList.Builder<E> builder() {
        return new PersistentVectorBuilder(this, null, this.buffer, 0);
    }

    @Override
    public int indexOf(Object element) {
        return ArraysKt.indexOf(this.buffer, element);
    }

    @Override
    public int lastIndexOf(Object element) {
        return ArraysKt.lastIndexOf(this.buffer, element);
    }

    @Override
    public ListIterator<E> listIterator(int index) {
        ListImplementation.checkPositionIndex$kotlinx_collections_immutable(index, size());
        return new BufferIterator(this.buffer, index, size());
    }

    @Override
    public E get(int index) {
        ListImplementation.checkElementIndex$kotlinx_collections_immutable(index, size());
        return (E) this.buffer[index];
    }

    @Override
    public PersistentList<E> set(int index, E element) {
        ListImplementation.checkElementIndex$kotlinx_collections_immutable(index, size());
        Object[] objArr = this.buffer;
        Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
        objArrCopyOf[index] = element;
        return new SmallPersistentVector(objArrCopyOf);
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0001\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0017\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\b"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableList/SmallPersistentVector$Companion;", "", "()V", "EMPTY", "Lkotlinx/collections/immutable/implementations/immutableList/SmallPersistentVector;", "", "getEMPTY", "()Lkotlinx/collections/immutable/implementations/immutableList/SmallPersistentVector;", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final SmallPersistentVector getEMPTY() {
            return SmallPersistentVector.EMPTY;
        }
    }
}
