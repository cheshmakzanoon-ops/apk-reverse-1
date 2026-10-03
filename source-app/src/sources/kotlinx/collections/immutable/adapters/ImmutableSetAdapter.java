package kotlinx.collections.immutable.adapters;

import j$.util.Set;
import j$.util.Spliterator;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.collections.immutable.ImmutableSet;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\"\n\u0002\b\u0002\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003B\u0013\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, m18d2 = {"Lkotlinx/collections/immutable/adapters/ImmutableSetAdapter;", "E", "Lkotlinx/collections/immutable/ImmutableSet;", "Lkotlinx/collections/immutable/adapters/ImmutableCollectionAdapter;", "impl", "", "(Ljava/util/Set;)V", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public final class ImmutableSetAdapter<E> extends ImmutableCollectionAdapter<E> implements ImmutableSet<E>, Set {
    @Override
    public Spliterator spliterator() {
        return Set.-CC.$default$spliterator(this);
    }

    @Override
    public java.util.Spliterator spliterator() {
        return Spliterator.Wrapper.convert(spliterator());
    }

    public ImmutableSetAdapter(java.util.Set<? extends E> impl) {
        super(impl);
        Intrinsics.checkNotNullParameter(impl, "impl");
    }
}
