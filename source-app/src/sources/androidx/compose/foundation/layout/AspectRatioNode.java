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
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000J\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\b\u0002\u0018\u00002\u00020\u00012\u00020\u0002B\u0015\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u0016\u0010\u0010\u001a\u00020\u0011*\u00020\u0012H\u0002ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014J\u001c\u0010\u0015\u001a\u00020\u0016*\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u0016H\u0016J\u001c\u0010\u001b\u001a\u00020\u0016*\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001c\u001a\u00020\u0016H\u0016J&\u0010\u001d\u001a\u00020\u001e*\u00020\u001f2\u0006\u0010\u0018\u001a\u00020 2\u0006\u0010!\u001a\u00020\u0012H\u0016ø\u0001\u0000¢\u0006\u0004\b\"\u0010#J\u001c\u0010$\u001a\u00020\u0016*\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u0016H\u0016J\u001c\u0010%\u001a\u00020\u0016*\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001c\u001a\u00020\u0016H\u0016J \u0010&\u001a\u00020\u0011*\u00020\u00122\b\b\u0002\u0010'\u001a\u00020\u0006H\u0002ø\u0001\u0000¢\u0006\u0004\b(\u0010)J \u0010*\u001a\u00020\u0011*\u00020\u00122\b\b\u0002\u0010'\u001a\u00020\u0006H\u0002ø\u0001\u0000¢\u0006\u0004\b+\u0010)J \u0010,\u001a\u00020\u0011*\u00020\u00122\b\b\u0002\u0010'\u001a\u00020\u0006H\u0002ø\u0001\u0000¢\u0006\u0004\b-\u0010)J \u0010.\u001a\u00020\u0011*\u00020\u00122\b\b\u0002\u0010'\u001a\u00020\u0006H\u0002ø\u0001\u0000¢\u0006\u0004\b/\u0010)R\u001a\u0010\u0003\u001a\u00020\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u001a\u0010\u0005\u001a\u00020\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000f\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u00060"}, d2 = {"Landroidx/compose/foundation/layout/AspectRatioNode;", "Landroidx/compose/ui/node/LayoutModifierNode;", "Landroidx/compose/ui/Modifier$Node;", "aspectRatio", "", "matchHeightConstraintsFirst", "", "(FZ)V", "getAspectRatio", "()F", "setAspectRatio", "(F)V", "getMatchHeightConstraintsFirst", "()Z", "setMatchHeightConstraintsFirst", "(Z)V", "findSize", "Landroidx/compose/ui/unit/IntSize;", "Landroidx/compose/ui/unit/Constraints;", "findSize-ToXhtMw", "(J)J", "maxIntrinsicHeight", "", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "measurable", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "width", "maxIntrinsicWidth", "height", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "constraints", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Measurable;J)Landroidx/compose/ui/layout/MeasureResult;", "minIntrinsicHeight", "minIntrinsicWidth", "tryMaxHeight", "enforceConstraints", "tryMaxHeight-JN-0ABg", "(JZ)J", "tryMaxWidth", "tryMaxWidth-JN-0ABg", "tryMinHeight", "tryMinHeight-JN-0ABg", "tryMinWidth", "tryMinWidth-JN-0ABg", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class AspectRatioNode extends Modifier.Node implements LayoutModifierNode {
    private float aspectRatio;
    private boolean matchHeightConstraintsFirst;

    public final float getAspectRatio() {
        return this.aspectRatio;
    }

    public final void setAspectRatio(float f) {
        this.aspectRatio = f;
    }

    public final boolean getMatchHeightConstraintsFirst() {
        return this.matchHeightConstraintsFirst;
    }

    public final void setMatchHeightConstraintsFirst(boolean z) {
        this.matchHeightConstraintsFirst = z;
    }

    public AspectRatioNode(float f, boolean z) {
        this.aspectRatio = f;
        this.matchHeightConstraintsFirst = z;
    }

    @Override
    public MeasureResult mo352measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
        long jM931findSizeToXhtMw = m931findSizeToXhtMw(j);
        if (!IntSize.equals-impl0(jM931findSizeToXhtMw, IntSize.Companion.getZero-YbymL2g())) {
            j = Constraints.Companion.fixed-JhjzzOo(IntSize.getWidth-impl(jM931findSizeToXhtMw), IntSize.getHeight-impl(jM931findSizeToXhtMw));
        }
        final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(j);
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
        if (i == Integer.MAX_VALUE) {
            return intrinsicMeasurable.minIntrinsicWidth(i);
        }
        return Math.round(i * this.aspectRatio);
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (i == Integer.MAX_VALUE) {
            return intrinsicMeasurable.maxIntrinsicWidth(i);
        }
        return Math.round(i * this.aspectRatio);
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (i == Integer.MAX_VALUE) {
            return intrinsicMeasurable.minIntrinsicHeight(i);
        }
        return Math.round(i / this.aspectRatio);
    }

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (i == Integer.MAX_VALUE) {
            return intrinsicMeasurable.maxIntrinsicHeight(i);
        }
        return Math.round(i / this.aspectRatio);
    }

    private final long m931findSizeToXhtMw(long j) {
        if (!this.matchHeightConstraintsFirst) {
            long jM935tryMaxWidthJN0ABg$default = m935tryMaxWidthJN0ABg$default(this, j, false, 1, null);
            if (!IntSize.equals-impl0(jM935tryMaxWidthJN0ABg$default, IntSize.Companion.getZero-YbymL2g())) {
                return jM935tryMaxWidthJN0ABg$default;
            }
            long jM933tryMaxHeightJN0ABg$default = m933tryMaxHeightJN0ABg$default(this, j, false, 1, null);
            if (!IntSize.equals-impl0(jM933tryMaxHeightJN0ABg$default, IntSize.Companion.getZero-YbymL2g())) {
                return jM933tryMaxHeightJN0ABg$default;
            }
            long jM939tryMinWidthJN0ABg$default = m939tryMinWidthJN0ABg$default(this, j, false, 1, null);
            if (!IntSize.equals-impl0(jM939tryMinWidthJN0ABg$default, IntSize.Companion.getZero-YbymL2g())) {
                return jM939tryMinWidthJN0ABg$default;
            }
            long jM937tryMinHeightJN0ABg$default = m937tryMinHeightJN0ABg$default(this, j, false, 1, null);
            if (!IntSize.equals-impl0(jM937tryMinHeightJN0ABg$default, IntSize.Companion.getZero-YbymL2g())) {
                return jM937tryMinHeightJN0ABg$default;
            }
            long jM934tryMaxWidthJN0ABg = m934tryMaxWidthJN0ABg(j, false);
            if (!IntSize.equals-impl0(jM934tryMaxWidthJN0ABg, IntSize.Companion.getZero-YbymL2g())) {
                return jM934tryMaxWidthJN0ABg;
            }
            long jM932tryMaxHeightJN0ABg = m932tryMaxHeightJN0ABg(j, false);
            if (!IntSize.equals-impl0(jM932tryMaxHeightJN0ABg, IntSize.Companion.getZero-YbymL2g())) {
                return jM932tryMaxHeightJN0ABg;
            }
            long jM938tryMinWidthJN0ABg = m938tryMinWidthJN0ABg(j, false);
            if (!IntSize.equals-impl0(jM938tryMinWidthJN0ABg, IntSize.Companion.getZero-YbymL2g())) {
                return jM938tryMinWidthJN0ABg;
            }
            long jM936tryMinHeightJN0ABg = m936tryMinHeightJN0ABg(j, false);
            if (!IntSize.equals-impl0(jM936tryMinHeightJN0ABg, IntSize.Companion.getZero-YbymL2g())) {
                return jM936tryMinHeightJN0ABg;
            }
        } else {
            long jM933tryMaxHeightJN0ABg$default2 = m933tryMaxHeightJN0ABg$default(this, j, false, 1, null);
            if (!IntSize.equals-impl0(jM933tryMaxHeightJN0ABg$default2, IntSize.Companion.getZero-YbymL2g())) {
                return jM933tryMaxHeightJN0ABg$default2;
            }
            long jM935tryMaxWidthJN0ABg$default2 = m935tryMaxWidthJN0ABg$default(this, j, false, 1, null);
            if (!IntSize.equals-impl0(jM935tryMaxWidthJN0ABg$default2, IntSize.Companion.getZero-YbymL2g())) {
                return jM935tryMaxWidthJN0ABg$default2;
            }
            long jM937tryMinHeightJN0ABg$default2 = m937tryMinHeightJN0ABg$default(this, j, false, 1, null);
            if (!IntSize.equals-impl0(jM937tryMinHeightJN0ABg$default2, IntSize.Companion.getZero-YbymL2g())) {
                return jM937tryMinHeightJN0ABg$default2;
            }
            long jM939tryMinWidthJN0ABg$default2 = m939tryMinWidthJN0ABg$default(this, j, false, 1, null);
            if (!IntSize.equals-impl0(jM939tryMinWidthJN0ABg$default2, IntSize.Companion.getZero-YbymL2g())) {
                return jM939tryMinWidthJN0ABg$default2;
            }
            long jM932tryMaxHeightJN0ABg2 = m932tryMaxHeightJN0ABg(j, false);
            if (!IntSize.equals-impl0(jM932tryMaxHeightJN0ABg2, IntSize.Companion.getZero-YbymL2g())) {
                return jM932tryMaxHeightJN0ABg2;
            }
            long jM934tryMaxWidthJN0ABg2 = m934tryMaxWidthJN0ABg(j, false);
            if (!IntSize.equals-impl0(jM934tryMaxWidthJN0ABg2, IntSize.Companion.getZero-YbymL2g())) {
                return jM934tryMaxWidthJN0ABg2;
            }
            long jM936tryMinHeightJN0ABg2 = m936tryMinHeightJN0ABg(j, false);
            if (!IntSize.equals-impl0(jM936tryMinHeightJN0ABg2, IntSize.Companion.getZero-YbymL2g())) {
                return jM936tryMinHeightJN0ABg2;
            }
            long jM938tryMinWidthJN0ABg2 = m938tryMinWidthJN0ABg(j, false);
            if (!IntSize.equals-impl0(jM938tryMinWidthJN0ABg2, IntSize.Companion.getZero-YbymL2g())) {
                return jM938tryMinWidthJN0ABg2;
            }
        }
        return IntSize.Companion.getZero-YbymL2g();
    }

    static long m935tryMaxWidthJN0ABg$default(AspectRatioNode aspectRatioNode, long j, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        return aspectRatioNode.m934tryMaxWidthJN0ABg(j, z);
    }

    private final long m934tryMaxWidthJN0ABg(long j, boolean z) {
        int iRound;
        int i = Constraints.getMaxWidth-impl(j);
        if (i != Integer.MAX_VALUE && (iRound = Math.round(i / this.aspectRatio)) > 0) {
            long jIntSize = IntSizeKt.IntSize(i, iRound);
            if (!z || ConstraintsKt.isSatisfiedBy-4WqzIAM(j, jIntSize)) {
                return jIntSize;
            }
        }
        return IntSize.Companion.getZero-YbymL2g();
    }

    static long m933tryMaxHeightJN0ABg$default(AspectRatioNode aspectRatioNode, long j, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        return aspectRatioNode.m932tryMaxHeightJN0ABg(j, z);
    }

    private final long m932tryMaxHeightJN0ABg(long j, boolean z) {
        int iRound;
        int i = Constraints.getMaxHeight-impl(j);
        if (i != Integer.MAX_VALUE && (iRound = Math.round(i * this.aspectRatio)) > 0) {
            long jIntSize = IntSizeKt.IntSize(iRound, i);
            if (!z || ConstraintsKt.isSatisfiedBy-4WqzIAM(j, jIntSize)) {
                return jIntSize;
            }
        }
        return IntSize.Companion.getZero-YbymL2g();
    }

    static long m939tryMinWidthJN0ABg$default(AspectRatioNode aspectRatioNode, long j, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        return aspectRatioNode.m938tryMinWidthJN0ABg(j, z);
    }

    private final long m938tryMinWidthJN0ABg(long j, boolean z) {
        int i = Constraints.getMinWidth-impl(j);
        int iRound = Math.round(i / this.aspectRatio);
        if (iRound > 0) {
            long jIntSize = IntSizeKt.IntSize(i, iRound);
            if (!z || ConstraintsKt.isSatisfiedBy-4WqzIAM(j, jIntSize)) {
                return jIntSize;
            }
        }
        return IntSize.Companion.getZero-YbymL2g();
    }

    static long m937tryMinHeightJN0ABg$default(AspectRatioNode aspectRatioNode, long j, boolean z, int i, Object obj) {
        if ((i & 1) != 0) {
            z = true;
        }
        return aspectRatioNode.m936tryMinHeightJN0ABg(j, z);
    }

    private final long m936tryMinHeightJN0ABg(long j, boolean z) {
        int i = Constraints.getMinHeight-impl(j);
        int iRound = Math.round(i * this.aspectRatio);
        if (iRound > 0) {
            long jIntSize = IntSizeKt.IntSize(iRound, i);
            if (!z || ConstraintsKt.isSatisfiedBy-4WqzIAM(j, jIntSize)) {
                return jIntSize;
            }
        }
        return IntSize.Companion.getZero-YbymL2g();
    }
}
