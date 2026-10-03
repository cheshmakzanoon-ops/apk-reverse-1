package androidx.compose.foundation.text.input.internal;

import androidx.compose.ui.text.TextRange;
import androidx.compose.ui.text.TextRangeKt;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a\"\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u0001H\u0000ø\u0001\u0000¢\u0006\u0004\b\u0004\u0010\u0005\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0006"}, d2 = {"updateRangeAfterDelete", "Landroidx/compose/ui/text/TextRange;", "target", "deleted", "updateRangeAfterDelete-pWDy79M", "(JJ)J", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class EditingBufferKt {
    public static final long m1619updateRangeAfterDeletepWDy79M(long j, long j2) {
        int i;
        int i2 = TextRange.getMin-impl(j);
        int i3 = TextRange.getMax-impl(j);
        if (TextRange.intersects-5zc-tL8(j2, j)) {
            if (TextRange.contains-5zc-tL8(j2, j)) {
                i2 = TextRange.getMin-impl(j2);
                i3 = i2;
            } else {
                if (TextRange.contains-5zc-tL8(j, j2)) {
                    i = TextRange.getLength-impl(j2);
                } else if (TextRange.contains-impl(j2, i2)) {
                    i2 = TextRange.getMin-impl(j2);
                    i = TextRange.getLength-impl(j2);
                } else {
                    i3 = TextRange.getMin-impl(j2);
                }
                i3 -= i;
            }
        } else if (i3 > TextRange.getMin-impl(j2)) {
            i2 -= TextRange.getLength-impl(j2);
            i = TextRange.getLength-impl(j2);
            i3 -= i;
        }
        return TextRangeKt.TextRange(i2, i3);
    }
}
