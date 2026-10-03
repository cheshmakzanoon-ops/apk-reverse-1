package kotlinx.collections.immutable.implementations.immutableMap;

import cz.msebera.android.httpclient.cookie.ClientCookie;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.markers.KMutableIterator;

@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010)\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0010\u0018\u0000*\u0004\b\u0000\u0010\u0001*\u0004\b\u0001\u0010\u0002*\u0004\b\u0002\u0010\u00032\b\u0012\u0004\u0012\u0002H\u00030\u00042\u0014\u0012\u0004\u0012\u0002H\u0001\u0012\u0004\u0012\u0002H\u0002\u0012\u0004\u0012\u0002H\u00030\u0005B9\u0012\u0012\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0007\u0012\u001e\u0010\b\u001a\u001a\u0012\u0016\u0012\u0014\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u0001\u0012\u0004\u0012\u00028\u00020\n0\t¢\u0006\u0002\u0010\u000bJ\b\u0010\u0012\u001a\u00020\u0013H\u0002J\b\u0010\u0014\u001a\u00020\u0013H\u0002J\u000e\u0010\u0015\u001a\u00028\u0002H\u0096\u0002¢\u0006\u0002\u0010\u0016J\b\u0010\u0017\u001a\u00020\u0013H\u0016J5\u0010\u0018\u001a\u00020\u00132\u0006\u0010\u0019\u001a\u00020\r2\u000e\u0010\u001a\u001a\n\u0012\u0002\b\u0003\u0012\u0002\b\u00030\u001b2\u0006\u0010\u001c\u001a\u00028\u00002\u0006\u0010\u001d\u001a\u00020\rH\u0002¢\u0006\u0002\u0010\u001eJ\u001b\u0010\u001f\u001a\u00020\u00132\u0006\u0010\u001c\u001a\u00028\u00002\u0006\u0010 \u001a\u00028\u0001¢\u0006\u0002\u0010!R\u001a\u0010\u0006\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00028\u00010\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u0012\u0010\u000e\u001a\u0004\u0018\u00018\u0000X\u0082\u000e¢\u0006\u0004\n\u0002\u0010\u000fR\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\""}, m18d2 = {"Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilderBaseIterator;", "K", "V", "T", "", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBaseIterator;", "builder", "Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;", ClientCookie.PATH_ATTR, "", "Lkotlinx/collections/immutable/implementations/immutableMap/TrieNodeBaseIterator;", "(Lkotlinx/collections/immutable/implementations/immutableMap/PersistentHashMapBuilder;[Lkotlinx/collections/immutable/implementations/immutableMap/TrieNodeBaseIterator;)V", "expectedModCount", "", "lastIteratedKey", "Ljava/lang/Object;", "nextWasInvoked", "", "checkForComodification", "", "checkNextWasInvoked", "next", "()Ljava/lang/Object;", "remove", "resetPath", "keyHash", "node", "Lkotlinx/collections/immutable/implementations/immutableMap/TrieNode;", "key", "pathIndex", "(ILkotlinx/collections/immutable/implementations/immutableMap/TrieNode;Ljava/lang/Object;I)V", "setValue", "newValue", "(Ljava/lang/Object;Ljava/lang/Object;)V", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public class PersistentHashMapBuilderBaseIterator<K, V, T> extends PersistentHashMapBaseIterator<K, V, T> implements Iterator<T>, KMutableIterator {
    private final PersistentHashMapBuilder<K, V> builder;
    private int expectedModCount;
    private K lastIteratedKey;
    private boolean nextWasInvoked;

    public PersistentHashMapBuilderBaseIterator(PersistentHashMapBuilder<K, V> builder, TrieNodeBaseIterator<K, V, T>[] path) {
        super(builder.getNode$kotlinx_collections_immutable(), path);
        Intrinsics.checkNotNullParameter(builder, "builder");
        Intrinsics.checkNotNullParameter(path, "path");
        this.builder = builder;
        this.expectedModCount = builder.getModCount();
    }

    @Override
    public T next() {
        checkForComodification();
        this.lastIteratedKey = currentKey();
        this.nextWasInvoked = true;
        return (T) super.next();
    }

    @Override
    public void remove() {
        checkNextWasInvoked();
        if (getHasNext()) {
            K kCurrentKey = currentKey();
            this.builder.remove(this.lastIteratedKey);
            resetPath(kCurrentKey == null ? 0 : kCurrentKey.hashCode(), this.builder.getNode$kotlinx_collections_immutable(), kCurrentKey, 0);
        } else {
            this.builder.remove(this.lastIteratedKey);
        }
        this.lastIteratedKey = null;
        this.nextWasInvoked = false;
        this.expectedModCount = this.builder.getModCount();
    }

    public final void setValue(K key, V newValue) {
        if (this.builder.containsKey(key)) {
            if (getHasNext()) {
                K kCurrentKey = currentKey();
                this.builder.put(key, newValue);
                resetPath(kCurrentKey == null ? 0 : kCurrentKey.hashCode(), this.builder.getNode$kotlinx_collections_immutable(), kCurrentKey, 0);
            } else {
                this.builder.put(key, newValue);
            }
            this.expectedModCount = this.builder.getModCount();
        }
    }

    private final void resetPath(int keyHash, TrieNode<?, ?> node, K key, int pathIndex) {
        int i = pathIndex * 5;
        if (i > 30) {
            getPath()[pathIndex].reset(node.getBuffer(), node.getBuffer().length, 0);
            while (!Intrinsics.areEqual(getPath()[pathIndex].currentKey(), key)) {
                getPath()[pathIndex].moveToNextKey();
            }
            setPathLastIndex(pathIndex);
            return;
        }
        int iIndexSegment = 1 << TrieNodeKt.indexSegment(keyHash, i);
        if (node.hasEntryAt$kotlinx_collections_immutable(iIndexSegment)) {
            getPath()[pathIndex].reset(node.getBuffer(), node.entryCount$kotlinx_collections_immutable() * 2, node.entryKeyIndex$kotlinx_collections_immutable(iIndexSegment));
            setPathLastIndex(pathIndex);
        } else {
            int iNodeIndex$kotlinx_collections_immutable = node.nodeIndex$kotlinx_collections_immutable(iIndexSegment);
            TrieNode<?, ?> trieNodeNodeAtIndex$kotlinx_collections_immutable = node.nodeAtIndex$kotlinx_collections_immutable(iNodeIndex$kotlinx_collections_immutable);
            getPath()[pathIndex].reset(node.getBuffer(), node.entryCount$kotlinx_collections_immutable() * 2, iNodeIndex$kotlinx_collections_immutable);
            resetPath(keyHash, trieNodeNodeAtIndex$kotlinx_collections_immutable, key, pathIndex + 1);
        }
    }

    private final void checkNextWasInvoked() {
        if (!this.nextWasInvoked) {
            throw new IllegalStateException();
        }
    }

    private final void checkForComodification() {
        if (this.builder.getModCount() != this.expectedModCount) {
            throw new ConcurrentModificationException();
        }
    }
}
