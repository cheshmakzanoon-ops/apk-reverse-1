package androidx.compose.p000ui.text.input;

import androidx.compose.p000ui.text.TextRange;
import androidx.compose.p000ui.text.TextRangeKt;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\u001a\"\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00012\u0006\u0010\u0003\u001a\u00020\u0001H\u0000ø\u0001\u0000¢\u0006\u0004\b\u0004\u0010\u0005\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0006"}, d2 = {"updateRangeAfterDelete", "Landroidx/compose/ui/text/TextRange;", TypedValues.AttributesType.S_TARGET, "deleted", "updateRangeAfterDelete-pWDy79M", "(JJ)J", "ui-text_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class EditingBufferKt {
    public static final long m1450updateRangeAfterDeletepWDy79M(long j, long j2) {
        int iM1282getLengthimpl;
        int iM1284getMinimpl = TextRange.m1284getMinimpl(j);
        int iM1283getMaximpl = TextRange.m1283getMaximpl(j);
        if (TextRange.m1288intersects5zctL8(j2, j)) {
            if (TextRange.m1276contains5zctL8(j2, j)) {
                iM1284getMinimpl = TextRange.m1284getMinimpl(j2);
                iM1283getMaximpl = iM1284getMinimpl;
            } else {
                if (TextRange.m1276contains5zctL8(j, j2)) {
                    iM1282getLengthimpl = TextRange.m1282getLengthimpl(j2);
                } else if (TextRange.m1277containsimpl(j2, iM1284getMinimpl)) {
                    iM1284getMinimpl = TextRange.m1284getMinimpl(j2);
                    iM1282getLengthimpl = TextRange.m1282getLengthimpl(j2);
                } else {
                    iM1283getMaximpl = TextRange.m1284getMinimpl(j2);
                }
                iM1283getMaximpl -= iM1282getLengthimpl;
            }
        } else if (iM1283getMaximpl > TextRange.m1284getMinimpl(j2)) {
            iM1284getMinimpl -= TextRange.m1282getLengthimpl(j2);
            iM1282getLengthimpl = TextRange.m1282getLengthimpl(j2);
            iM1283getMaximpl -= iM1282getLengthimpl;
        }
        return TextRangeKt.TextRange(iM1284getMinimpl, iM1283getMaximpl);
    }
}
