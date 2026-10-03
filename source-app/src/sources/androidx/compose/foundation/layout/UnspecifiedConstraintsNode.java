package androidx.compose.foundation.layout;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.IntrinsicMeasurable;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.node.LayoutModifierNode;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u00012\u00020\u0002B\u0019\u0012\b\b\u0002\u0010\u0003\u001a\u00020\u0004\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0004¢\u0006\u0002\u0010\u0006J\u001c\u0010\u000e\u001a\u00020\u000f*\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u000fH\u0016J\u001c\u0010\u0014\u001a\u00020\u000f*\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0015\u001a\u00020\u000fH\u0016J&\u0010\u0016\u001a\u00020\u0017*\u00020\u00182\u0006\u0010\u0011\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0016ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001dJ\u001c\u0010\u001e\u001a\u00020\u000f*\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u000fH\u0016J\u001c\u0010\u001f\u001a\u00020\u000f*\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0015\u001a\u00020\u000fH\u0016R\"\u0010\u0005\u001a\u00020\u0004X\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u000b\u001a\u0004\b\u0007\u0010\b\"\u0004\b\t\u0010\nR\"\u0010\u0003\u001a\u00020\u0004X\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u000b\u001a\u0004\b\f\u0010\b\"\u0004\b\r\u0010\n\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006 "}, d2 = {"Landroidx/compose/foundation/layout/UnspecifiedConstraintsNode;", "Landroidx/compose/ui/node/LayoutModifierNode;", "Landroidx/compose/ui/Modifier$Node;", "minWidth", "Landroidx/compose/ui/unit/Dp;", "minHeight", "(FFLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getMinHeight-D9Ej5fM", "()F", "setMinHeight-0680j_4", "(F)V", "F", "getMinWidth-D9Ej5fM", "setMinWidth-0680j_4", "maxIntrinsicHeight", "", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "measurable", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "width", "maxIntrinsicWidth", "height", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Measurable;J)Landroidx/compose/ui/layout/MeasureResult;", "minIntrinsicHeight", "minIntrinsicWidth", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class UnspecifiedConstraintsNode extends Modifier.Node implements LayoutModifierNode {
    private float minHeight;
    private float minWidth;

    public UnspecifiedConstraintsNode(float f, float f2, DefaultConstructorMarker defaultConstructorMarker) {
        this(f, f2);
    }

    public UnspecifiedConstraintsNode(float f, float f2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? Dp.Companion.getUnspecified-D9Ej5fM() : f, (i & 2) != 0 ? Dp.Companion.getUnspecified-D9Ej5fM() : f2, null);
    }

    public final float getMinWidth() {
        return this.minWidth;
    }

    public final void m1102setMinWidth0680j_4(float f) {
        this.minWidth = f;
    }

    public final float getMinHeight() {
        return this.minHeight;
    }

    public final void m1101setMinHeight0680j_4(float f) {
        this.minHeight = f;
    }

    private UnspecifiedConstraintsNode(float f, float f2) {
        this.minWidth = f;
        this.minHeight = f2;
    }

    @Override
    public MeasureResult mo352measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
        int iCoerceAtLeast;
        int iCoerceAtLeast2;
        if (!Dp.equals-impl0(this.minWidth, Dp.Companion.getUnspecified-D9Ej5fM()) && Constraints.getMinWidth-impl(j) == 0) {
            iCoerceAtLeast = RangesKt.coerceAtLeast(RangesKt.coerceAtMost(measureScope.roundToPx-0680j_4(this.minWidth), Constraints.getMaxWidth-impl(j)), 0);
        } else {
            iCoerceAtLeast = Constraints.getMinWidth-impl(j);
        }
        int i = Constraints.getMaxWidth-impl(j);
        if (!Dp.equals-impl0(this.minHeight, Dp.Companion.getUnspecified-D9Ej5fM()) && Constraints.getMinHeight-impl(j) == 0) {
            iCoerceAtLeast2 = RangesKt.coerceAtLeast(RangesKt.coerceAtMost(measureScope.roundToPx-0680j_4(this.minHeight), Constraints.getMaxHeight-impl(j)), 0);
        } else {
            iCoerceAtLeast2 = Constraints.getMinHeight-impl(j);
        }
        final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(ConstraintsKt.Constraints(iCoerceAtLeast, i, iCoerceAtLeast2, Constraints.getMaxHeight-impl(j)));
        return MeasureScope.CC.layout$default(measureScope, placeableMo6026measureBRTryo0.getWidth(), placeableMo6026measureBRTryo0.getHeight(), null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                Placeable.PlacementScope.placeRelative$default(placementScope, placeableMo6026measureBRTryo0, 0, 0, 0.0f, 4, null);
            }
        }, 4, null);
    }

    @Override
    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        return RangesKt.coerceAtLeast(intrinsicMeasurable.minIntrinsicWidth(i), !Dp.equals-impl0(this.minWidth, Dp.Companion.getUnspecified-D9Ej5fM()) ? intrinsicMeasureScope.roundToPx-0680j_4(this.minWidth) : 0);
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        return RangesKt.coerceAtLeast(intrinsicMeasurable.maxIntrinsicWidth(i), !Dp.equals-impl0(this.minWidth, Dp.Companion.getUnspecified-D9Ej5fM()) ? intrinsicMeasureScope.roundToPx-0680j_4(this.minWidth) : 0);
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        return RangesKt.coerceAtLeast(intrinsicMeasurable.minIntrinsicHeight(i), !Dp.equals-impl0(this.minHeight, Dp.Companion.getUnspecified-D9Ej5fM()) ? intrinsicMeasureScope.roundToPx-0680j_4(this.minHeight) : 0);
    }

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        return RangesKt.coerceAtLeast(intrinsicMeasurable.maxIntrinsicHeight(i), !Dp.equals-impl0(this.minHeight, Dp.Companion.getUnspecified-D9Ej5fM()) ? intrinsicMeasureScope.roundToPx-0680j_4(this.minHeight) : 0);
    }
}
