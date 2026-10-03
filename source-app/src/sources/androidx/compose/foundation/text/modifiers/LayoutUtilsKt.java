package androidx.compose.foundation.text.modifiers;

import androidx.compose.foundation.text.TextDelegateKt;
import androidx.compose.ui.text.style.TextOverflow;
import androidx.compose.ui.unit.Constraints;
import kotlin.Metadata;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000&\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0007\u001a2\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0000ø\u0001\u0000¢\u0006\u0004\b\t\u0010\n\u001a*\u0010\u000b\u001a\u00020\f2\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\fH\u0000ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000f\u001a2\u0010\u0010\u001a\u00020\f2\u0006\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0000ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0013"}, d2 = {"finalConstraints", "Landroidx/compose/ui/unit/Constraints;", "constraints", "softWrap", "", "overflow", "Landroidx/compose/ui/text/style/TextOverflow;", "maxIntrinsicWidth", "", "finalConstraints-tfFHcEY", "(JZIF)J", "finalMaxLines", "", "maxLinesIn", "finalMaxLines-xdlQI24", "(ZII)I", "finalMaxWidth", "finalMaxWidth-tfFHcEY", "(JZIF)I", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class LayoutUtilsKt {
    public static final long m1820finalConstraintstfFHcEY(long j, boolean z, int i, float f) {
        return Constraints.Companion.fitPrioritizingWidth-Zbe2FdA(0, m1822finalMaxWidthtfFHcEY(j, z, i, f), 0, Constraints.getMaxHeight-impl(j));
    }

    public static final int m1822finalMaxWidthtfFHcEY(long j, boolean z, int i, float f) {
        int i2 = ((z || TextOverflow.equals-impl0(i, TextOverflow.Companion.getEllipsis-gIe3tQ8())) && Constraints.getHasBoundedWidth-impl(j)) ? Constraints.getMaxWidth-impl(j) : Integer.MAX_VALUE;
        return Constraints.getMinWidth-impl(j) == i2 ? i2 : RangesKt.coerceIn(TextDelegateKt.ceilToIntPx(f), Constraints.getMinWidth-impl(j), i2);
    }

    public static final int m1821finalMaxLinesxdlQI24(boolean z, int i, int i2) {
        if (z || !TextOverflow.equals-impl0(i, TextOverflow.Companion.getEllipsis-gIe3tQ8())) {
            return RangesKt.coerceAtLeast(i2, 1);
        }
        return 1;
    }
}
