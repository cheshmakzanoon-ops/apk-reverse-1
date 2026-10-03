package androidx.compose.foundation.lazy.staggeredgrid;

import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Lambda;

@Metadata(d1 = {"\u0000\u0010\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u00020\u0004H\n¢\u0006\u0002\b\u0005"}, d2 = {"<anonymous>", "Landroidx/compose/foundation/lazy/staggeredgrid/StaggeredGridItemSpan;", "T", "index", "", "invoke"}, k = 3, mv = {1, 8, 0}, xi = 176)
final class LazyStaggeredGridDslKt$items$4$1 extends Lambda implements Function1<Integer, StaggeredGridItemSpan> {
    final List<T> $items;
    final Function1<T, StaggeredGridItemSpan> $span;

    public LazyStaggeredGridDslKt$items$4$1(Function1<? super T, StaggeredGridItemSpan> function1, List<? extends T> list) {
        super(1);
        this.$span = function1;
        this.$items = list;
    }

    public final StaggeredGridItemSpan invoke(int i) {
        return (StaggeredGridItemSpan) this.$span.invoke(this.$items.get(i));
    }

    public Object invoke(Object obj) {
        return invoke(((Number) obj).intValue());
    }
}
