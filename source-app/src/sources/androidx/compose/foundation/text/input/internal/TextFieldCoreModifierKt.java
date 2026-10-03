package androidx.compose.foundation.text.input.internal;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.graphics.Brush;
import androidx.compose.p002ui.graphics.SolidColor;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000.\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0007\n\u0000\u001a$\u0010\u0007\u001a\u00020\b*\u00020\t2\u0006\u0010\n\u001a\u00020\b2\u0006\u0010\u000b\u001a\u00020\u00042\u0006\u0010\f\u001a\u00020\rH\u0002\u001a\f\u0010\u000e\u001a\u00020\u000f*\u00020\u000fH\u0002\"\u0010\u0010\u0000\u001a\u00020\u0001X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\u0002\"\u0018\u0010\u0003\u001a\u00020\u0004*\u00020\u00058BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0003\u0010\u0006¨\u0006\u0010"}, d2 = {"DefaultCursorThickness", "Landroidx/compose/ui/unit/Dp;", "F", "isSpecified", "", "Landroidx/compose/ui/graphics/Brush;", "(Landroidx/compose/ui/graphics/Brush;)Z", "getCursorRectInScroller", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/ui/unit/Density;", "cursorRect", "rtl", "textLayoutSize", "", "roundToNext", "", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class TextFieldCoreModifierKt {
    private static final float DefaultCursorThickness = Dp.constructor-impl(2);

    public static final boolean isSpecified(Brush brush) {
        return ((brush instanceof SolidColor) && ((SolidColor) brush).getValue() == 16) ? false : true;
    }

    public static final Rect getCursorRectInScroller(Density density, Rect rect, boolean z, int i) {
        float left;
        float left2;
        int i2 = density.roundToPx-0680j_4(DefaultCursorThickness);
        if (z) {
            left = i - rect.getRight();
        } else {
            left = rect.getLeft();
        }
        float f = left;
        if (z) {
            left2 = i - rect.getRight();
        } else {
            left2 = rect.getLeft();
        }
        return Rect.copy$default(rect, f, 0.0f, left2 + i2, 0.0f, 10, null);
    }

    public static final float roundToNext(float f) {
        double dFloor;
        if (Float.isNaN(f) || Float.isInfinite(f)) {
            return f;
        }
        if (f > 0.0f) {
            dFloor = Math.ceil(f);
        } else {
            dFloor = Math.floor(f);
        }
        return (float) dFloor;
    }
}
