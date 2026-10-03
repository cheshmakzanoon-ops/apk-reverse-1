package kotlin.comparisons;

import java.util.Comparator;
import java.util.function.Function;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\u0005\b\u0002\u0018\u0000*\u0004\b\u0000\u0010\u00012\u0012\u0012\u0004\u0012\u0002H\u00010\u0002j\b\u0012\u0004\u0012\u0002H\u0001`\u0003B\u001d\u0012\u0016\u0010\u0004\u001a\u0012\u0012\u0004\u0012\u00028\u00000\u0002j\b\u0012\u0004\u0012\u00028\u0000`\u0003¢\u0006\u0002\u0010\u0005J\u001d\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00028\u00002\u0006\u0010\u000b\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\fJ\u0016\u0010\r\u001a\u0012\u0012\u0004\u0012\u00028\u00000\u0002j\b\u0012\u0004\u0012\u00028\u0000`\u0003R!\u0010\u0004\u001a\u0012\u0012\u0004\u0012\u00028\u00000\u0002j\b\u0012\u0004\u0012\u00028\u0000`\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u000e"}, m18d2 = {"Lkotlin/comparisons/ReversedComparator;", "T", "Ljava/util/Comparator;", "Lkotlin/Comparator;", "comparator", "(Ljava/util/Comparator;)V", "getComparator", "()Ljava/util/Comparator;", "compare", "", "a", "b", "(Ljava/lang/Object;Ljava/lang/Object;)I", "reversed", "kotlin-stdlib"}, m19k = 1, m20mv = {1, 8, 0}, m22xi = 48)
final class ReversedComparator<T> implements Comparator<T>, j$.util.Comparator {
    private final Comparator<T> comparator;

    @Override
    public Comparator thenComparing(Comparator comparator) {
        return j$.util.Comparator.-CC.$default$thenComparing(this, comparator);
    }

    @Override
    public Comparator thenComparing(Function function) {
        return j$.util.Comparator.-CC.$default$thenComparing(this, function);
    }

    @Override
    public Comparator thenComparing(Function function, Comparator comparator) {
        return j$.util.Comparator.-CC.$default$thenComparing(this, function, comparator);
    }

    @Override
    public Comparator thenComparingDouble(ToDoubleFunction toDoubleFunction) {
        return j$.util.Comparator.-CC.$default$thenComparingDouble(this, toDoubleFunction);
    }

    @Override
    public Comparator thenComparingInt(ToIntFunction toIntFunction) {
        return j$.util.Comparator.-CC.$default$thenComparingInt(this, toIntFunction);
    }

    @Override
    public Comparator thenComparingLong(ToLongFunction toLongFunction) {
        return j$.util.Comparator.-CC.$default$thenComparingLong(this, toLongFunction);
    }

    public ReversedComparator(Comparator<T> comparator) {
        Intrinsics.checkNotNullParameter(comparator, "comparator");
        this.comparator = comparator;
    }

    public final Comparator<T> getComparator() {
        return this.comparator;
    }

    @Override
    public int compare(T a, T b) {
        return this.comparator.compare(b, a);
    }

    @Override
    public final Comparator<T> reversed() {
        return this.comparator;
    }
}
