package kotlin.comparisons;

import java.util.Comparator;
import java.util.function.Function;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000f\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0004\bÂ\u0002\u0018\u00002\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00030\u00020\u0001j\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00030\u0002`\u0004B\u0007\b\u0002¢\u0006\u0002\u0010\u0005J$\u0010\u0006\u001a\u00020\u00072\f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00030\u00022\f\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00030\u0002H\u0016J\"\u0010\n\u001a\u001e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00030\u00020\u0001j\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00030\u0002`\u0004¨\u0006\u000b"}, m18d2 = {"Lkotlin/comparisons/NaturalOrderComparator;", "Ljava/util/Comparator;", "", "", "Lkotlin/Comparator;", "()V", "compare", "", "a", "b", "reversed", "kotlin-stdlib"}, m19k = 1, m20mv = {1, 8, 0}, m22xi = 48)
final class NaturalOrderComparator implements Comparator<Comparable<? super Object>>, j$.util.Comparator {
    public static final NaturalOrderComparator INSTANCE = new NaturalOrderComparator();

    @Override
    public Comparator<Comparable<? super Object>> thenComparing(Comparator<? super Comparable<? super Object>> comparator) {
        return j$.util.Comparator.-CC.$default$thenComparing(this, comparator);
    }

    @Override
    public Comparator<Comparable<? super Object>> thenComparing(Function function) {
        return j$.util.Comparator.-CC.$default$thenComparing(this, function);
    }

    @Override
    public Comparator<Comparable<? super Object>> thenComparing(Function function, Comparator comparator) {
        return j$.util.Comparator.-CC.$default$thenComparing(this, function, comparator);
    }

    @Override
    public Comparator<Comparable<? super Object>> thenComparingDouble(ToDoubleFunction<? super Comparable<? super Object>> toDoubleFunction) {
        return j$.util.Comparator.-CC.$default$thenComparingDouble(this, toDoubleFunction);
    }

    @Override
    public Comparator<Comparable<? super Object>> thenComparingInt(ToIntFunction<? super Comparable<? super Object>> toIntFunction) {
        return j$.util.Comparator.-CC.$default$thenComparingInt(this, toIntFunction);
    }

    @Override
    public Comparator<Comparable<? super Object>> thenComparingLong(ToLongFunction<? super Comparable<? super Object>> toLongFunction) {
        return j$.util.Comparator.-CC.$default$thenComparingLong(this, toLongFunction);
    }

    private NaturalOrderComparator() {
    }

    @Override
    public int compare(Comparable<? super Object> comparable, Comparable<? super Object> comparable2) {
        return compare2((Comparable<Object>) comparable, (Comparable<Object>) comparable2);
    }

    public int compare2(Comparable<Object> a, Comparable<Object> b) {
        Intrinsics.checkNotNullParameter(a, "a");
        Intrinsics.checkNotNullParameter(b, "b");
        return a.compareTo(b);
    }

    @Override
    public final Comparator<Comparable<? super Object>> reversed() {
        return ReverseOrderComparator.INSTANCE;
    }
}
