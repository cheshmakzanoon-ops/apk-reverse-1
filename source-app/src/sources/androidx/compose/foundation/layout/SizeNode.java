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
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0011\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0002\u0018\u00002\u00020\u00012\u00020\u0002B5\u0012\b\b\u0002\u0010\u0003\u001a\u00020\u0004\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0004\u0012\b\b\u0002\u0010\u0006\u001a\u00020\u0004\u0012\b\b\u0002\u0010\u0007\u001a\u00020\u0004\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\u001c\u0010\u001f\u001a\u00020 *\u00020!2\u0006\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020 H\u0016J\u001c\u0010%\u001a\u00020 *\u00020!2\u0006\u0010\"\u001a\u00020#2\u0006\u0010&\u001a\u00020 H\u0016J&\u0010'\u001a\u00020(*\u00020)2\u0006\u0010\"\u001a\u00020*2\u0006\u0010+\u001a\u00020\u001bH\u0016ø\u0001\u0000¢\u0006\u0004\b,\u0010-J\u001c\u0010.\u001a\u00020 *\u00020!2\u0006\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020 H\u0016J\u001c\u0010/\u001a\u00020 *\u00020!2\u0006\u0010\"\u001a\u00020#2\u0006\u0010&\u001a\u00020 H\u0016R\u001a\u0010\b\u001a\u00020\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000eR\"\u0010\u0007\u001a\u00020\u0004X\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0013\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R\"\u0010\u0006\u001a\u00020\u0004X\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0013\u001a\u0004\b\u0014\u0010\u0010\"\u0004\b\u0015\u0010\u0012R\"\u0010\u0005\u001a\u00020\u0004X\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0013\u001a\u0004\b\u0016\u0010\u0010\"\u0004\b\u0017\u0010\u0012R\"\u0010\u0003\u001a\u00020\u0004X\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u0013\u001a\u0004\b\u0018\u0010\u0010\"\u0004\b\u0019\u0010\u0012R\u001e\u0010\u001a\u001a\u00020\u001b*\u00020\u001c8BX\u0082\u0004ø\u0001\u0000ø\u0001\u0001¢\u0006\u0006\u001a\u0004\b\u001d\u0010\u001e\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u00060"}, d2 = {"Landroidx/compose/foundation/layout/SizeNode;", "Landroidx/compose/ui/node/LayoutModifierNode;", "Landroidx/compose/ui/Modifier$Node;", "minWidth", "Landroidx/compose/ui/unit/Dp;", "minHeight", "maxWidth", "maxHeight", "enforceIncoming", "", "(FFFFZLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getEnforceIncoming", "()Z", "setEnforceIncoming", "(Z)V", "getMaxHeight-D9Ej5fM", "()F", "setMaxHeight-0680j_4", "(F)V", "F", "getMaxWidth-D9Ej5fM", "setMaxWidth-0680j_4", "getMinHeight-D9Ej5fM", "setMinHeight-0680j_4", "getMinWidth-D9Ej5fM", "setMinWidth-0680j_4", "targetConstraints", "Landroidx/compose/ui/unit/Constraints;", "Landroidx/compose/ui/unit/Density;", "getTargetConstraints-OenEA2s", "(Landroidx/compose/ui/unit/Density;)J", "maxIntrinsicHeight", "", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "measurable", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "width", "maxIntrinsicWidth", "height", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "constraints", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Measurable;J)Landroidx/compose/ui/layout/MeasureResult;", "minIntrinsicHeight", "minIntrinsicWidth", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class SizeNode extends Modifier.Node implements LayoutModifierNode {
    private boolean enforceIncoming;
    private float maxHeight;
    private float maxWidth;
    private float minHeight;
    private float minWidth;

    public SizeNode(float f, float f2, float f3, float f4, boolean z, DefaultConstructorMarker defaultConstructorMarker) {
        this(f, f2, f3, f4, z);
    }

    public SizeNode(float f, float f2, float f3, float f4, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? Dp.Companion.getUnspecified-D9Ej5fM() : f, (i & 2) != 0 ? Dp.Companion.getUnspecified-D9Ej5fM() : f2, (i & 4) != 0 ? Dp.Companion.getUnspecified-D9Ej5fM() : f3, (i & 8) != 0 ? Dp.Companion.getUnspecified-D9Ej5fM() : f4, z, null);
    }

    public final float getMinWidth() {
        return this.minWidth;
    }

    public final void m1096setMinWidth0680j_4(float f) {
        this.minWidth = f;
    }

    public final float getMinHeight() {
        return this.minHeight;
    }

    public final void m1095setMinHeight0680j_4(float f) {
        this.minHeight = f;
    }

    public final float getMaxWidth() {
        return this.maxWidth;
    }

    public final void m1094setMaxWidth0680j_4(float f) {
        this.maxWidth = f;
    }

    public final float getMaxHeight() {
        return this.maxHeight;
    }

    public final void m1093setMaxHeight0680j_4(float f) {
        this.maxHeight = f;
    }

    public final boolean getEnforceIncoming() {
        return this.enforceIncoming;
    }

    public final void setEnforceIncoming(boolean z) {
        this.enforceIncoming = z;
    }

    private SizeNode(float f, float f2, float f3, float f4, boolean z) {
        this.minWidth = f;
        this.minHeight = f2;
        this.maxWidth = f3;
        this.maxHeight = f4;
        this.enforceIncoming = z;
    }

    private final long m1088getTargetConstraintsOenEA2s(Density density) {
        int iCoerceAtLeast;
        int iCoerceAtLeast2;
        int i = 0;
        int iCoerceAtLeast3 = !Dp.equals-impl0(this.maxWidth, Dp.Companion.getUnspecified-D9Ej5fM()) ? RangesKt.coerceAtLeast(density.roundToPx-0680j_4(this.maxWidth), 0) : Integer.MAX_VALUE;
        int iCoerceAtLeast4 = !Dp.equals-impl0(this.maxHeight, Dp.Companion.getUnspecified-D9Ej5fM()) ? RangesKt.coerceAtLeast(density.roundToPx-0680j_4(this.maxHeight), 0) : Integer.MAX_VALUE;
        if (Dp.equals-impl0(this.minWidth, Dp.Companion.getUnspecified-D9Ej5fM()) || (iCoerceAtLeast = RangesKt.coerceAtLeast(RangesKt.coerceAtMost(density.roundToPx-0680j_4(this.minWidth), iCoerceAtLeast3), 0)) == Integer.MAX_VALUE) {
            iCoerceAtLeast = 0;
        }
        if (!Dp.equals-impl0(this.minHeight, Dp.Companion.getUnspecified-D9Ej5fM()) && (iCoerceAtLeast2 = RangesKt.coerceAtLeast(RangesKt.coerceAtMost(density.roundToPx-0680j_4(this.minHeight), iCoerceAtLeast4), 0)) != Integer.MAX_VALUE) {
            i = iCoerceAtLeast2;
        }
        return ConstraintsKt.Constraints(iCoerceAtLeast, iCoerceAtLeast3, i, iCoerceAtLeast4);
    }

    @Override
    public MeasureResult mo352measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
        int iCoerceAtMost;
        int iCoerceAtLeast;
        int iCoerceAtMost2;
        int iCoerceAtLeast2;
        long jConstraints;
        long jM1088getTargetConstraintsOenEA2s = m1088getTargetConstraintsOenEA2s(measureScope);
        if (this.enforceIncoming) {
            jConstraints = ConstraintsKt.constrain-N9IONVI(j, jM1088getTargetConstraintsOenEA2s);
        } else {
            if (!Dp.equals-impl0(this.minWidth, Dp.Companion.getUnspecified-D9Ej5fM())) {
                iCoerceAtMost = Constraints.getMinWidth-impl(jM1088getTargetConstraintsOenEA2s);
            } else {
                iCoerceAtMost = RangesKt.coerceAtMost(Constraints.getMinWidth-impl(j), Constraints.getMaxWidth-impl(jM1088getTargetConstraintsOenEA2s));
            }
            if (!Dp.equals-impl0(this.maxWidth, Dp.Companion.getUnspecified-D9Ej5fM())) {
                iCoerceAtLeast = Constraints.getMaxWidth-impl(jM1088getTargetConstraintsOenEA2s);
            } else {
                iCoerceAtLeast = RangesKt.coerceAtLeast(Constraints.getMaxWidth-impl(j), Constraints.getMinWidth-impl(jM1088getTargetConstraintsOenEA2s));
            }
            if (!Dp.equals-impl0(this.minHeight, Dp.Companion.getUnspecified-D9Ej5fM())) {
                iCoerceAtMost2 = Constraints.getMinHeight-impl(jM1088getTargetConstraintsOenEA2s);
            } else {
                iCoerceAtMost2 = RangesKt.coerceAtMost(Constraints.getMinHeight-impl(j), Constraints.getMaxHeight-impl(jM1088getTargetConstraintsOenEA2s));
            }
            if (!Dp.equals-impl0(this.maxHeight, Dp.Companion.getUnspecified-D9Ej5fM())) {
                iCoerceAtLeast2 = Constraints.getMaxHeight-impl(jM1088getTargetConstraintsOenEA2s);
            } else {
                iCoerceAtLeast2 = RangesKt.coerceAtLeast(Constraints.getMaxHeight-impl(j), Constraints.getMinHeight-impl(jM1088getTargetConstraintsOenEA2s));
            }
            jConstraints = ConstraintsKt.Constraints(iCoerceAtMost, iCoerceAtLeast, iCoerceAtMost2, iCoerceAtLeast2);
        }
        final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(jConstraints);
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
        long jM1088getTargetConstraintsOenEA2s = m1088getTargetConstraintsOenEA2s(intrinsicMeasureScope);
        if (Constraints.getHasFixedWidth-impl(jM1088getTargetConstraintsOenEA2s)) {
            return Constraints.getMaxWidth-impl(jM1088getTargetConstraintsOenEA2s);
        }
        return ConstraintsKt.constrainWidth-K40F9xA(jM1088getTargetConstraintsOenEA2s, intrinsicMeasurable.minIntrinsicWidth(i));
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        long jM1088getTargetConstraintsOenEA2s = m1088getTargetConstraintsOenEA2s(intrinsicMeasureScope);
        if (Constraints.getHasFixedHeight-impl(jM1088getTargetConstraintsOenEA2s)) {
            return Constraints.getMaxHeight-impl(jM1088getTargetConstraintsOenEA2s);
        }
        return ConstraintsKt.constrainHeight-K40F9xA(jM1088getTargetConstraintsOenEA2s, intrinsicMeasurable.minIntrinsicHeight(i));
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        long jM1088getTargetConstraintsOenEA2s = m1088getTargetConstraintsOenEA2s(intrinsicMeasureScope);
        if (Constraints.getHasFixedWidth-impl(jM1088getTargetConstraintsOenEA2s)) {
            return Constraints.getMaxWidth-impl(jM1088getTargetConstraintsOenEA2s);
        }
        return ConstraintsKt.constrainWidth-K40F9xA(jM1088getTargetConstraintsOenEA2s, intrinsicMeasurable.maxIntrinsicWidth(i));
    }

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        long jM1088getTargetConstraintsOenEA2s = m1088getTargetConstraintsOenEA2s(intrinsicMeasureScope);
        if (Constraints.getHasFixedHeight-impl(jM1088getTargetConstraintsOenEA2s)) {
            return Constraints.getMaxHeight-impl(jM1088getTargetConstraintsOenEA2s);
        }
        return ConstraintsKt.constrainHeight-K40F9xA(jM1088getTargetConstraintsOenEA2s, intrinsicMeasurable.maxIntrinsicHeight(i));
    }
}
