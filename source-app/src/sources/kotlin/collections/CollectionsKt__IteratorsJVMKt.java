package kotlin.collections;

import java.util.Enumeration;
import java.util.Iterator;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.markers.KMappedMarker;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010(\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\u001f\u0010\u0000\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\u0086\u0002¨\u0006\u0004"}, m18d2 = {"iterator", "", "T", "Ljava/util/Enumeration;", "kotlin-stdlib"}, m19k = 5, m20mv = {1, 8, 0}, m22xi = 49, m23xs = "kotlin/collections/CollectionsKt")
public class CollectionsKt__IteratorsJVMKt extends CollectionsKt__IterablesKt {

    @Metadata(m17d1 = {"\u0000\u0013\n\u0000\n\u0002\u0010(\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0003*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\t\u0010\u0002\u001a\u00020\u0003H\u0096\u0002J\u000e\u0010\u0004\u001a\u00028\u0000H\u0096\u0002¢\u0006\u0002\u0010\u0005¨\u0006\u0006"}, m18d2 = {"kotlin/collections/CollectionsKt__IteratorsJVMKt$iterator$1", "", "hasNext", "", "next", "()Ljava/lang/Object;", "kotlin-stdlib"}, m19k = 1, m20mv = {1, 8, 0}, m22xi = 48)
    public static final class C00641<T> implements Iterator<T>, KMappedMarker {
        final Enumeration<T> $this_iterator;

        @Override
        public void remove() {
            throw new UnsupportedOperationException("Operation is not supported for read-only collection");
        }

        C00641(Enumeration<T> enumeration) {
            this.$this_iterator = enumeration;
        }

        @Override
        public boolean hasNext() {
            return this.$this_iterator.hasMoreElements();
        }

        @Override
        public T next() {
            return this.$this_iterator.nextElement();
        }
    }

    public static final <T> Iterator<T> iterator(Enumeration<T> enumeration) {
        Intrinsics.checkNotNullParameter(enumeration, "<this>");
        return new C00641(enumeration);
    }
}
