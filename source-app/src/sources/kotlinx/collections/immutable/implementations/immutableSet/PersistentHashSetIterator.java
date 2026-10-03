package kotlinx.collections.immutable.implementations.immutableSet;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import java.util.Iterator;
import java.util.List;
import java.util.NoSuchElementException;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.markers.KMappedMarker;
import kotlinx.collections.immutable.internal.CommonFunctionsKt;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010(\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0002\b\u0004\b\u0010\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B\u0013\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004¢\u0006\u0002\u0010\u0005J\r\u0010\u0015\u001a\u00028\u0000H\u0004¢\u0006\u0002\u0010\u0016J\b\u0010\u0017\u001a\u00020\u0018H\u0002J\t\u0010\u0006\u001a\u00020\u0007H\u0096\u0002J\u0010\u0010\u0019\u001a\u00020\u00102\u0006\u0010\u001a\u001a\u00020\u0010H\u0002J\u000e\u0010\u001b\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010\u0016R\u0018\u0010\u0006\u001a\u00020\u00078\u0002@\u0002X\u0083\u000e¢\u0006\b\n\u0000\u0012\u0004\b\b\u0010\tR \u0010\n\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00028\u00000\f0\u000bX\u0084\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u001a\u0010\u000f\u001a\u00020\u0010X\u0084\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014¨\u0006\u001c"}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableSet/PersistentHashSetIterator;", "E", "", "node", "Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;", "(Lkotlinx/collections/immutable/implementations/immutableSet/TrieNode;)V", "hasNext", "", "getHasNext$annotations", "()V", ClientCookie.PATH_ATTR, "", "Lkotlinx/collections/immutable/implementations/immutableSet/TrieNodeIterator;", "getPath", "()Ljava/util/List;", "pathLastIndex", "", "getPathLastIndex", "()I", "setPathLastIndex", "(I)V", "currentElement", "()Ljava/lang/Object;", "ensureNextElementIsReady", "", "moveToNextNodeWithData", "pathIndex", "next", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public class PersistentHashSetIterator<E> implements Iterator<E>, KMappedMarker {
    private boolean hasNext;
    private final List<TrieNodeIterator<E>> path;
    private int pathLastIndex;

    private static void getHasNext$annotations() {
    }

    @Override
    public void remove() {
        throw new UnsupportedOperationException("Operation is not supported for read-only collection");
    }

    public PersistentHashSetIterator(TrieNode<E> node) {
        Intrinsics.checkNotNullParameter(node, "node");
        List<TrieNodeIterator<E>> listMutableListOf = CollectionsKt.mutableListOf(new TrieNodeIterator());
        this.path = listMutableListOf;
        this.hasNext = true;
        TrieNodeIterator.reset$default(listMutableListOf.get(0), node.getBuffer(), 0, 2, null);
        this.pathLastIndex = 0;
        ensureNextElementIsReady();
    }

    protected final List<TrieNodeIterator<E>> getPath() {
        return this.path;
    }

    protected final int getPathLastIndex() {
        return this.pathLastIndex;
    }

    protected final void setPathLastIndex(int i) {
        this.pathLastIndex = i;
    }

    private final int moveToNextNodeWithData(int pathIndex) {
        if (this.path.get(pathIndex).hasNextElement()) {
            return pathIndex;
        }
        if (!this.path.get(pathIndex).hasNextNode()) {
            return -1;
        }
        TrieNode<? extends E> trieNodeCurrentNode = this.path.get(pathIndex).currentNode();
        int i = pathIndex + 1;
        if (i == this.path.size()) {
            this.path.add(new TrieNodeIterator<>());
        }
        TrieNodeIterator.reset$default(this.path.get(i), trieNodeCurrentNode.getBuffer(), 0, 2, null);
        return moveToNextNodeWithData(i);
    }

    private final void ensureNextElementIsReady() {
        if (this.path.get(this.pathLastIndex).hasNextElement()) {
            return;
        }
        int i = this.pathLastIndex;
        if (i >= 0) {
            while (true) {
                int i2 = i - 1;
                int iMoveToNextNodeWithData = moveToNextNodeWithData(i);
                if (iMoveToNextNodeWithData == -1 && this.path.get(i).hasNextCell()) {
                    this.path.get(i).moveToNextCell();
                    iMoveToNextNodeWithData = moveToNextNodeWithData(i);
                }
                if (iMoveToNextNodeWithData != -1) {
                    this.pathLastIndex = iMoveToNextNodeWithData;
                    return;
                }
                if (i > 0) {
                    this.path.get(i - 1).moveToNextCell();
                }
                this.path.get(i).reset(TrieNode.INSTANCE.getEMPTY$kotlinx_collections_immutable().getBuffer(), 0);
                if (i2 < 0) {
                    break;
                } else {
                    i = i2;
                }
            }
        }
        this.hasNext = false;
    }

    @Override
    public boolean hasNext() {
        return this.hasNext;
    }

    @Override
    public E next() {
        if (!this.hasNext) {
            throw new NoSuchElementException();
        }
        E eNextElement = this.path.get(this.pathLastIndex).nextElement();
        ensureNextElementIsReady();
        return eNextElement;
    }

    protected final E currentElement() {
        CommonFunctionsKt.m1793assert(hasNext());
        return this.path.get(this.pathLastIndex).currentElement();
    }
}
