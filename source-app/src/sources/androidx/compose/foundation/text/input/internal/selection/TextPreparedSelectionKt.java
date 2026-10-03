package androidx.compose.foundation.text.input.internal.selection;

import androidx.compose.foundation.text.StringHelpers_androidKt;
import androidx.compose.foundation.text.input.internal.IndexTransformationType;
import androidx.compose.foundation.text.input.internal.SelectionWedgeAffinity;
import androidx.compose.foundation.text.input.internal.TransformedTextFieldState;
import androidx.compose.foundation.text.input.internal.WedgeAffinity;
import androidx.compose.ui.text.TextRange;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;

@Metadata(d1 = {"\u0000\u001c\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a(\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00012\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0001¨\u0006\t"}, d2 = {"calculateAdjacentCursorPosition", "", "transformedText", "", "cursor", "forward", "", "state", "Landroidx/compose/foundation/text/input/internal/TransformedTextFieldState;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TextPreparedSelectionKt {

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[IndexTransformationType.values().length];
            try {
                iArr[IndexTransformationType.Untransformed.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[IndexTransformationType.Deletion.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[IndexTransformationType.Replacement.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                iArr[IndexTransformationType.Insertion.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            $EnumSwitchMapping$0 = iArr;
        }
    }

    public static final int calculateAdjacentCursorPosition(String str, int i, boolean z, TransformedTextFieldState transformedTextFieldState) throws NoWhenBranchMatchedException {
        int iFindPrecedingBreak;
        IndexTransformationType indexTransformationType;
        if (z) {
            iFindPrecedingBreak = StringHelpers_androidKt.findFollowingBreak(str, i);
        } else {
            iFindPrecedingBreak = StringHelpers_androidKt.findPrecedingBreak(str, i);
        }
        if (iFindPrecedingBreak == -1) {
            return i;
        }
        long jM1721mapFromTransformedjx7JFs = transformedTextFieldState.m1721mapFromTransformedjx7JFs(iFindPrecedingBreak);
        long jM1724mapToTransformedGEjPoXI = transformedTextFieldState.m1724mapToTransformedGEjPoXI(jM1721mapFromTransformedjx7JFs);
        if (TextRange.getCollapsed-impl(jM1721mapFromTransformedjx7JFs) && TextRange.getCollapsed-impl(jM1724mapToTransformedGEjPoXI)) {
            indexTransformationType = IndexTransformationType.Untransformed;
        } else if (!TextRange.getCollapsed-impl(jM1721mapFromTransformedjx7JFs) && !TextRange.getCollapsed-impl(jM1724mapToTransformedGEjPoXI)) {
            indexTransformationType = IndexTransformationType.Replacement;
        } else if (TextRange.getCollapsed-impl(jM1721mapFromTransformedjx7JFs) && !TextRange.getCollapsed-impl(jM1724mapToTransformedGEjPoXI)) {
            indexTransformationType = IndexTransformationType.Insertion;
        } else {
            indexTransformationType = IndexTransformationType.Deletion;
        }
        int i2 = WhenMappings.$EnumSwitchMapping$0[indexTransformationType.ordinal()];
        if (i2 == 1 || i2 == 2) {
            return iFindPrecedingBreak;
        }
        if (i2 == 3) {
            return z ? TextRange.getEnd-impl(jM1724mapToTransformedGEjPoXI) : TextRange.getStart-impl(jM1724mapToTransformedGEjPoXI);
        }
        if (i2 != 4) {
            throw new NoWhenBranchMatchedException();
        }
        if (z) {
            if (iFindPrecedingBreak == TextRange.getStart-impl(jM1724mapToTransformedGEjPoXI)) {
                transformedTextFieldState.setSelectionWedgeAffinity(new SelectionWedgeAffinity(WedgeAffinity.Start));
                return iFindPrecedingBreak;
            }
            transformedTextFieldState.setSelectionWedgeAffinity(new SelectionWedgeAffinity(WedgeAffinity.End));
            return i;
        }
        if (iFindPrecedingBreak == TextRange.getEnd-impl(jM1724mapToTransformedGEjPoXI)) {
            transformedTextFieldState.setSelectionWedgeAffinity(new SelectionWedgeAffinity(WedgeAffinity.End));
            return iFindPrecedingBreak;
        }
        transformedTextFieldState.setSelectionWedgeAffinity(new SelectionWedgeAffinity(WedgeAffinity.Start));
        return i;
    }
}
