package coil.compose;

import androidx.compose.p000ui.unit.Constraints;
import androidx.compose.p000ui.unit.ConstraintsKt;
import androidx.compose.p000ui.unit.IntOffset;
import androidx.compose.ui.Alignment;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.geometry.Size;
import androidx.compose.ui.geometry.SizeKt;
import androidx.compose.ui.graphics.ColorFilter;
import androidx.compose.ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.graphics.painter.Painter;
import androidx.compose.ui.layout.ContentScale;
import androidx.compose.ui.layout.IntrinsicMeasurable;
import androidx.compose.ui.layout.IntrinsicMeasureScope;
import androidx.compose.ui.layout.Measurable;
import androidx.compose.ui.layout.MeasureResult;
import androidx.compose.ui.layout.MeasureScope;
import androidx.compose.ui.layout.Placeable;
import androidx.compose.ui.layout.ScaleFactor;
import androidx.compose.ui.layout.ScaleFactorKt;
import androidx.compose.ui.node.DrawModifierNode;
import androidx.compose.ui.node.LayoutModifierNode;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.math.MathKt;

@Metadata(d1 = {"\u0000v\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0010\u000b\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u0003B/\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r¢\u0006\u0002\u0010\u000eJ\u001a\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020(H\u0002ø\u0001\u0000¢\u0006\u0004\b*\u0010+J\u001a\u0010,\u001a\u00020-2\u0006\u0010.\u001a\u00020-H\u0002ø\u0001\u0000¢\u0006\u0004\b/\u0010+J\f\u00100\u001a\u000201*\u000202H\u0016J\u001c\u00103\u001a\u000204*\u0002052\u0006\u00106\u001a\u0002072\u0006\u00108\u001a\u000204H\u0016J\u001c\u00109\u001a\u000204*\u0002052\u0006\u00106\u001a\u0002072\u0006\u0010:\u001a\u000204H\u0016J&\u0010;\u001a\u00020<*\u00020=2\u0006\u00106\u001a\u00020>2\u0006\u0010.\u001a\u00020-H\u0016ø\u0001\u0000¢\u0006\u0004\b?\u0010@J\u001c\u0010A\u001a\u000204*\u0002052\u0006\u00106\u001a\u0002072\u0006\u00108\u001a\u000204H\u0016J\u001c\u0010B\u001a\u000204*\u0002052\u0006\u00106\u001a\u0002072\u0006\u0010:\u001a\u000204H\u0016R\u001a\u0010\u0006\u001a\u00020\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R\u001a\u0010\n\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0013\u0010\u0014\"\u0004\b\u0015\u0010\u0016R\u001c\u0010\f\u001a\u0004\u0018\u00010\rX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0017\u0010\u0018\"\u0004\b\u0019\u0010\u001aR\u001a\u0010\b\u001a\u00020\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001b\u0010\u001c\"\u0004\b\u001d\u0010\u001eR\u001a\u0010\u0004\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001f\u0010 \"\u0004\b!\u0010\"R\u0014\u0010#\u001a\u00020$8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b%\u0010&\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006C"}, d2 = {"Lcoil/compose/ContentPainterNode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/node/DrawModifierNode;", "Landroidx/compose/ui/node/LayoutModifierNode;", "painter", "Landroidx/compose/ui/graphics/painter/Painter;", "alignment", "Landroidx/compose/ui/Alignment;", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "alpha", "", "colorFilter", "Landroidx/compose/ui/graphics/ColorFilter;", "(Landroidx/compose/ui/graphics/painter/Painter;Landroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;)V", "getAlignment", "()Landroidx/compose/ui/Alignment;", "setAlignment", "(Landroidx/compose/ui/Alignment;)V", "getAlpha", "()F", "setAlpha", "(F)V", "getColorFilter", "()Landroidx/compose/ui/graphics/ColorFilter;", "setColorFilter", "(Landroidx/compose/ui/graphics/ColorFilter;)V", "getContentScale", "()Landroidx/compose/ui/layout/ContentScale;", "setContentScale", "(Landroidx/compose/ui/layout/ContentScale;)V", "getPainter", "()Landroidx/compose/ui/graphics/painter/Painter;", "setPainter", "(Landroidx/compose/ui/graphics/painter/Painter;)V", "shouldAutoInvalidate", "", "getShouldAutoInvalidate", "()Z", "calculateScaledSize", "Landroidx/compose/ui/geometry/Size;", "dstSize", "calculateScaledSize-E7KxVPU", "(J)J", "modifyConstraints", "Landroidx/compose/ui/unit/Constraints;", "constraints", "modifyConstraints-ZezNO4M", "draw", "", "Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "maxIntrinsicHeight", "", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "measurable", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", ViewHierarchyConstants.DIMENSION_WIDTH_KEY, "maxIntrinsicWidth", ViewHierarchyConstants.DIMENSION_HEIGHT_KEY, "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Measurable;J)Landroidx/compose/ui/layout/MeasureResult;", "minIntrinsicHeight", "minIntrinsicWidth", "coil-compose-base_release"}, k = 1, mv = {1, 9, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class ContentPainterNode extends Modifier.Node implements DrawModifierNode, LayoutModifierNode {
    public static final int $stable = 8;
    private Alignment alignment;
    private float alpha;
    private ColorFilter colorFilter;
    private ContentScale contentScale;
    private Painter painter;

    public boolean getShouldAutoInvalidate() {
        return false;
    }

    public void onMeasureResultChanged() {
        DrawModifierNode.-CC.$default$onMeasureResultChanged(this);
    }

    public final Painter getPainter() {
        return this.painter;
    }

    public final void setPainter(Painter painter) {
        this.painter = painter;
    }

    public final Alignment getAlignment() {
        return this.alignment;
    }

    public final void setAlignment(Alignment alignment) {
        this.alignment = alignment;
    }

    public final ContentScale getContentScale() {
        return this.contentScale;
    }

    public final void setContentScale(ContentScale contentScale) {
        this.contentScale = contentScale;
    }

    public final float getAlpha() {
        return this.alpha;
    }

    public final void setAlpha(float f) {
        this.alpha = f;
    }

    public final ColorFilter getColorFilter() {
        return this.colorFilter;
    }

    public final void setColorFilter(ColorFilter colorFilter) {
        this.colorFilter = colorFilter;
    }

    public ContentPainterNode(Painter painter, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter) {
        this.painter = painter;
        this.alignment = alignment;
        this.contentScale = contentScale;
        this.alpha = f;
        this.colorFilter = colorFilter;
    }

    public MeasureResult m2282measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
        final Placeable placeable = measurable.measure-BRTryo0(m2281modifyConstraintsZezNO4M(j));
        return MeasureScope.-CC.layout$default(measureScope, placeable.getWidth(), placeable.getHeight(), (Map) null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                Placeable.PlacementScope.placeRelative$default(placementScope, placeable, 0, 0, 0.0f, 4, (Object) null);
            }
        }, 4, (Object) null);
    }

    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (this.painter.getIntrinsicSize-NH-jbRc() != Size.Companion.getUnspecified-NH-jbRc()) {
            int iMinIntrinsicWidth = intrinsicMeasurable.minIntrinsicWidth(Constraints.m1765getMaxHeightimpl(m2281modifyConstraintsZezNO4M(ConstraintsKt.Constraints$default(0, 0, 0, i, 7, null))));
            return Math.max(MathKt.roundToInt(Size.getWidth-impl(m2280calculateScaledSizeE7KxVPU(SizeKt.Size(iMinIntrinsicWidth, i)))), iMinIntrinsicWidth);
        }
        return intrinsicMeasurable.minIntrinsicWidth(i);
    }

    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (this.painter.getIntrinsicSize-NH-jbRc() != Size.Companion.getUnspecified-NH-jbRc()) {
            int iMaxIntrinsicWidth = intrinsicMeasurable.maxIntrinsicWidth(Constraints.m1765getMaxHeightimpl(m2281modifyConstraintsZezNO4M(ConstraintsKt.Constraints$default(0, 0, 0, i, 7, null))));
            return Math.max(MathKt.roundToInt(Size.getWidth-impl(m2280calculateScaledSizeE7KxVPU(SizeKt.Size(iMaxIntrinsicWidth, i)))), iMaxIntrinsicWidth);
        }
        return intrinsicMeasurable.maxIntrinsicWidth(i);
    }

    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (this.painter.getIntrinsicSize-NH-jbRc() != Size.Companion.getUnspecified-NH-jbRc()) {
            int iMinIntrinsicHeight = intrinsicMeasurable.minIntrinsicHeight(Constraints.m1766getMaxWidthimpl(m2281modifyConstraintsZezNO4M(ConstraintsKt.Constraints$default(0, i, 0, 0, 13, null))));
            return Math.max(MathKt.roundToInt(Size.getHeight-impl(m2280calculateScaledSizeE7KxVPU(SizeKt.Size(i, iMinIntrinsicHeight)))), iMinIntrinsicHeight);
        }
        return intrinsicMeasurable.minIntrinsicHeight(i);
    }

    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (this.painter.getIntrinsicSize-NH-jbRc() != Size.Companion.getUnspecified-NH-jbRc()) {
            int iMaxIntrinsicHeight = intrinsicMeasurable.maxIntrinsicHeight(Constraints.m1766getMaxWidthimpl(m2281modifyConstraintsZezNO4M(ConstraintsKt.Constraints$default(0, i, 0, 0, 13, null))));
            return Math.max(MathKt.roundToInt(Size.getHeight-impl(m2280calculateScaledSizeE7KxVPU(SizeKt.Size(i, iMaxIntrinsicHeight)))), iMaxIntrinsicHeight);
        }
        return intrinsicMeasurable.maxIntrinsicHeight(i);
    }

    private final long m2280calculateScaledSizeE7KxVPU(long dstSize) {
        if (Size.isEmpty-impl(dstSize)) {
            return Size.Companion.getZero-NH-jbRc();
        }
        long j = this.painter.getIntrinsicSize-NH-jbRc();
        if (j == Size.Companion.getUnspecified-NH-jbRc()) {
            return dstSize;
        }
        float f = Size.getWidth-impl(j);
        if (Float.isInfinite(f) || Float.isNaN(f)) {
            f = Size.getWidth-impl(dstSize);
        }
        float f2 = Size.getHeight-impl(j);
        if (Float.isInfinite(f2) || Float.isNaN(f2)) {
            f2 = Size.getHeight-impl(dstSize);
        }
        long jSize = SizeKt.Size(f, f2);
        long j2 = this.contentScale.computeScaleFactor-H7hwNQA(jSize, dstSize);
        float f3 = ScaleFactor.getScaleX-impl(j2);
        if (Float.isInfinite(f3) || Float.isNaN(f3)) {
            return dstSize;
        }
        float f4 = ScaleFactor.getScaleY-impl(j2);
        return (Float.isInfinite(f4) || Float.isNaN(f4)) ? dstSize : ScaleFactorKt.times-m-w2e94(j2, jSize);
    }

    private final long m2281modifyConstraintsZezNO4M(long constraints) {
        float fM1768getMinWidthimpl;
        int iM1767getMinHeightimpl;
        float fM2315constrainHeightK40F9xA;
        boolean zM1764getHasFixedWidthimpl = Constraints.m1764getHasFixedWidthimpl(constraints);
        boolean zM1763getHasFixedHeightimpl = Constraints.m1763getHasFixedHeightimpl(constraints);
        if (zM1764getHasFixedWidthimpl && zM1763getHasFixedHeightimpl) {
            return constraints;
        }
        boolean z = Constraints.m1762getHasBoundedWidthimpl(constraints) && Constraints.m1761getHasBoundedHeightimpl(constraints);
        long j = this.painter.getIntrinsicSize-NH-jbRc();
        if (j == Size.Companion.getUnspecified-NH-jbRc()) {
            return z ? Constraints.m1757copyZbe2FdA$default(constraints, Constraints.m1766getMaxWidthimpl(constraints), 0, Constraints.m1765getMaxHeightimpl(constraints), 0, 10, null) : constraints;
        }
        if (z && (zM1764getHasFixedWidthimpl || zM1763getHasFixedHeightimpl)) {
            fM1768getMinWidthimpl = Constraints.m1766getMaxWidthimpl(constraints);
            iM1767getMinHeightimpl = Constraints.m1765getMaxHeightimpl(constraints);
        } else {
            float f = Size.getWidth-impl(j);
            float f2 = Size.getHeight-impl(j);
            fM1768getMinWidthimpl = (Float.isInfinite(f) || Float.isNaN(f)) ? Constraints.m1768getMinWidthimpl(constraints) : UtilsKt.m2316constrainWidthK40F9xA(constraints, f);
            if (Float.isInfinite(f2) || Float.isNaN(f2)) {
                iM1767getMinHeightimpl = Constraints.m1767getMinHeightimpl(constraints);
            } else {
                fM2315constrainHeightK40F9xA = UtilsKt.m2315constrainHeightK40F9xA(constraints, f2);
            }
            long jM2280calculateScaledSizeE7KxVPU = m2280calculateScaledSizeE7KxVPU(SizeKt.Size(fM1768getMinWidthimpl, fM2315constrainHeightK40F9xA));
            return Constraints.m1757copyZbe2FdA$default(constraints, ConstraintsKt.m1783constrainWidthK40F9xA(constraints, MathKt.roundToInt(Size.getWidth-impl(jM2280calculateScaledSizeE7KxVPU))), 0, ConstraintsKt.m1782constrainHeightK40F9xA(constraints, MathKt.roundToInt(Size.getHeight-impl(jM2280calculateScaledSizeE7KxVPU))), 0, 10, null);
        }
        fM2315constrainHeightK40F9xA = iM1767getMinHeightimpl;
        long jM2280calculateScaledSizeE7KxVPU2 = m2280calculateScaledSizeE7KxVPU(SizeKt.Size(fM1768getMinWidthimpl, fM2315constrainHeightK40F9xA));
        return Constraints.m1757copyZbe2FdA$default(constraints, ConstraintsKt.m1783constrainWidthK40F9xA(constraints, MathKt.roundToInt(Size.getWidth-impl(jM2280calculateScaledSizeE7KxVPU2))), 0, ConstraintsKt.m1782constrainHeightK40F9xA(constraints, MathKt.roundToInt(Size.getHeight-impl(jM2280calculateScaledSizeE7KxVPU2))), 0, 10, null);
    }

    public void draw(ContentDrawScope contentDrawScope) {
        long jM2280calculateScaledSizeE7KxVPU = m2280calculateScaledSizeE7KxVPU(contentDrawScope.getSize-NH-jbRc());
        long j = this.alignment.align-KFBX0sM(UtilsKt.m2318toIntSizeuvyYCjk(jM2280calculateScaledSizeE7KxVPU), UtilsKt.m2318toIntSizeuvyYCjk(contentDrawScope.getSize-NH-jbRc()), contentDrawScope.getLayoutDirection());
        DrawScope drawScope = (DrawScope) contentDrawScope;
        float fM1959component1impl = IntOffset.m1959component1impl(j);
        float fM1960component2impl = IntOffset.m1960component2impl(j);
        drawScope.getDrawContext().getTransform().translate(fM1959component1impl, fM1960component2impl);
        this.painter.draw-x_KDEd0(drawScope, jM2280calculateScaledSizeE7KxVPU, this.alpha, this.colorFilter);
        drawScope.getDrawContext().getTransform().translate(-fM1959component1impl, -fM1960component2impl);
        contentDrawScope.drawContent();
    }
}
