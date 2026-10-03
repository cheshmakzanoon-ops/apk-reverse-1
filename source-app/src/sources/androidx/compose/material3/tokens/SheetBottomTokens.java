package androidx.compose.material3.tokens;

import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u000e\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u000b\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\u0006R\u0019\u0010\r\u001a\u00020\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0011\u001a\u0004\b\u000f\u0010\u0010R\u0019\u0010\u0012\u001a\u00020\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0011\u001a\u0004\b\u0013\u0010\u0010R\u0011\u0010\u0014\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\nR\u0019\u0010\u0016\u001a\u00020\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0011\u001a\u0004\b\u0017\u0010\u0010R\u0019\u0010\u0018\u001a\u00020\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u0011\u001a\u0004\b\u0019\u0010\u0010R\u0011\u0010\u001a\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0006\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001c"}, d2 = {"Landroidx/compose/material3/tokens/SheetBottomTokens;", "", "()V", "DockedContainerColor", "Landroidx/compose/material3/tokens/ColorSchemeKeyTokens;", "getDockedContainerColor", "()Landroidx/compose/material3/tokens/ColorSchemeKeyTokens;", "DockedContainerShape", "Landroidx/compose/material3/tokens/ShapeKeyTokens;", "getDockedContainerShape", "()Landroidx/compose/material3/tokens/ShapeKeyTokens;", "DockedDragHandleColor", "getDockedDragHandleColor", "DockedDragHandleHeight", "Landroidx/compose/ui/unit/Dp;", "getDockedDragHandleHeight-D9Ej5fM", "()F", "F", "DockedDragHandleWidth", "getDockedDragHandleWidth-D9Ej5fM", "DockedMinimizedContainerShape", "getDockedMinimizedContainerShape", "DockedModalContainerElevation", "getDockedModalContainerElevation-D9Ej5fM", "DockedStandardContainerElevation", "getDockedStandardContainerElevation-D9Ej5fM", "FocusIndicatorColor", "getFocusIndicatorColor", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SheetBottomTokens {
    public static final int $stable = 0;
    public static final SheetBottomTokens INSTANCE = new SheetBottomTokens();
    private static final ColorSchemeKeyTokens DockedContainerColor = ColorSchemeKeyTokens.SurfaceContainerLow;
    private static final ShapeKeyTokens DockedContainerShape = ShapeKeyTokens.CornerExtraLargeTop;
    private static final ColorSchemeKeyTokens DockedDragHandleColor = ColorSchemeKeyTokens.OnSurfaceVariant;
    private static final float DockedDragHandleHeight = Dp.constructor-impl((float) 4.0d);
    private static final float DockedDragHandleWidth = Dp.constructor-impl((float) 32.0d);
    private static final ShapeKeyTokens DockedMinimizedContainerShape = ShapeKeyTokens.CornerNone;
    private static final float DockedModalContainerElevation = ElevationTokens.INSTANCE.m3538getLevel1D9Ej5fM();
    private static final float DockedStandardContainerElevation = ElevationTokens.INSTANCE.m3538getLevel1D9Ej5fM();
    private static final ColorSchemeKeyTokens FocusIndicatorColor = ColorSchemeKeyTokens.Secondary;

    private SheetBottomTokens() {
    }

    public final ColorSchemeKeyTokens getDockedContainerColor() {
        return DockedContainerColor;
    }

    public final ShapeKeyTokens getDockedContainerShape() {
        return DockedContainerShape;
    }

    public final ColorSchemeKeyTokens getDockedDragHandleColor() {
        return DockedDragHandleColor;
    }

    public final float m3846getDockedDragHandleHeightD9Ej5fM() {
        return DockedDragHandleHeight;
    }

    public final float m3847getDockedDragHandleWidthD9Ej5fM() {
        return DockedDragHandleWidth;
    }

    public final ShapeKeyTokens getDockedMinimizedContainerShape() {
        return DockedMinimizedContainerShape;
    }

    public final float m3848getDockedModalContainerElevationD9Ej5fM() {
        return DockedModalContainerElevation;
    }

    public final float m3849getDockedStandardContainerElevationD9Ej5fM() {
        return DockedStandardContainerElevation;
    }

    public final ColorSchemeKeyTokens getFocusIndicatorColor() {
        return FocusIndicatorColor;
    }
}
