package kotlinx.collections.immutable;

import java.util.Collection;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.markers.KMutableCollection;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u001e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u0003\bf\u0018\u0000*\u0006\b\u0000\u0010\u0001 \u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002:\u0001\u0012J\u001b\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u0004\u001a\u00028\u0000H&¢\u0006\u0002\u0010\u0005J\u001c\u0010\u0006\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00000\bH&J\u000e\u0010\t\u001a\b\u0012\u0004\u0012\u00028\u00000\nH&J\u000e\u0010\u000b\u001a\b\u0012\u0004\u0012\u00028\u00000\u0000H&J\u001b\u0010\f\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0006\u0010\u0004\u001a\u00028\u0000H&¢\u0006\u0002\u0010\u0005J\"\u0010\r\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\u0012\u0010\u000e\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00020\u00100\u000fH&J\u001c\u0010\r\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00000\bH&J\u001c\u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u00000\u00002\f\u0010\u0007\u001a\b\u0012\u0004\u0012\u00028\u00000\bH&¨\u0006\u0013"}, m18d2 = {"Lkotlinx/collections/immutable/PersistentCollection;", "E", "Lkotlinx/collections/immutable/ImmutableCollection;", "add", "element", "(Ljava/lang/Object;)Lkotlinx/collections/immutable/PersistentCollection;", "addAll", "elements", "", "builder", "Lkotlinx/collections/immutable/PersistentCollection$Builder;", "clear", "remove", "removeAll", "predicate", "Lkotlin/Function1;", "", "retainAll", "Builder", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
public interface PersistentCollection<E> extends ImmutableCollection<E> {

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u001f\n\u0000\n\u0002\u0018\u0002\n\u0000\bf\u0018\u0000*\u0004\b\u0001\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002J\u000e\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00010\u0004H&¨\u0006\u0005"}, m18d2 = {"Lkotlinx/collections/immutable/PersistentCollection$Builder;", "E", "", "build", "Lkotlinx/collections/immutable/PersistentCollection;", "kotlinx-collections-immutable"}, m19k = 1, m20mv = {1, 6, 0}, m22xi = 48)
    public interface Builder<E> extends Collection<E>, KMutableCollection {
        PersistentCollection<E> build();
    }

    @Override
    PersistentCollection<E> add(E element);

    @Override
    PersistentCollection<E> addAll(Collection<? extends E> elements);

    Builder<E> builder();

    @Override
    PersistentCollection<E> clear();

    @Override
    PersistentCollection<E> remove(E element);

    @Override
    PersistentCollection<E> removeAll(Collection<? extends E> elements);

    PersistentCollection<E> removeAll(Function1<? super E, Boolean> predicate);

    @Override
    PersistentCollection<E> retainAll(Collection<? extends E> elements);
}
