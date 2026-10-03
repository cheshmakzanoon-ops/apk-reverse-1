package kotlinx.collections.immutable;

import java.util.List;
import kotlin.Metadata;
import kotlin.collections.AbstractList;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.markers.KMappedMarker;
import kotlinx.collections.immutable.internal.ListImplementation;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\bf\u0018\u0000*\u0006\b\u0000\u0010\u0001 \u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003:\u0001\bJ\u001e\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u0006H\u0016¨\u0006\t"}, m18d2 = {"Lkotlinx/collections/immutable/ImmutableList;", "E", "", "Lkotlinx/collections/immutable/ImmutableCollection;", "subList", "fromIndex", "", "toIndex", "SubList", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public interface ImmutableList<E> extends List<E>, ImmutableCollection<E>, KMappedMarker {
    @Override
    ImmutableList<E> subList(int fromIndex, int toIndex);

    @Metadata(m19k = 3, m20mv = {1, 6, 0}, m22xi = 48)
    public static final class DefaultImpls {
        public static <E> ImmutableList<E> subList(ImmutableList<? extends E> immutableList, int i, int i2) {
            Intrinsics.checkNotNullParameter(immutableList, "this");
            return new SubList(immutableList, i, i2);
        }
    }

    @Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u000b\b\u0002\u0018\u0000*\u0004\b\u0001\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003B#\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00010\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\u0006¢\u0006\u0002\u0010\bJ\u0016\u0010\r\u001a\u00028\u00012\u0006\u0010\u000e\u001a\u00020\u0006H\u0096\u0002¢\u0006\u0002\u0010\u000fJ\u001e\u0010\u0010\u001a\b\u0012\u0004\u0012\u00028\u00010\u00022\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u0006H\u0016R\u000e\u0010\t\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\n\u001a\u00020\u00068VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u000b\u0010\fR\u0014\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00010\u0002X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lkotlinx/collections/immutable/ImmutableList$SubList;", "E", "Lkotlinx/collections/immutable/ImmutableList;", "Lkotlin/collections/AbstractList;", "source", "fromIndex", "", "toIndex", "(Lkotlinx/collections/immutable/ImmutableList;II)V", "_size", "size", "getSize", "()I", "get", "index", "(I)Ljava/lang/Object;", "subList", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
    private static final class SubList<E> extends AbstractList<E> implements ImmutableList<E> {
        private int _size;
        private final int fromIndex;
        private final ImmutableList<E> source;
        private final int toIndex;

        public SubList(ImmutableList<? extends E> source, int i, int i2) {
            Intrinsics.checkNotNullParameter(source, "source");
            this.source = source;
            this.fromIndex = i;
            this.toIndex = i2;
            ListImplementation.checkRangeIndexes$kotlinx_collections_immutable(i, i2, source.size());
            this._size = i2 - i;
        }

        @Override
        public E get(int index) {
            ListImplementation.checkElementIndex$kotlinx_collections_immutable(index, this._size);
            return this.source.get(this.fromIndex + index);
        }

        @Override
        public int get_size() {
            return this._size;
        }

        @Override
        public ImmutableList<E> subList(int fromIndex, int toIndex) {
            ListImplementation.checkRangeIndexes$kotlinx_collections_immutable(fromIndex, toIndex, this._size);
            ImmutableList<E> immutableList = this.source;
            int i = this.fromIndex;
            return new SubList(immutableList, fromIndex + i, i + toIndex);
        }
    }
}
