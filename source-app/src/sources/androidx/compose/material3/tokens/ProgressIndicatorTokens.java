package androidx.compose.material3.tokens;

import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0014\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u0011\u0010\u0003\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0019\u0010\u000b\u001a\u00020\fø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\r\u0010\u000eR\u0019\u0010\u0010\u001a\u00020\fø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\u0011\u0010\u000eR\u0019\u0010\u0012\u001a\u00020\fø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\u0013\u0010\u000eR\u0011\u0010\u0014\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0006R\u0019\u0010\u0016\u001a\u00020\fø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\u0017\u0010\u000eR\u0019\u0010\u0018\u001a\u00020\fø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\u0019\u0010\u000eR\u0011\u0010\u001a\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0006R\u0011\u0010\u001c\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\nR\u0019\u0010\u001e\u001a\u00020\fø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010\u000f\u001a\u0004\b\u001f\u0010\u000e\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006 "}, d2 = {"Landroidx/compose/material3/tokens/ProgressIndicatorTokens;", "", "()V", "ActiveIndicatorColor", "Landroidx/compose/material3/tokens/ColorSchemeKeyTokens;", "getActiveIndicatorColor", "()Landroidx/compose/material3/tokens/ColorSchemeKeyTokens;", "ActiveShape", "Landroidx/compose/material3/tokens/ShapeKeyTokens;", "getActiveShape", "()Landroidx/compose/material3/tokens/ShapeKeyTokens;", "ActiveThickness", "Landroidx/compose/ui/unit/Dp;", "getActiveThickness-D9Ej5fM", "()F", "F", "ActiveTrackSpace", "getActiveTrackSpace-D9Ej5fM", "Size", "getSize-D9Ej5fM", "StopColor", "getStopColor", "StopShape", "getStopShape-D9Ej5fM", "StopSize", "getStopSize-D9Ej5fM", "TrackColor", "getTrackColor", "TrackShape", "getTrackShape", "TrackThickness", "getTrackThickness-D9Ej5fM", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ProgressIndicatorTokens {
    public static final int $stable = 0;
    private static final float ActiveThickness;
    private static final float ActiveTrackSpace;
    private static final float StopShape;
    private static final float StopSize;
    private static final float TrackThickness;
    public static final ProgressIndicatorTokens INSTANCE = new ProgressIndicatorTokens();
    private static final ColorSchemeKeyTokens ActiveIndicatorColor = ColorSchemeKeyTokens.Primary;
    private static final ShapeKeyTokens ActiveShape = ShapeKeyTokens.CornerFull;
    private static final ColorSchemeKeyTokens StopColor = ColorSchemeKeyTokens.Primary;
    private static final ColorSchemeKeyTokens TrackColor = ColorSchemeKeyTokens.SecondaryContainer;
    private static final ShapeKeyTokens TrackShape = ShapeKeyTokens.CornerFull;
    private static final float Size = Dp.constructor-impl((float) 48.0d);

    private ProgressIndicatorTokens() {
    }

    static {
        float f = (float) 4.0d;
        ActiveThickness = Dp.constructor-impl(f);
        ActiveTrackSpace = Dp.constructor-impl(f);
        StopShape = Dp.constructor-impl(f);
        StopSize = Dp.constructor-impl(f);
        TrackThickness = Dp.constructor-impl(f);
    }

    public final ColorSchemeKeyTokens getActiveIndicatorColor() {
        return ActiveIndicatorColor;
    }

    public final ShapeKeyTokens getActiveShape() {
        return ActiveShape;
    }

    public final float m3827getActiveThicknessD9Ej5fM() {
        return ActiveThickness;
    }

    public final float m3828getActiveTrackSpaceD9Ej5fM() {
        return ActiveTrackSpace;
    }

    public final ColorSchemeKeyTokens getStopColor() {
        return StopColor;
    }

    public final float m3830getStopShapeD9Ej5fM() {
        return StopShape;
    }

    public final float m3831getStopSizeD9Ej5fM() {
        return StopSize;
    }

    public final ColorSchemeKeyTokens getTrackColor() {
        return TrackColor;
    }

    public final ShapeKeyTokens getTrackShape() {
        return TrackShape;
    }

    public final float m3832getTrackThicknessD9Ej5fM() {
        return TrackThickness;
    }

    public final float m3829getSizeD9Ej5fM() {
        return Size;
    }
}
