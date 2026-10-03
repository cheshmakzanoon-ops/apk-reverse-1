package kotlinx.collections.immutable.implementations.immutableSet;

import java.util.Arrays;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.internal.CommonFunctionsKt;
import kotlinx.collections.immutable.internal.DeltaCounter;
import kotlinx.collections.immutable.internal.MutabilityOwnership;

@Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0011\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u001e\n\u0002\u0010\u000b\n\u0002\b\u001d\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0015\b\u0000\u0018\u0000 ^*\u0004\b\u0000\u0010\u00012\u00020\u0002:\u0001^B\u001f\b\u0016\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u000e\u0010\u0005\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\u0006¢\u0006\u0002\u0010\u0007B'\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u000e\u0010\u0005\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\u0006\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nJ)\u0010\u0018\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u0019\u001a\u00020\u00042\u0006\u0010\u001a\u001a\u00028\u00002\u0006\u0010\u001b\u001a\u00020\u0004¢\u0006\u0002\u0010\u001cJ-\u0010\u001d\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001e\u001a\u00020\u00042\u0006\u0010\u001a\u001a\u00028\u00002\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002¢\u0006\u0002\u0010 J\b\u0010!\u001a\u00020\u0004H\u0002J.\u0010\"\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010#\u001a\u00020\u00042\f\u0010$\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002J\u001b\u0010%\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001a\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010&J\u0015\u0010'\u001a\u00020(2\u0006\u0010\u001a\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010)J\u001b\u0010*\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001a\u001a\u00028\u0000H\u0002¢\u0006\u0002\u0010&J \u0010+\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010,\u001a\u00020\u00042\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002J#\u0010-\u001a\u00020(2\u0006\u0010\u0019\u001a\u00020\u00042\u0006\u0010\u001a\u001a\u00028\u00002\u0006\u0010\u001b\u001a\u00020\u0004¢\u0006\u0002\u0010.J\u001c\u0010/\u001a\u00020(2\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001b\u001a\u00020\u0004J\u0015\u00101\u001a\u00028\u00002\u0006\u00102\u001a\u00020\u0004H\u0002¢\u0006\u0002\u00103J\u0016\u00104\u001a\u00020(2\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u00000\u0000H\u0002J\u0010\u00105\u001a\u00020(2\u0006\u0010\u001e\u001a\u00020\u0004H\u0002J\u0015\u00106\u001a\u00020\u00042\u0006\u0010\u001e\u001a\u00020\u0004H\u0000¢\u0006\u0002\b7JE\u00108\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u00109\u001a\u00020\u00042\u0006\u0010:\u001a\u00028\u00002\u0006\u0010;\u001a\u00020\u00042\u0006\u0010<\u001a\u00028\u00002\u0006\u0010\u001b\u001a\u00020\u00042\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002¢\u0006\u0002\u0010=J=\u0010>\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010?\u001a\u00020\u00042\u0006\u0010@\u001a\u00020\u00042\u0006\u0010A\u001a\u00028\u00002\u0006\u0010\u001b\u001a\u00020\u00042\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002¢\u0006\u0002\u0010BJ=\u0010C\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010?\u001a\u00020\u00042\u0006\u0010@\u001a\u00020\u00042\u0006\u0010A\u001a\u00028\u00002\u0006\u0010\u001b\u001a\u00020\u00042\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002¢\u0006\u0002\u0010BJ5\u0010D\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u0019\u001a\u00020\u00042\u0006\u0010\u001a\u001a\u00028\u00002\u0006\u0010\u001b\u001a\u00020\u00042\n\u0010E\u001a\u0006\u0012\u0002\b\u00030F¢\u0006\u0002\u0010GJ6\u0010H\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001b\u001a\u00020\u00042\u0006\u0010I\u001a\u00020J2\n\u0010E\u001a\u0006\u0012\u0002\b\u00030FJ'\u0010K\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001a\u001a\u00028\u00002\n\u0010E\u001a\u0006\u0012\u0002\b\u00030FH\u0002¢\u0006\u0002\u0010LJ,\u0010M\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010I\u001a\u00020J2\u0006\u0010\u001f\u001a\u00020\tH\u0002J'\u0010N\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001a\u001a\u00028\u00002\n\u0010E\u001a\u0006\u0012\u0002\b\u00030FH\u0002¢\u0006\u0002\u0010LJ(\u0010O\u001a\u0004\u0018\u00010\u00022\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010I\u001a\u00020J2\u0006\u0010\u001f\u001a\u00020\tH\u0002J(\u0010P\u001a\u0004\u0018\u00010\u00022\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010I\u001a\u00020J2\u0006\u0010\u001f\u001a\u00020\tH\u0002J5\u0010Q\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u0019\u001a\u00020\u00042\u0006\u0010\u001a\u001a\u00028\u00002\u0006\u0010\u001b\u001a\u00020\u00042\n\u0010E\u001a\u0006\u0012\u0002\b\u00030F¢\u0006\u0002\u0010GJ2\u0010R\u001a\u0004\u0018\u00010\u00022\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001b\u001a\u00020\u00042\u0006\u0010I\u001a\u00020J2\n\u0010E\u001a\u0006\u0012\u0002\b\u00030FJ2\u0010S\u001a\u0004\u0018\u00010\u00022\f\u00100\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u001b\u001a\u00020\u00042\u0006\u0010I\u001a\u00020J2\n\u0010E\u001a\u0006\u0012\u0002\b\u00030FJ\u0016\u0010T\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u00102\u001a\u00020\u0004H\u0002J)\u0010U\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u0019\u001a\u00020\u00042\u0006\u0010\u001a\u001a\u00028\u00002\u0006\u0010\u001b\u001a\u00020\u0004¢\u0006\u0002\u0010\u001cJ(\u0010V\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010W\u001a\u00020\u00042\u0006\u0010\u001e\u001a\u00020\u00042\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002J*\u0010X\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010W\u001a\u00020\u00042\b\u0010Y\u001a\u0004\u0018\u00010\u00022\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002J5\u0010Z\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010[\u001a\u00020\u00042\u000e\u0010\\\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\u00062\b\u0010\u001f\u001a\u0004\u0018\u00010\tH\u0002¢\u0006\u0002\u0010]R\u001a\u0010\u0003\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR$\u0010\u0005\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\u0006X\u0086\u000e¢\u0006\u0010\n\u0002\u0010\u0013\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R\u001c\u0010\b\u001a\u0004\u0018\u00010\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\u0015\"\u0004\b\u0016\u0010\u0017¨\u0006_"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "E", "", "bitmap", "", "buffer", "", "(I[Ljava/lang/Object;)V", "ownedBy", "Lkotlinx/collections/immutable/internal/MutabilityOwnership;", "(I[Ljava/lang/Object;Lkotlinx/collections/immutable/internal/MutabilityOwnership;)V", "getBitmap", "()I", "setBitmap", "(I)V", "getBuffer", "()[Ljava/lang/Object;", "setBuffer", "([Ljava/lang/Object;)V", "[Ljava/lang/Object;", "getOwnedBy", "()Lkotlinx/collections/immutable/internal/MutabilityOwnership;", "setOwnedBy", "(Lkotlinx/collections/immutable/internal/MutabilityOwnership;)V", "add", "elementHash", "element", "shift", "(ILjava/lang/Object;I)Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "addElementAt", "positionMask", "owner", "(ILjava/lang/Object;Lkotlinx/collections/immutable/internal/MutabilityOwnership;)Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "calculateSize", "canonicalizeNodeAtIndex", "nodeIndex", "newNode", "collisionAdd", "(Ljava/lang/Object;)Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "collisionContainsElement", "", "(Ljava/lang/Object;)Z", "collisionRemove", "collisionRemoveElementAtIndex", "i", "contains", "(ILjava/lang/Object;I)Z", "containsAll", "otherNode", "elementAtIndex", "index", "(I)Ljava/lang/Object;", "elementsIdentityEquals", "hasNoCellAt", "indexOfCellAt", "indexOfCellAt$kotlinx_collections_immutable", "makeNode", "elementHash1", "element1", "elementHash2", "element2", "(ILjava/lang/Object;ILjava/lang/Object;ILkotlinx/collections/immutable/internal/MutabilityOwnership;)Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "makeNodeAtIndex", "elementIndex", "newElementHash", "newElement", "(IILjava/lang/Object;ILkotlinx/collections/immutable/internal/MutabilityOwnership;)Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "moveElementToNode", "mutableAdd", "mutator", "Lkotlinx/collections/immutable/implementations/immutableSet/PersistentHashSetBuilder;", "(ILjava/lang/Object;ILkotlinx/collections/immutable/implementations/immutableSet/PersistentHashSetBuilder;)Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "mutableAddAll", "intersectionSizeRef", "Lkotlinx/collections/immutable/internal/DeltaCounter;", "mutableCollisionAdd", "(Ljava/lang/Object;Lkotlinx/collections/immutable/implementations/immutableSet/PersistentHashSetBuilder;)Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "mutableCollisionAddAll", "mutableCollisionRemove", "mutableCollisionRemoveAll", "mutableCollisionRetainAll", "mutableRemove", "mutableRemoveAll", "mutableRetainAll", "nodeAtIndex", "remove", "removeCellAtIndex", "cellIndex", "setCellAtIndex", "newCell", "setProperties", "newBitmap", "newBuffer", "(I[Ljava/lang/Object;Lkotlinx/collections/immutable/internal/MutabilityOwnership;)Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "Companion", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class TrieNode<E> {

    public static final Companion INSTANCE = new Companion(null);
    private static final TrieNode EMPTY = new TrieNode(0, new Object[0]);
    private int bitmap;
    private Object[] buffer;
    private MutabilityOwnership ownedBy;

    public TrieNode(int i, Object[] buffer, MutabilityOwnership mutabilityOwnership) {
        Intrinsics.checkNotNullParameter(buffer, "buffer");
        this.bitmap = i;
        this.buffer = buffer;
        this.ownedBy = mutabilityOwnership;
    }

    public final int getBitmap() {
        return this.bitmap;
    }

    public final void setBitmap(int i) {
        this.bitmap = i;
    }

    public final Object[] getBuffer() {
        return this.buffer;
    }

    public final void setBuffer(Object[] objArr) {
        Intrinsics.checkNotNullParameter(objArr, "<set-?>");
        this.buffer = objArr;
    }

    public final MutabilityOwnership getOwnedBy() {
        return this.ownedBy;
    }

    public final void setOwnedBy(MutabilityOwnership mutabilityOwnership) {
        this.ownedBy = mutabilityOwnership;
    }

    public TrieNode(int i, Object[] buffer) {
        this(i, buffer, null);
        Intrinsics.checkNotNullParameter(buffer, "buffer");
    }

    private final boolean hasNoCellAt(int positionMask) {
        return (positionMask & this.bitmap) == 0;
    }

    public final int indexOfCellAt$kotlinx_collections_immutable(int positionMask) {
        return Integer.bitCount((positionMask - 1) & this.bitmap);
    }

    private final E elementAtIndex(int index) {
        return (E) this.buffer[index];
    }

    private final TrieNode<E> nodeAtIndex(int index) {
        Object obj = this.buffer[index];
        if (obj != null) {
            return (TrieNode) obj;
        }
        throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode>");
    }

    private final TrieNode<E> addElementAt(int positionMask, E element, MutabilityOwnership owner) {
        return setProperties(positionMask | this.bitmap, TrieNodeKt.addElementAtIndex(this.buffer, indexOfCellAt$kotlinx_collections_immutable(positionMask), element), owner);
    }

    private final TrieNode<E> setProperties(int newBitmap, Object[] newBuffer, MutabilityOwnership owner) {
        MutabilityOwnership mutabilityOwnership = this.ownedBy;
        if (mutabilityOwnership != null && mutabilityOwnership == owner) {
            this.bitmap = newBitmap;
            this.buffer = newBuffer;
            return this;
        }
        return new TrieNode<>(newBitmap, newBuffer, owner);
    }

    private final TrieNode<E> canonicalizeNodeAtIndex(int nodeIndex, TrieNode<E> newNode, MutabilityOwnership owner) {
        Object[] objArr = newNode.buffer;
        if (objArr.length == 1) {
            Object obj = objArr[0];
            if (!(obj instanceof TrieNode)) {
                if (this.buffer.length == 1) {
                    newNode.bitmap = this.bitmap;
                    return newNode;
                }
                newNode = (TrieNode<E>) obj;
            }
        }
        return setCellAtIndex(nodeIndex, newNode, owner);
    }

    private final TrieNode<E> setCellAtIndex(int cellIndex, Object newCell, MutabilityOwnership owner) {
        MutabilityOwnership mutabilityOwnership = this.ownedBy;
        if (mutabilityOwnership != null && mutabilityOwnership == owner) {
            this.buffer[cellIndex] = newCell;
            return this;
        }
        Object[] objArr = this.buffer;
        Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
        objArrCopyOf[cellIndex] = newCell;
        return new TrieNode<>(this.bitmap, objArrCopyOf, owner);
    }

    private final TrieNode<E> makeNodeAtIndex(int elementIndex, int newElementHash, E newElement, int shift, MutabilityOwnership owner) {
        E eElementAtIndex = elementAtIndex(elementIndex);
        return makeNode(eElementAtIndex == null ? 0 : eElementAtIndex.hashCode(), eElementAtIndex, newElementHash, newElement, shift + 5, owner);
    }

    private final TrieNode<E> moveElementToNode(int elementIndex, int newElementHash, E newElement, int shift, MutabilityOwnership owner) {
        return setCellAtIndex(elementIndex, makeNodeAtIndex(elementIndex, newElementHash, newElement, shift, owner), owner);
    }

    private final TrieNode<E> makeNode(int elementHash1, E element1, int elementHash2, E element2, int shift, MutabilityOwnership owner) {
        Object[] objArr;
        if (shift > 30) {
            return new TrieNode<>(0, new Object[]{element1, element2}, owner);
        }
        int iIndexSegment = TrieNodeKt.indexSegment(elementHash1, shift);
        int iIndexSegment2 = TrieNodeKt.indexSegment(elementHash2, shift);
        if (iIndexSegment != iIndexSegment2) {
            if (iIndexSegment < iIndexSegment2) {
                objArr = new Object[]{element1, element2};
            } else {
                objArr = new Object[]{element2, element1};
            }
            return new TrieNode<>((1 << iIndexSegment) | (1 << iIndexSegment2), objArr, owner);
        }
        return new TrieNode<>(1 << iIndexSegment, new Object[]{makeNode(elementHash1, element1, elementHash2, element2, shift + 5, owner)}, owner);
    }

    private final TrieNode<E> removeCellAtIndex(int cellIndex, int positionMask, MutabilityOwnership owner) {
        return setProperties(positionMask ^ this.bitmap, TrieNodeKt.removeCellAtIndex(this.buffer, cellIndex), owner);
    }

    private final TrieNode<E> collisionRemoveElementAtIndex(int i, MutabilityOwnership owner) {
        return setProperties(0, TrieNodeKt.removeCellAtIndex(this.buffer, i), owner);
    }

    private final boolean collisionContainsElement(E element) {
        return ArraysKt.contains((E[]) this.buffer, element);
    }

    private final TrieNode<E> collisionAdd(E element) {
        return collisionContainsElement(element) ? this : setProperties(0, TrieNodeKt.addElementAtIndex(this.buffer, 0, element), null);
    }

    private final TrieNode<E> mutableCollisionAdd(E element, PersistentHashSetBuilder<?> mutator) {
        if (collisionContainsElement(element)) {
            return this;
        }
        mutator.setSize(mutator.size() + 1);
        return setProperties(0, TrieNodeKt.addElementAtIndex(this.buffer, 0, element), mutator.getOwnership());
    }

    private final TrieNode<E> collisionRemove(E element) {
        int iIndexOf = ArraysKt.indexOf((E[]) this.buffer, element);
        return iIndexOf != -1 ? collisionRemoveElementAtIndex(iIndexOf, null) : this;
    }

    private final TrieNode<E> mutableCollisionRemove(E element, PersistentHashSetBuilder<?> mutator) {
        int iIndexOf = ArraysKt.indexOf((E[]) this.buffer, element);
        if (iIndexOf == -1) {
            return this;
        }
        mutator.setSize(mutator.size() - 1);
        return collisionRemoveElementAtIndex(iIndexOf, mutator.getOwnership());
    }

    private final TrieNode<E> mutableCollisionAddAll(TrieNode<E> otherNode, DeltaCounter intersectionSizeRef, MutabilityOwnership owner) {
        if (this == otherNode) {
            intersectionSizeRef.plusAssign(this.buffer.length);
            return this;
        }
        Object[] objArr = this.buffer;
        Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length + otherNode.buffer.length);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
        Object[] objArr2 = otherNode.buffer;
        int length = this.buffer.length;
        int i = 0;
        int i2 = 0;
        while (i < objArr2.length) {
            CommonFunctionsKt.m1793assert(i2 <= i);
            if (!collisionContainsElement(objArr2[i])) {
                objArrCopyOf[length + i2] = objArr2[i];
                i2++;
                CommonFunctionsKt.m1793assert(length + i2 <= objArrCopyOf.length);
            }
            i++;
        }
        int length2 = i2 + this.buffer.length;
        intersectionSizeRef.plusAssign(objArrCopyOf.length - length2);
        if (length2 == this.buffer.length) {
            return this;
        }
        if (length2 == otherNode.buffer.length) {
            return otherNode;
        }
        if (length2 != objArrCopyOf.length) {
            objArrCopyOf = Arrays.copyOf(objArrCopyOf, length2);
            Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
        }
        return setProperties(0, objArrCopyOf, owner);
    }

    private final Object mutableCollisionRetainAll(TrieNode<E> otherNode, DeltaCounter intersectionSizeRef, MutabilityOwnership owner) {
        if (this == otherNode) {
            intersectionSizeRef.plusAssign(this.buffer.length);
            return this;
        }
        Object[] objArr = owner == this.ownedBy ? this.buffer : new Object[Math.min(this.buffer.length, otherNode.buffer.length)];
        Object[] objArr2 = this.buffer;
        int i = 0;
        int i2 = 0;
        while (true) {
            if (i >= objArr2.length) {
                break;
            }
            CommonFunctionsKt.m1793assert(i2 <= i);
            if (otherNode.collisionContainsElement(objArr2[i])) {
                objArr[i2] = objArr2[i];
                i2++;
                CommonFunctionsKt.m1793assert(i2 <= objArr.length);
            }
            i++;
        }
        intersectionSizeRef.plusAssign(i2);
        if (i2 == 0) {
            return EMPTY;
        }
        if (i2 == 1) {
            return objArr[0];
        }
        if (i2 == this.buffer.length) {
            return this;
        }
        if (i2 == otherNode.buffer.length) {
            return otherNode;
        }
        if (i2 == objArr.length) {
            return setProperties(0, objArr, owner);
        }
        Object[] objArrCopyOf = Arrays.copyOf(objArr, i2);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
        return setProperties(0, objArrCopyOf, owner);
    }

    private final Object mutableCollisionRemoveAll(TrieNode<E> otherNode, DeltaCounter intersectionSizeRef, MutabilityOwnership owner) {
        if (this == otherNode) {
            intersectionSizeRef.plusAssign(this.buffer.length);
            return EMPTY;
        }
        Object[] objArr = owner == this.ownedBy ? this.buffer : new Object[this.buffer.length];
        Object[] objArr2 = this.buffer;
        int i = 0;
        int i2 = 0;
        while (true) {
            if (i >= objArr2.length) {
                break;
            }
            CommonFunctionsKt.m1793assert(i2 <= i);
            if (!otherNode.collisionContainsElement(objArr2[i])) {
                objArr[i2] = objArr2[i];
                i2++;
                CommonFunctionsKt.m1793assert(i2 <= objArr.length);
            }
            i++;
        }
        intersectionSizeRef.plusAssign(this.buffer.length - i2);
        if (i2 == 0) {
            return EMPTY;
        }
        if (i2 == 1) {
            return objArr[0];
        }
        if (i2 == this.buffer.length) {
            return this;
        }
        if (i2 == objArr.length) {
            return setProperties(0, objArr, owner);
        }
        Object[] objArrCopyOf = Arrays.copyOf(objArr, i2);
        Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, newSize)");
        return setProperties(0, objArrCopyOf, owner);
    }

    private final int calculateSize() {
        if (this.bitmap == 0) {
            return this.buffer.length;
        }
        Object[] objArr = this.buffer;
        int length = objArr.length;
        int i = 0;
        int iCalculateSize = 0;
        while (i < length) {
            Object obj = objArr[i];
            i++;
            iCalculateSize += obj instanceof TrieNode ? ((TrieNode) obj).calculateSize() : 1;
        }
        return iCalculateSize;
    }

    private final boolean elementsIdentityEquals(TrieNode<E> otherNode) {
        if (this == otherNode) {
            return true;
        }
        if (this.bitmap != otherNode.bitmap) {
            return false;
        }
        int length = this.buffer.length;
        int i = 0;
        while (i < length) {
            int i2 = i + 1;
            if (this.buffer[i] != otherNode.buffer[i]) {
                return false;
            }
            i = i2;
        }
        return true;
    }

    public final boolean contains(int elementHash, E element, int shift) {
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(elementHash, shift);
        if (hasNoCellAt(iIndexSegment)) {
            return false;
        }
        int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iIndexSegment);
        Object obj = this.buffer[iIndexOfCellAt$kotlinx_collections_immutable];
        if (obj instanceof TrieNode) {
            TrieNode<E> trieNodeNodeAtIndex = nodeAtIndex(iIndexOfCellAt$kotlinx_collections_immutable);
            if (shift == 30) {
                return trieNodeNodeAtIndex.collisionContainsElement(element);
            }
            return trieNodeNodeAtIndex.contains(elementHash, element, shift + 5);
        }
        return Intrinsics.areEqual(element, obj);
    }

    public final TrieNode<E> mutableAddAll(TrieNode<E> otherNode, int shift, DeltaCounter intersectionSizeRef, PersistentHashSetBuilder<?> mutator) {
        Object objMakeNode;
        TrieNode trieNodeMutableAdd;
        Intrinsics.checkNotNullParameter(otherNode, "otherNode");
        Intrinsics.checkNotNullParameter(intersectionSizeRef, "intersectionSizeRef");
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        if (this == otherNode) {
            intersectionSizeRef.setCount(intersectionSizeRef.getCount() + calculateSize());
            return this;
        }
        if (shift > 30) {
            return mutableCollisionAddAll(otherNode, intersectionSizeRef, mutator.getOwnership());
        }
        int i = this.bitmap;
        int i2 = otherNode.bitmap | i;
        TrieNode<E> trieNode = (i2 == i && Intrinsics.areEqual(this.ownedBy, mutator.getOwnership())) ? this : new TrieNode<>(i2, new Object[Integer.bitCount(i2)], mutator.getOwnership());
        int i3 = i2;
        int i4 = 0;
        while (i3 != 0) {
            int iLowestOneBit = Integer.lowestOneBit(i3);
            int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iLowestOneBit);
            int iIndexOfCellAt$kotlinx_collections_immutable2 = otherNode.indexOfCellAt$kotlinx_collections_immutable(iLowestOneBit);
            Object[] buffer = trieNode.getBuffer();
            if (hasNoCellAt(iLowestOneBit)) {
                objMakeNode = otherNode.getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable2];
            } else if (otherNode.hasNoCellAt(iLowestOneBit)) {
                objMakeNode = getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable];
            } else {
                Object obj = getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable];
                Object obj2 = otherNode.getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable2];
                boolean z = obj instanceof TrieNode;
                boolean z2 = obj2 instanceof TrieNode;
                if (!z || !z2) {
                    if (!z) {
                        if (z2) {
                            if (obj2 != null) {
                                TrieNode trieNode2 = (TrieNode) obj2;
                                int size = mutator.size();
                                trieNodeMutableAdd = trieNode2.mutableAdd(obj == null ? 0 : obj.hashCode(), obj, shift + 5, mutator);
                                if (mutator.size() == size) {
                                    intersectionSizeRef.setCount(intersectionSizeRef.getCount() + 1);
                                }
                                Unit unit = Unit.INSTANCE;
                            } else {
                                throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableAddAll$lambda-6>");
                            }
                        } else if (Intrinsics.areEqual(obj, obj2)) {
                            intersectionSizeRef.setCount(intersectionSizeRef.getCount() + 1);
                            Unit unit2 = Unit.INSTANCE;
                            objMakeNode = obj;
                        } else {
                            objMakeNode = makeNode(obj == null ? 0 : obj.hashCode(), obj, obj2 == null ? 0 : obj2.hashCode(), obj2, shift + 5, mutator.getOwnership());
                        }
                        buffer[i4] = objMakeNode;
                        i4++;
                        i3 ^= iLowestOneBit;
                    } else if (obj != null) {
                        TrieNode trieNode3 = (TrieNode) obj;
                        int size2 = mutator.size();
                        trieNodeMutableAdd = trieNode3.mutableAdd(obj2 == null ? 0 : obj2.hashCode(), obj2, shift + 5, mutator);
                        if (mutator.size() == size2) {
                            intersectionSizeRef.setCount(intersectionSizeRef.getCount() + 1);
                        }
                        Unit unit3 = Unit.INSTANCE;
                    } else {
                        throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableAddAll$lambda-6>");
                    }
                    objMakeNode = trieNodeMutableAdd;
                } else if (obj != null) {
                    TrieNode trieNode4 = (TrieNode) obj;
                    if (obj2 == null) {
                        throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableAddAll$lambda-6>");
                    }
                    objMakeNode = trieNode4.mutableAddAll((TrieNode) obj2, shift + 5, intersectionSizeRef, mutator);
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableAddAll$lambda-6>");
                }
            }
            buffer[i4] = objMakeNode;
            i4++;
            i3 ^= iLowestOneBit;
        }
        if (elementsIdentityEquals(trieNode)) {
            return this;
        }
        return otherNode.elementsIdentityEquals(trieNode) ? otherNode : trieNode;
    }

    public final Object mutableRetainAll(TrieNode<E> otherNode, int shift, DeltaCounter intersectionSizeRef, PersistentHashSetBuilder<?> mutator) {
        TrieNode trieNode;
        Intrinsics.checkNotNullParameter(otherNode, "otherNode");
        Intrinsics.checkNotNullParameter(intersectionSizeRef, "intersectionSizeRef");
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        if (this == otherNode) {
            intersectionSizeRef.plusAssign(calculateSize());
            return this;
        }
        if (shift > 30) {
            return mutableCollisionRetainAll(otherNode, intersectionSizeRef, mutator.getOwnership());
        }
        int i = this.bitmap & otherNode.bitmap;
        if (i == 0) {
            return EMPTY;
        }
        TrieNode<E> trieNode2 = (Intrinsics.areEqual(this.ownedBy, mutator.getOwnership()) && i == this.bitmap) ? this : new TrieNode<>(i, new Object[Integer.bitCount(i)], mutator.getOwnership());
        int i2 = i;
        int i3 = 0;
        int i4 = 0;
        while (i2 != 0) {
            int iLowestOneBit = Integer.lowestOneBit(i2);
            int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iLowestOneBit);
            int iIndexOfCellAt$kotlinx_collections_immutable2 = otherNode.indexOfCellAt$kotlinx_collections_immutable(iLowestOneBit);
            Object objMutableRetainAll = getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable];
            Object obj = otherNode.getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable2];
            boolean z = objMutableRetainAll instanceof TrieNode;
            boolean z2 = obj instanceof TrieNode;
            if (z && z2) {
                if (objMutableRetainAll != null) {
                    TrieNode trieNode3 = (TrieNode) objMutableRetainAll;
                    if (obj == null) {
                        throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableRetainAll$lambda-9$lambda-8>");
                    }
                    objMutableRetainAll = trieNode3.mutableRetainAll((TrieNode) obj, shift + 5, intersectionSizeRef, mutator);
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableRetainAll$lambda-9$lambda-8>");
                }
            } else if (z) {
                if (objMutableRetainAll == null) {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableRetainAll$lambda-9$lambda-8>");
                }
                if (((TrieNode) objMutableRetainAll).contains(obj == null ? 0 : obj.hashCode(), obj, shift + 5)) {
                    intersectionSizeRef.plusAssign(1);
                    objMutableRetainAll = obj;
                } else {
                    objMutableRetainAll = EMPTY;
                }
            } else if (z2) {
                if (obj == null) {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableRetainAll$lambda-9$lambda-8>");
                }
                if (((TrieNode) obj).contains(objMutableRetainAll == null ? 0 : objMutableRetainAll.hashCode(), objMutableRetainAll, shift + 5)) {
                    intersectionSizeRef.plusAssign(1);
                } else {
                    objMutableRetainAll = EMPTY;
                }
            } else if (Intrinsics.areEqual(objMutableRetainAll, obj)) {
                intersectionSizeRef.plusAssign(1);
            } else {
                objMutableRetainAll = EMPTY;
            }
            if (objMutableRetainAll != EMPTY) {
                i3 |= iLowestOneBit;
            }
            trieNode2.getBuffer()[i4] = objMutableRetainAll;
            i4++;
            i2 ^= iLowestOneBit;
        }
        int iBitCount = Integer.bitCount(i3);
        if (i3 == 0) {
            return EMPTY;
        }
        if (i3 == i) {
            if (trieNode2.elementsIdentityEquals(this)) {
                return this;
            }
            return trieNode2.elementsIdentityEquals(otherNode) ? otherNode : trieNode2;
        }
        if (iBitCount == 1 && shift != 0) {
            Object obj2 = trieNode2.buffer[trieNode2.indexOfCellAt$kotlinx_collections_immutable(i3)];
            if (!(obj2 instanceof TrieNode)) {
                return obj2;
            }
            trieNode = new TrieNode(i3, new Object[]{obj2}, mutator.getOwnership());
        } else {
            Object[] objArr = new Object[iBitCount];
            Object[] objArr2 = trieNode2.buffer;
            int i5 = 0;
            int i6 = 0;
            while (i5 < objArr2.length) {
                CommonFunctionsKt.m1793assert(i6 <= i5);
                if (objArr2[i5] != INSTANCE.getEMPTY$kotlinx_collections_immutable()) {
                    objArr[i6] = objArr2[i5];
                    i6++;
                    CommonFunctionsKt.m1793assert(i6 <= iBitCount);
                }
                i5++;
            }
            trieNode = new TrieNode(i3, objArr, mutator.getOwnership());
        }
        return trieNode;
    }

    public final Object mutableRemoveAll(TrieNode<E> otherNode, int shift, DeltaCounter intersectionSizeRef, PersistentHashSetBuilder<?> mutator) {
        TrieNode<E> trieNode;
        Intrinsics.checkNotNullParameter(otherNode, "otherNode");
        Intrinsics.checkNotNullParameter(intersectionSizeRef, "intersectionSizeRef");
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        if (this == otherNode) {
            intersectionSizeRef.plusAssign(calculateSize());
            return EMPTY;
        }
        if (shift > 30) {
            return mutableCollisionRemoveAll(otherNode, intersectionSizeRef, mutator.getOwnership());
        }
        int i = this.bitmap & otherNode.bitmap;
        if (i == 0) {
            return this;
        }
        if (Intrinsics.areEqual(this.ownedBy, mutator.getOwnership())) {
            trieNode = this;
        } else {
            int i2 = this.bitmap;
            Object[] objArr = this.buffer;
            Object[] objArrCopyOf = Arrays.copyOf(objArr, objArr.length);
            Intrinsics.checkNotNullExpressionValue(objArrCopyOf, "copyOf(this, size)");
            trieNode = new TrieNode<>(i2, objArrCopyOf, mutator.getOwnership());
        }
        int i3 = this.bitmap;
        while (i != 0) {
            int iLowestOneBit = Integer.lowestOneBit(i);
            int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iLowestOneBit);
            int iIndexOfCellAt$kotlinx_collections_immutable2 = otherNode.indexOfCellAt$kotlinx_collections_immutable(iLowestOneBit);
            Object objMutableRemoveAll = getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable];
            Object obj = otherNode.getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable2];
            boolean z = objMutableRemoveAll instanceof TrieNode;
            boolean z2 = obj instanceof TrieNode;
            if (z && z2) {
                if (objMutableRemoveAll != null) {
                    TrieNode trieNode2 = (TrieNode) objMutableRemoveAll;
                    if (obj == null) {
                        throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableRemoveAll$lambda-11$lambda-10>");
                    }
                    objMutableRemoveAll = trieNode2.mutableRemoveAll((TrieNode) obj, shift + 5, intersectionSizeRef, mutator);
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableRemoveAll$lambda-11$lambda-10>");
                }
            } else if (z) {
                if (objMutableRemoveAll != null) {
                    TrieNode trieNode3 = (TrieNode) objMutableRemoveAll;
                    int size = mutator.size();
                    TrieNode trieNodeMutableRemove = trieNode3.mutableRemove(obj == null ? 0 : obj.hashCode(), obj, shift + 5, mutator);
                    if (size != mutator.size()) {
                        intersectionSizeRef.plusAssign(1);
                        objMutableRemoveAll = (trieNodeMutableRemove.getBuffer().length != 1 || (trieNodeMutableRemove.getBuffer()[0] instanceof TrieNode)) ? trieNodeMutableRemove : trieNodeMutableRemove.getBuffer()[0];
                    }
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableRemoveAll$lambda-11$lambda-10>");
                }
            } else if (z2) {
                if (obj == null) {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.mutableRemoveAll$lambda-11$lambda-10>");
                }
                if (((TrieNode) obj).contains(objMutableRemoveAll == null ? 0 : objMutableRemoveAll.hashCode(), objMutableRemoveAll, shift + 5)) {
                    intersectionSizeRef.plusAssign(1);
                    objMutableRemoveAll = EMPTY;
                }
            } else if (Intrinsics.areEqual(objMutableRemoveAll, obj)) {
                intersectionSizeRef.plusAssign(1);
                objMutableRemoveAll = EMPTY;
            }
            if (objMutableRemoveAll == EMPTY) {
                i3 ^= iLowestOneBit;
            }
            trieNode.getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable] = objMutableRemoveAll;
            i ^= iLowestOneBit;
        }
        int iBitCount = Integer.bitCount(i3);
        if (i3 == 0) {
            return EMPTY;
        }
        if (i3 == this.bitmap) {
            return trieNode.elementsIdentityEquals(this) ? this : trieNode;
        }
        if (iBitCount == 1 && shift != 0) {
            Object obj2 = trieNode.buffer[trieNode.indexOfCellAt$kotlinx_collections_immutable(i3)];
            return obj2 instanceof TrieNode ? new TrieNode(i3, new Object[]{obj2}, mutator.getOwnership()) : obj2;
        }
        Object[] objArr2 = new Object[iBitCount];
        Object[] objArr3 = trieNode.buffer;
        int i4 = 0;
        int i5 = 0;
        while (i5 < objArr3.length) {
            CommonFunctionsKt.m1793assert(i4 <= i5);
            if (objArr3[i5] != INSTANCE.getEMPTY$kotlinx_collections_immutable()) {
                objArr2[i4] = objArr3[i5];
                i4++;
                CommonFunctionsKt.m1793assert(i4 <= iBitCount);
            }
            i5++;
        }
        return new TrieNode(i3, objArr2, mutator.getOwnership());
    }

    public final boolean containsAll(TrieNode<E> otherNode, int shift) {
        Intrinsics.checkNotNullParameter(otherNode, "otherNode");
        if (this == otherNode) {
            return true;
        }
        if (shift > 30) {
            Object[] objArr = otherNode.buffer;
            int length = objArr.length;
            int i = 0;
            while (i < length) {
                Object obj = objArr[i];
                i++;
                if (!ArraysKt.contains(getBuffer(), obj)) {
                    return false;
                }
            }
            return true;
        }
        int i2 = this.bitmap;
        int i3 = otherNode.bitmap;
        int i4 = i2 & i3;
        if (i4 != i3) {
            return false;
        }
        while (i4 != 0) {
            int iLowestOneBit = Integer.lowestOneBit(i4);
            int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iLowestOneBit);
            int iIndexOfCellAt$kotlinx_collections_immutable2 = otherNode.indexOfCellAt$kotlinx_collections_immutable(iLowestOneBit);
            Object obj2 = getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable];
            Object obj3 = otherNode.getBuffer()[iIndexOfCellAt$kotlinx_collections_immutable2];
            boolean z = obj2 instanceof TrieNode;
            boolean z2 = obj3 instanceof TrieNode;
            if (z && z2) {
                if (obj2 != null) {
                    TrieNode trieNode = (TrieNode) obj2;
                    if (obj3 == null) {
                        throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.containsAll$lambda-13>");
                    }
                    if (!trieNode.containsAll((TrieNode) obj3, shift + 5)) {
                        return false;
                    }
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.containsAll$lambda-13>");
                }
            } else if (z) {
                if (obj2 == null) {
                    throw new NullPointerException("null cannot be cast to non-null type kotlinx.collections.immutable.implementations.immutableSet.TrieNode<E of kotlinx.collections.immutable.implementations.immutableSet.TrieNode.containsAll$lambda-13>");
                }
                if (!((TrieNode) obj2).contains(obj3 == null ? 0 : obj3.hashCode(), obj3, shift + 5)) {
                    return false;
                }
            } else if (z2 || !Intrinsics.areEqual(obj2, obj3)) {
                return false;
            }
            i4 ^= iLowestOneBit;
        }
        return true;
    }

    public final TrieNode<E> add(int elementHash, E element, int shift) {
        TrieNode<E> trieNodeAdd;
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(elementHash, shift);
        if (hasNoCellAt(iIndexSegment)) {
            return addElementAt(iIndexSegment, element, null);
        }
        int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iIndexSegment);
        Object obj = this.buffer[iIndexOfCellAt$kotlinx_collections_immutable];
        if (!(obj instanceof TrieNode)) {
            return Intrinsics.areEqual(element, obj) ? this : moveElementToNode(iIndexOfCellAt$kotlinx_collections_immutable, elementHash, element, shift, null);
        }
        TrieNode<E> trieNodeNodeAtIndex = nodeAtIndex(iIndexOfCellAt$kotlinx_collections_immutable);
        if (shift == 30) {
            trieNodeAdd = trieNodeNodeAtIndex.collisionAdd(element);
        } else {
            trieNodeAdd = trieNodeNodeAtIndex.add(elementHash, element, shift + 5);
        }
        return trieNodeNodeAtIndex == trieNodeAdd ? this : setCellAtIndex(iIndexOfCellAt$kotlinx_collections_immutable, trieNodeAdd, null);
    }

    public final TrieNode<E> mutableAdd(int elementHash, E element, int shift, PersistentHashSetBuilder<?> mutator) {
        TrieNode<E> trieNodeMutableAdd;
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(elementHash, shift);
        if (hasNoCellAt(iIndexSegment)) {
            mutator.setSize(mutator.size() + 1);
            return addElementAt(iIndexSegment, element, mutator.getOwnership());
        }
        int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iIndexSegment);
        Object obj = this.buffer[iIndexOfCellAt$kotlinx_collections_immutable];
        if (obj instanceof TrieNode) {
            TrieNode<E> trieNodeNodeAtIndex = nodeAtIndex(iIndexOfCellAt$kotlinx_collections_immutable);
            if (shift == 30) {
                trieNodeMutableAdd = trieNodeNodeAtIndex.mutableCollisionAdd(element, mutator);
            } else {
                trieNodeMutableAdd = trieNodeNodeAtIndex.mutableAdd(elementHash, element, shift + 5, mutator);
            }
            return trieNodeNodeAtIndex == trieNodeMutableAdd ? this : setCellAtIndex(iIndexOfCellAt$kotlinx_collections_immutable, trieNodeMutableAdd, mutator.getOwnership());
        }
        if (Intrinsics.areEqual(element, obj)) {
            return this;
        }
        mutator.setSize(mutator.size() + 1);
        return moveElementToNode(iIndexOfCellAt$kotlinx_collections_immutable, elementHash, element, shift, mutator.getOwnership());
    }

    public final TrieNode<E> remove(int elementHash, E element, int shift) {
        TrieNode<E> trieNodeRemove;
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(elementHash, shift);
        if (hasNoCellAt(iIndexSegment)) {
            return this;
        }
        int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iIndexSegment);
        Object obj = this.buffer[iIndexOfCellAt$kotlinx_collections_immutable];
        if (!(obj instanceof TrieNode)) {
            return Intrinsics.areEqual(element, obj) ? removeCellAtIndex(iIndexOfCellAt$kotlinx_collections_immutable, iIndexSegment, null) : this;
        }
        TrieNode<E> trieNodeNodeAtIndex = nodeAtIndex(iIndexOfCellAt$kotlinx_collections_immutable);
        if (shift == 30) {
            trieNodeRemove = trieNodeNodeAtIndex.collisionRemove(element);
        } else {
            trieNodeRemove = trieNodeNodeAtIndex.remove(elementHash, element, shift + 5);
        }
        return trieNodeNodeAtIndex == trieNodeRemove ? this : canonicalizeNodeAtIndex(iIndexOfCellAt$kotlinx_collections_immutable, trieNodeRemove, null);
    }

    public final TrieNode<E> mutableRemove(int elementHash, E element, int shift, PersistentHashSetBuilder<?> mutator) {
        TrieNode<E> trieNodeMutableRemove;
        Intrinsics.checkNotNullParameter(mutator, "mutator");
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(elementHash, shift);
        if (hasNoCellAt(iIndexSegment)) {
            return this;
        }
        int iIndexOfCellAt$kotlinx_collections_immutable = indexOfCellAt$kotlinx_collections_immutable(iIndexSegment);
        Object obj = this.buffer[iIndexOfCellAt$kotlinx_collections_immutable];
        if (obj instanceof TrieNode) {
            TrieNode<E> trieNodeNodeAtIndex = nodeAtIndex(iIndexOfCellAt$kotlinx_collections_immutable);
            if (shift == 30) {
                trieNodeMutableRemove = trieNodeNodeAtIndex.mutableCollisionRemove(element, mutator);
            } else {
                trieNodeMutableRemove = trieNodeNodeAtIndex.mutableRemove(elementHash, element, shift + 5, mutator);
            }
            return (trieNodeNodeAtIndex.ownedBy == mutator.getOwnership() || trieNodeNodeAtIndex != trieNodeMutableRemove) ? canonicalizeNodeAtIndex(iIndexOfCellAt$kotlinx_collections_immutable, trieNodeMutableRemove, mutator.getOwnership()) : this;
        }
        if (!Intrinsics.areEqual(element, obj)) {
            return this;
        }
        mutator.setSize(mutator.size() - 1);
        return removeCellAtIndex(iIndexOfCellAt$kotlinx_collections_immutable, iIndexSegment, mutator.getOwnership());
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0001\n\u0002\b\u0003\b\u0080\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u001a\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\b"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode$Companion;", "", "()V", "EMPTY", "Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "", "getEMPTY$kotlinx_collections_immutable", "()Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final TrieNode getEMPTY$kotlinx_collections_immutable() {
            return TrieNode.EMPTY;
        }
    }
}
