package androidx.compose.foundation.text.handwriting;

import androidx.compose.foundation.layout.PaddingKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;

@Metadata(d1 = {"\u0000\u001c\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\"\u0010\u0007\u001a\u00020\b*\u00020\b2\u0006\u0010\t\u001a\u00020\n2\f\u0010\u000b\u001a\b\u0012\u0004\u0012\u00020\n0\fH\u0000\"\u0016\u0010\u0000\u001a\u00020\u0001X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0002\u0010\u0003\"\u0016\u0010\u0005\u001a\u00020\u0001X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0004\u001a\u0004\b\u0006\u0010\u0003¨\u0006\r"}, d2 = {"HandwritingBoundsHorizontalOffset", "Landroidx/compose/ui/unit/Dp;", "getHandwritingBoundsHorizontalOffset", "()F", "F", "HandwritingBoundsVerticalOffset", "getHandwritingBoundsVerticalOffset", "stylusHandwriting", "Landroidx/compose/ui/Modifier;", "enabled", "", "onHandwritingSlopExceeded", "Lkotlin/Function0;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class StylusHandwritingKt {
    private static final float HandwritingBoundsVerticalOffset = Dp.constructor-impl(40);
    private static final float HandwritingBoundsHorizontalOffset = Dp.constructor-impl(10);

    public static final Modifier stylusHandwriting(Modifier modifier, boolean z, Function0<Boolean> function0) {
        return (z && StylusHandwriting_androidKt.isStylusHandwritingSupported()) ? PaddingKt.m1036paddingVpY3zN4(modifier.then(new StylusHandwritingElementWithNegativePadding(function0)), HandwritingBoundsHorizontalOffset, HandwritingBoundsVerticalOffset) : modifier;
    }

    public static final float getHandwritingBoundsVerticalOffset() {
        return HandwritingBoundsVerticalOffset;
    }

    public static final float getHandwritingBoundsHorizontalOffset() {
        return HandwritingBoundsHorizontalOffset;
    }
}
