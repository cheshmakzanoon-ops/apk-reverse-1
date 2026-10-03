package androidx.compose.p002ui.layout;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\u0080\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\b\b\u0000\u0018\u00002\u00020\u00012\u00020\u0002B\u0015\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J`\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u00152\u0012\u0010\u0017\u001a\u000e\u0012\u0004\u0012\u00020\u0019\u0012\u0004\u0012\u00020\u00150\u00182\u0019\u0010\u001a\u001a\u0015\u0012\u0004\u0012\u00020\u001c\u0012\u0004\u0012\u00020\u001d\u0018\u00010\u001b¢\u0006\u0002\b\u001e2\u0017\u0010\u001f\u001a\u0013\u0012\u0004\u0012\u00020 \u0012\u0004\u0012\u00020\u001d0\u001b¢\u0006\u0002\b\u001eH\u0016J\u0017\u0010!\u001a\u00020\u0015*\u00020\"H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b#\u0010$J\u0017\u0010!\u001a\u00020\u0015*\u00020%H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b&\u0010'J\u0017\u0010(\u001a\u00020\"*\u00020%H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b)\u0010*J\u001a\u0010(\u001a\u00020\"*\u00020\bH\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b+\u0010,J\u001a\u0010(\u001a\u00020\"*\u00020\u0015H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b+\u0010-J\u0017\u0010.\u001a\u00020/*\u000200H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b1\u00102J\u0017\u00103\u001a\u00020\b*\u00020\"H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b4\u0010,J\u0017\u00103\u001a\u00020\b*\u00020%H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b5\u0010*J\r\u00106\u001a\u000207*\u000208H\u0097\u0001J\u0017\u00109\u001a\u000200*\u00020/H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b:\u00102J\u0017\u0010;\u001a\u00020%*\u00020\"H\u0097\u0001ø\u0001\u0000¢\u0006\u0004\b<\u0010=J\u001a\u0010;\u001a\u00020%*\u00020\bH\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b>\u0010=J\u001a\u0010;\u001a\u00020%*\u00020\u0015H\u0097\u0001ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b>\u0010?R\u0014\u0010\u0007\u001a\u00020\b8\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\t\u0010\nR\u0014\u0010\u000b\u001a\u00020\b8\u0016X\u0097\u0005¢\u0006\u0006\u001a\u0004\b\f\u0010\nR\u0014\u0010\r\u001a\u00020\u000e8VX\u0096\u0005¢\u0006\u0006\u001a\u0004\b\r\u0010\u000fR\u0014\u0010\u0004\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006@"}, d2 = {"Landroidx/compose/ui/layout/IntrinsicsMeasureScope;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "intrinsicMeasureScope", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "(Landroidx/compose/ui/layout/IntrinsicMeasureScope;Landroidx/compose/ui/unit/LayoutDirection;)V", "density", "", "getDensity", "()F", "fontScale", "getFontScale", "isLookingAhead", "", "()Z", "getLayoutDirection", "()Landroidx/compose/ui/unit/LayoutDirection;", "layout", "Landroidx/compose/ui/layout/MeasureResult;", "width", "", "height", "alignmentLines", "", "Landroidx/compose/ui/layout/AlignmentLine;", "rulers", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/RulerScope;", "", "Lkotlin/ExtensionFunctionType;", "placementBlock", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "roundToPx", "Landroidx/compose/ui/unit/Dp;", "roundToPx-0680j_4", "(F)I", "Landroidx/compose/ui/unit/TextUnit;", "roundToPx--R2X_6o", "(J)I", "toDp", "toDp-GaN1DYA", "(J)F", "toDp-u2uoSUM", "(F)F", "(I)F", "toDpSize", "Landroidx/compose/ui/unit/DpSize;", "Landroidx/compose/ui/geometry/Size;", "toDpSize-k-rfVVM", "(J)J", "toPx", "toPx-0680j_4", "toPx--R2X_6o", "toRect", "Landroidx/compose/ui/geometry/Rect;", "Landroidx/compose/ui/unit/DpRect;", "toSize", "toSize-XkaWNTQ", "toSp", "toSp-0xMU5do", "(F)J", "toSp-kPz2Gy4", "(I)J", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class IntrinsicsMeasureScope implements MeasureScope, IntrinsicMeasureScope {
    public static final int $stable = 0;
    private final IntrinsicMeasureScope $$delegate_0;
    private final LayoutDirection layoutDirection;

    public float getDensity() {
        return this.$$delegate_0.getDensity();
    }

    public float getFontScale() {
        return this.$$delegate_0.getFontScale();
    }

    @Override
    public boolean isLookingAhead() {
        return this.$$delegate_0.isLookingAhead();
    }

    @Override
    public MeasureResult layout(int i, int i2, Map map, Function1 function1) {
        return MeasureScope.CC.$default$layout(this, i, i2, map, function1);
    }

    public int m6028roundToPxR2X_6o(long j) {
        return this.$$delegate_0.roundToPx--R2X_6o(j);
    }

    public int m6029roundToPx0680j_4(float f) {
        return this.$$delegate_0.roundToPx-0680j_4(f);
    }

    public float m6030toDpGaN1DYA(long j) {
        return this.$$delegate_0.toDp-GaN1DYA(j);
    }

    public float m6031toDpu2uoSUM(float f) {
        return this.$$delegate_0.toDp-u2uoSUM(f);
    }

    public float m6032toDpu2uoSUM(int i) {
        return this.$$delegate_0.toDp-u2uoSUM(i);
    }

    public long m6033toDpSizekrfVVM(long j) {
        return this.$$delegate_0.toDpSize-k-rfVVM(j);
    }

    public float m6034toPxR2X_6o(long j) {
        return this.$$delegate_0.toPx--R2X_6o(j);
    }

    public float m6035toPx0680j_4(float f) {
        return this.$$delegate_0.toPx-0680j_4(f);
    }

    public Rect toRect(DpRect dpRect) {
        return this.$$delegate_0.toRect(dpRect);
    }

    public long m6036toSizeXkaWNTQ(long j) {
        return this.$$delegate_0.toSize-XkaWNTQ(j);
    }

    public long m6037toSp0xMU5do(float f) {
        return this.$$delegate_0.toSp-0xMU5do(f);
    }

    public long m6038toSpkPz2Gy4(float f) {
        return this.$$delegate_0.toSp-kPz2Gy4(f);
    }

    public long m6039toSpkPz2Gy4(int i) {
        return this.$$delegate_0.toSp-kPz2Gy4(i);
    }

    public IntrinsicsMeasureScope(IntrinsicMeasureScope intrinsicMeasureScope, LayoutDirection layoutDirection) {
        this.layoutDirection = layoutDirection;
        this.$$delegate_0 = intrinsicMeasureScope;
    }

    @Override
    public LayoutDirection getLayoutDirection() {
        return this.layoutDirection;
    }

    @Override
    public MeasureResult layout(int width, int height, final Map<AlignmentLine, Integer> alignmentLines, final Function1<? super RulerScope, Unit> rulers, Function1<? super Placeable.PlacementScope, Unit> placementBlock) {
        boolean z = false;
        final int iCoerceAtLeast = RangesKt.coerceAtLeast(width, 0);
        final int iCoerceAtLeast2 = RangesKt.coerceAtLeast(height, 0);
        if ((iCoerceAtLeast & (-16777216)) == 0 && ((-16777216) & iCoerceAtLeast2) == 0) {
            z = true;
        }
        if (!z) {
            InlineClassHelperKt.throwIllegalStateException("Size(" + iCoerceAtLeast + " x " + iCoerceAtLeast2 + ") is out of range. Each dimension must be between 0 and 16777215.");
        }
        return new MeasureResult() {
            @Override
            public void placeChildren() {
            }

            @Override
            public int get$width() {
                return iCoerceAtLeast;
            }

            @Override
            public int get$height() {
                return iCoerceAtLeast2;
            }

            @Override
            public Map<AlignmentLine, Integer> getAlignmentLines() {
                return alignmentLines;
            }

            @Override
            public Function1<RulerScope, Unit> getRulers() {
                return rulers;
            }
        };
    }
}
