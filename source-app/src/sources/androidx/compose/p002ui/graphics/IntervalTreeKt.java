package androidx.compose.p002ui.graphics;

import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0003\"\u001c\u0010\u0000\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u00020\u0001X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0003\u0010\u0004¨\u0006\u0005"}, d2 = {"EmptyInterval", "Landroidx/compose/ui/graphics/Interval;", "", "getEmptyInterval", "()Landroidx/compose/ui/graphics/Interval;", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class IntervalTreeKt {
    private static final Interval<Object> EmptyInterval = new Interval<>(Float.MAX_VALUE, Float.MIN_VALUE, null);

    public static final Interval<Object> getEmptyInterval() {
        return EmptyInterval;
    }
}
