package androidx.compose.p002ui.draw;

import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.geometry.InlineClassHelperKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.ColorFilter;
import androidx.compose.p002ui.graphics.drawscope.ContentDrawScope;
import androidx.compose.p002ui.graphics.painter.Painter;
import androidx.compose.p002ui.layout.ContentScale;
import androidx.compose.p002ui.layout.IntrinsicMeasurable;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.layout.ScaleFactorKt;
import androidx.compose.p002ui.node.DrawModifierNode;
import androidx.compose.p002ui.node.LayoutModifierNode;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntSizeKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000|\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001e\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u00012\u00020\u00022\u00020\u0003B?\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\b\b\u0002\u0010\f\u001a\u00020\r\u0012\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000f¢\u0006\u0002\u0010\u0010J\u001a\u0010-\u001a\u00020.2\u0006\u0010/\u001a\u00020.H\u0002ø\u0001\u0000¢\u0006\u0004\b0\u00101J\u001a\u00102\u001a\u0002032\u0006\u00104\u001a\u000203H\u0002ø\u0001\u0000¢\u0006\u0004\b5\u00101J\b\u00106\u001a\u000207H\u0016J\f\u00108\u001a\u000209*\u00020:H\u0016J\u0016\u0010;\u001a\u00020\u0007*\u00020.H\u0002ø\u0001\u0000¢\u0006\u0004\b<\u0010=J\u0016\u0010>\u001a\u00020\u0007*\u00020.H\u0002ø\u0001\u0000¢\u0006\u0004\b?\u0010=J\u001c\u0010@\u001a\u00020A*\u00020B2\u0006\u0010C\u001a\u00020D2\u0006\u0010E\u001a\u00020AH\u0016J\u001c\u0010F\u001a\u00020A*\u00020B2\u0006\u0010C\u001a\u00020D2\u0006\u0010G\u001a\u00020AH\u0016J&\u0010H\u001a\u00020I*\u00020J2\u0006\u0010C\u001a\u00020K2\u0006\u00104\u001a\u000203H\u0016ø\u0001\u0000¢\u0006\u0004\bL\u0010MJ\u001c\u0010N\u001a\u00020A*\u00020B2\u0006\u0010C\u001a\u00020D2\u0006\u0010E\u001a\u00020AH\u0016J\u001c\u0010O\u001a\u00020A*\u00020B2\u0006\u0010C\u001a\u00020D2\u0006\u0010G\u001a\u00020AH\u0016R\u001a\u0010\b\u001a\u00020\tX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0011\u0010\u0012\"\u0004\b\u0013\u0010\u0014R\u001a\u0010\f\u001a\u00020\rX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0015\u0010\u0016\"\u0004\b\u0017\u0010\u0018R\u001c\u0010\u000e\u001a\u0004\u0018\u00010\u000fX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0019\u0010\u001a\"\u0004\b\u001b\u0010\u001cR\u001a\u0010\n\u001a\u00020\u000bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001d\u0010\u001e\"\u0004\b\u001f\u0010 R\u001a\u0010\u0004\u001a\u00020\u0005X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b!\u0010\"\"\u0004\b#\u0010$R\u0014\u0010%\u001a\u00020\u00078VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b&\u0010'R\u001a\u0010\u0006\u001a\u00020\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b(\u0010'\"\u0004\b)\u0010*R\u0014\u0010+\u001a\u00020\u00078BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b,\u0010'\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006P"}, d2 = {"Landroidx/compose/ui/draw/PainterNode;", "Landroidx/compose/ui/node/LayoutModifierNode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/node/DrawModifierNode;", "painter", "Landroidx/compose/ui/graphics/painter/Painter;", "sizeToIntrinsics", "", "alignment", "Landroidx/compose/ui/Alignment;", "contentScale", "Landroidx/compose/ui/layout/ContentScale;", "alpha", "", "colorFilter", "Landroidx/compose/ui/graphics/ColorFilter;", "(Landroidx/compose/ui/graphics/painter/Painter;ZLandroidx/compose/ui/Alignment;Landroidx/compose/ui/layout/ContentScale;FLandroidx/compose/ui/graphics/ColorFilter;)V", "getAlignment", "()Landroidx/compose/ui/Alignment;", "setAlignment", "(Landroidx/compose/ui/Alignment;)V", "getAlpha", "()F", "setAlpha", "(F)V", "getColorFilter", "()Landroidx/compose/ui/graphics/ColorFilter;", "setColorFilter", "(Landroidx/compose/ui/graphics/ColorFilter;)V", "getContentScale", "()Landroidx/compose/ui/layout/ContentScale;", "setContentScale", "(Landroidx/compose/ui/layout/ContentScale;)V", "getPainter", "()Landroidx/compose/ui/graphics/painter/Painter;", "setPainter", "(Landroidx/compose/ui/graphics/painter/Painter;)V", "shouldAutoInvalidate", "getShouldAutoInvalidate", "()Z", "getSizeToIntrinsics", "setSizeToIntrinsics", "(Z)V", "useIntrinsicSize", "getUseIntrinsicSize", "calculateScaledSize", "Landroidx/compose/ui/geometry/Size;", "dstSize", "calculateScaledSize-E7KxVPU", "(J)J", "modifyConstraints", "Landroidx/compose/ui/unit/Constraints;", "constraints", "modifyConstraints-ZezNO4M", "toString", "", "draw", "", "Landroidx/compose/ui/graphics/drawscope/ContentDrawScope;", "hasSpecifiedAndFiniteHeight", "hasSpecifiedAndFiniteHeight-uvyYCjk", "(J)Z", "hasSpecifiedAndFiniteWidth", "hasSpecifiedAndFiniteWidth-uvyYCjk", "maxIntrinsicHeight", "", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "measurable", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "width", "maxIntrinsicWidth", "height", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Measurable;J)Landroidx/compose/ui/layout/MeasureResult;", "minIntrinsicHeight", "minIntrinsicWidth", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class PainterNode extends Modifier.Node implements LayoutModifierNode, DrawModifierNode {
    private Alignment alignment;
    private float alpha;
    private ColorFilter colorFilter;
    private ContentScale contentScale;
    private Painter painter;
    private boolean sizeToIntrinsics;

    @Override
    public boolean getShouldAutoInvalidate() {
        return false;
    }

    @Override
    public void onMeasureResultChanged() {
        DrawModifierNode.CC.$default$onMeasureResultChanged(this);
    }

    public final Painter getPainter() {
        return this.painter;
    }

    public final void setPainter(Painter painter) {
        this.painter = painter;
    }

    public final boolean getSizeToIntrinsics() {
        return this.sizeToIntrinsics;
    }

    public final void setSizeToIntrinsics(boolean z) {
        this.sizeToIntrinsics = z;
    }

    public PainterNode(Painter painter, boolean z, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(painter, z, (i & 4) != 0 ? Alignment.INSTANCE.getCenter() : alignment, (i & 8) != 0 ? ContentScale.INSTANCE.getInside() : contentScale, (i & 16) != 0 ? 1.0f : f, (i & 32) != 0 ? null : colorFilter);
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

    public PainterNode(Painter painter, boolean z, Alignment alignment, ContentScale contentScale, float f, ColorFilter colorFilter) {
        this.painter = painter;
        this.sizeToIntrinsics = z;
        this.alignment = alignment;
        this.contentScale = contentScale;
        this.alpha = f;
        this.colorFilter = colorFilter;
    }

    private final boolean getUseIntrinsicSize() {
        return this.sizeToIntrinsics && this.painter.getIntrinsicSize() != InlineClassHelperKt.UnspecifiedPackedFloats;
    }

    @Override
    public MeasureResult mo352measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
        final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(m4234modifyConstraintsZezNO4M(j));
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
        if (getUseIntrinsicSize()) {
            long jM4234modifyConstraintsZezNO4M = m4234modifyConstraintsZezNO4M(ConstraintsKt.Constraints$default(0, 0, 0, i, 7, (Object) null));
            return Math.max(Constraints.getMinWidth-impl(jM4234modifyConstraintsZezNO4M), intrinsicMeasurable.minIntrinsicWidth(i));
        }
        return intrinsicMeasurable.minIntrinsicWidth(i);
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (getUseIntrinsicSize()) {
            long jM4234modifyConstraintsZezNO4M = m4234modifyConstraintsZezNO4M(ConstraintsKt.Constraints$default(0, 0, 0, i, 7, (Object) null));
            return Math.max(Constraints.getMinWidth-impl(jM4234modifyConstraintsZezNO4M), intrinsicMeasurable.maxIntrinsicWidth(i));
        }
        return intrinsicMeasurable.maxIntrinsicWidth(i);
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (getUseIntrinsicSize()) {
            long jM4234modifyConstraintsZezNO4M = m4234modifyConstraintsZezNO4M(ConstraintsKt.Constraints$default(0, i, 0, 0, 13, (Object) null));
            return Math.max(Constraints.getMinHeight-impl(jM4234modifyConstraintsZezNO4M), intrinsicMeasurable.minIntrinsicHeight(i));
        }
        return intrinsicMeasurable.minIntrinsicHeight(i);
    }

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        if (getUseIntrinsicSize()) {
            long jM4234modifyConstraintsZezNO4M = m4234modifyConstraintsZezNO4M(ConstraintsKt.Constraints$default(0, i, 0, 0, 13, (Object) null));
            return Math.max(Constraints.getMinHeight-impl(jM4234modifyConstraintsZezNO4M), intrinsicMeasurable.maxIntrinsicHeight(i));
        }
        return intrinsicMeasurable.maxIntrinsicHeight(i);
    }

    private final long m4231calculateScaledSizeE7KxVPU(long dstSize) {
        float fM4415getWidthimpl;
        float fM4412getHeightimpl;
        if (!getUseIntrinsicSize()) {
            return dstSize;
        }
        if (!m4233hasSpecifiedAndFiniteWidthuvyYCjk(this.painter.getIntrinsicSize())) {
            fM4415getWidthimpl = Size.m4415getWidthimpl(dstSize);
        } else {
            fM4415getWidthimpl = Size.m4415getWidthimpl(this.painter.getIntrinsicSize());
        }
        if (!m4232hasSpecifiedAndFiniteHeightuvyYCjk(this.painter.getIntrinsicSize())) {
            fM4412getHeightimpl = Size.m4412getHeightimpl(dstSize);
        } else {
            fM4412getHeightimpl = Size.m4412getHeightimpl(this.painter.getIntrinsicSize());
        }
        long jSize = SizeKt.Size(fM4415getWidthimpl, fM4412getHeightimpl);
        if (Size.m4415getWidthimpl(dstSize) != 0.0f && Size.m4412getHeightimpl(dstSize) != 0.0f) {
            return ScaleFactorKt.m6175timesUQTWf7w(jSize, this.contentScale.mo6017computeScaleFactorH7hwNQA(jSize, dstSize));
        }
        return Size.INSTANCE.m4424getZeroNHjbRc();
    }

    private final long m4234modifyConstraintsZezNO4M(long constraints) {
        int iRound;
        int iRound2;
        boolean z = Constraints.getHasBoundedWidth-impl(constraints) && Constraints.getHasBoundedHeight-impl(constraints);
        boolean z2 = Constraints.getHasFixedWidth-impl(constraints) && Constraints.getHasFixedHeight-impl(constraints);
        if ((!getUseIntrinsicSize() && z) || z2) {
            return Constraints.copy-Zbe2FdA$default(constraints, Constraints.getMaxWidth-impl(constraints), 0, Constraints.getMaxHeight-impl(constraints), 0, 10, (Object) null);
        }
        long jMo5304getIntrinsicSizeNHjbRc = this.painter.getIntrinsicSize();
        if (!m4233hasSpecifiedAndFiniteWidthuvyYCjk(jMo5304getIntrinsicSizeNHjbRc)) {
            iRound = Constraints.getMinWidth-impl(constraints);
        } else {
            iRound = Math.round(Size.m4415getWidthimpl(jMo5304getIntrinsicSizeNHjbRc));
        }
        if (!m4232hasSpecifiedAndFiniteHeightuvyYCjk(jMo5304getIntrinsicSizeNHjbRc)) {
            iRound2 = Constraints.getMinHeight-impl(constraints);
        } else {
            iRound2 = Math.round(Size.m4412getHeightimpl(jMo5304getIntrinsicSizeNHjbRc));
        }
        long jM4231calculateScaledSizeE7KxVPU = m4231calculateScaledSizeE7KxVPU(SizeKt.Size(ConstraintsKt.constrainWidth-K40F9xA(constraints, iRound), ConstraintsKt.constrainHeight-K40F9xA(constraints, iRound2)));
        return Constraints.copy-Zbe2FdA$default(constraints, ConstraintsKt.constrainWidth-K40F9xA(constraints, Math.round(Size.m4415getWidthimpl(jM4231calculateScaledSizeE7KxVPU))), 0, ConstraintsKt.constrainHeight-K40F9xA(constraints, Math.round(Size.m4412getHeightimpl(jM4231calculateScaledSizeE7KxVPU))), 0, 10, (Object) null);
    }

    @Override
    public void draw(ContentDrawScope contentDrawScope) {
        float fM4415getWidthimpl;
        float fM4412getHeightimpl;
        long jM4424getZeroNHjbRc;
        long jMo5304getIntrinsicSizeNHjbRc = this.painter.getIntrinsicSize();
        if (m4233hasSpecifiedAndFiniteWidthuvyYCjk(jMo5304getIntrinsicSizeNHjbRc)) {
            fM4415getWidthimpl = Size.m4415getWidthimpl(jMo5304getIntrinsicSizeNHjbRc);
        } else {
            fM4415getWidthimpl = Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc());
        }
        if (m4232hasSpecifiedAndFiniteHeightuvyYCjk(jMo5304getIntrinsicSizeNHjbRc)) {
            fM4412getHeightimpl = Size.m4412getHeightimpl(jMo5304getIntrinsicSizeNHjbRc);
        } else {
            fM4412getHeightimpl = Size.m4412getHeightimpl(contentDrawScope.mo5083getSizeNHjbRc());
        }
        long jSize = SizeKt.Size(fM4415getWidthimpl, fM4412getHeightimpl);
        if (Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc()) != 0.0f && Size.m4412getHeightimpl(contentDrawScope.mo5083getSizeNHjbRc()) != 0.0f) {
            jM4424getZeroNHjbRc = ScaleFactorKt.m6175timesUQTWf7w(jSize, this.contentScale.mo6017computeScaleFactorH7hwNQA(jSize, contentDrawScope.mo5083getSizeNHjbRc()));
        } else {
            jM4424getZeroNHjbRc = Size.INSTANCE.m4424getZeroNHjbRc();
        }
        long j = jM4424getZeroNHjbRc;
        long jMo4171alignKFBX0sM = this.alignment.mo4171alignKFBX0sM(IntSizeKt.IntSize(Math.round(Size.m4415getWidthimpl(j)), Math.round(Size.m4412getHeightimpl(j))), IntSizeKt.IntSize(Math.round(Size.m4415getWidthimpl(contentDrawScope.mo5083getSizeNHjbRc())), Math.round(Size.m4412getHeightimpl(contentDrawScope.mo5083getSizeNHjbRc()))), contentDrawScope.getLayoutDirection());
        float f = IntOffset.getX-impl(jMo4171alignKFBX0sM);
        float f2 = IntOffset.getY-impl(jMo4171alignKFBX0sM);
        ContentDrawScope contentDrawScope2 = contentDrawScope;
        contentDrawScope2.getDrawContext().getTransform().translate(f, f2);
        try {
            this.painter.m5310drawx_KDEd0(contentDrawScope2, j, this.alpha, this.colorFilter);
            contentDrawScope2.getDrawContext().getTransform().translate(-f, -f2);
            contentDrawScope.drawContent();
        } catch (Throwable th) {
            contentDrawScope2.getDrawContext().getTransform().translate(-f, -f2);
            throw th;
        }
    }

    private final boolean m4233hasSpecifiedAndFiniteWidthuvyYCjk(long j) {
        if (!Size.m4411equalsimpl0(j, Size.INSTANCE.m4423getUnspecifiedNHjbRc())) {
            float fM4415getWidthimpl = Size.m4415getWidthimpl(j);
            if (!Float.isInfinite(fM4415getWidthimpl) && !Float.isNaN(fM4415getWidthimpl)) {
                return true;
            }
        }
        return false;
    }

    private final boolean m4232hasSpecifiedAndFiniteHeightuvyYCjk(long j) {
        if (!Size.m4411equalsimpl0(j, Size.INSTANCE.m4423getUnspecifiedNHjbRc())) {
            float fM4412getHeightimpl = Size.m4412getHeightimpl(j);
            if (!Float.isInfinite(fM4412getHeightimpl) && !Float.isNaN(fM4412getHeightimpl)) {
                return true;
            }
        }
        return false;
    }

    public String toString() {
        return "PainterModifier(painter=" + this.painter + ", sizeToIntrinsics=" + this.sizeToIntrinsics + ", alignment=" + this.alignment + ", alpha=" + this.alpha + ", colorFilter=" + this.colorFilter + ')';
    }
}
