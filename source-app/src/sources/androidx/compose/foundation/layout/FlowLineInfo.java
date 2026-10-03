package androidx.compose.foundation.layout;

import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B-\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0004\u001a\u00020\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012\b\b\u0002\u0010\u0007\u001a\u00020\u0006¢\u0006\u0002\u0010\bJ2\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\u0006H\u0000ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019R\u001a\u0010\u0002\u001a\u00020\u0003X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR\"\u0010\u0007\u001a\u00020\u0006X\u0080\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0011\u001a\u0004\b\r\u0010\u000e\"\u0004\b\u000f\u0010\u0010R\"\u0010\u0005\u001a\u00020\u0006X\u0080\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0011\u001a\u0004\b\u0012\u0010\u000e\"\u0004\b\u0013\u0010\u0010R\u001a\u0010\u0004\u001a\u00020\u0003X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0014\u0010\n\"\u0004\b\u0015\u0010\f\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001a"}, d2 = {"Landroidx/compose/foundation/layout/FlowLineInfo;", "", "lineIndex", "", "positionInLine", "maxMainAxisSize", "Landroidx/compose/ui/unit/Dp;", "maxCrossAxisSize", "(IIFFLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getLineIndex$foundation_layout_release", "()I", "setLineIndex$foundation_layout_release", "(I)V", "getMaxCrossAxisSize-D9Ej5fM$foundation_layout_release", "()F", "setMaxCrossAxisSize-0680j_4$foundation_layout_release", "(F)V", "F", "getMaxMainAxisSize-D9Ej5fM$foundation_layout_release", "setMaxMainAxisSize-0680j_4$foundation_layout_release", "getPositionInLine$foundation_layout_release", "setPositionInLine$foundation_layout_release", "update", "", "update-4j6BHR0$foundation_layout_release", "(IIFF)V", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class FlowLineInfo {
    public static final int $stable = 8;
    private int lineIndex;
    private float maxCrossAxisSize;
    private float maxMainAxisSize;
    private int positionInLine;

    public FlowLineInfo(int i, int i2, float f, float f2, DefaultConstructorMarker defaultConstructorMarker) {
        this(i, i2, f, f2);
    }

    private FlowLineInfo(int i, int i2, float f, float f2) {
        this.lineIndex = i;
        this.positionInLine = i2;
        this.maxMainAxisSize = f;
        this.maxCrossAxisSize = f2;
    }

    public final int getLineIndex() {
        return this.lineIndex;
    }

    public final void setLineIndex$foundation_layout_release(int i) {
        this.lineIndex = i;
    }

    public final int getPositionInLine() {
        return this.positionInLine;
    }

    public final void setPositionInLine$foundation_layout_release(int i) {
        this.positionInLine = i;
    }

    public final float getMaxMainAxisSize() {
        return this.maxMainAxisSize;
    }

    public final void m969setMaxMainAxisSize0680j_4$foundation_layout_release(float f) {
        this.maxMainAxisSize = f;
    }

    public final float getMaxCrossAxisSize() {
        return this.maxCrossAxisSize;
    }

    public final void m968setMaxCrossAxisSize0680j_4$foundation_layout_release(float f) {
        this.maxCrossAxisSize = f;
    }

    public final void m970update4j6BHR0$foundation_layout_release(int lineIndex, int positionInLine, float maxMainAxisSize, float maxCrossAxisSize) {
        this.lineIndex = lineIndex;
        this.positionInLine = positionInLine;
        this.maxMainAxisSize = maxMainAxisSize;
        this.maxCrossAxisSize = maxCrossAxisSize;
    }

    public FlowLineInfo(int i, int i2, float f, float f2, int i3, DefaultConstructorMarker defaultConstructorMarker) {
        this((i3 & 1) != 0 ? 0 : i, (i3 & 2) != 0 ? 0 : i2, (i3 & 4) != 0 ? Dp.constructor-impl(0) : f, (i3 & 8) != 0 ? Dp.constructor-impl(0) : f2, null);
    }
}
