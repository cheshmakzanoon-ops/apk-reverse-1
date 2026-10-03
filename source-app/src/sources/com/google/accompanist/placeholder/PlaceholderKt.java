package com.google.accompanist.placeholder;

import androidx.compose.animation.core.FiniteAnimationSpec;
import androidx.compose.animation.core.Transition;
import androidx.compose.p000ui.unit.Density;
import androidx.compose.p000ui.unit.LayoutDirection;
import androidx.compose.runtime.Composer;
import androidx.compose.ui.ComposedModifierKt;
import androidx.compose.ui.Modifier;
import androidx.compose.ui.geometry.Size;
import androidx.compose.ui.geometry.SizeKt;
import androidx.compose.ui.graphics.Canvas;
import androidx.compose.ui.graphics.Color;
import androidx.compose.ui.graphics.ColorFilter;
import androidx.compose.ui.graphics.Outline;
import androidx.compose.ui.graphics.OutlineKt;
import androidx.compose.ui.graphics.Paint;
import androidx.compose.ui.graphics.RectangleShapeKt;
import androidx.compose.ui.graphics.Shape;
import androidx.compose.ui.graphics.drawscope.DrawScope;
import androidx.compose.ui.graphics.drawscope.DrawStyle;
import androidx.compose.ui.platform.InspectableValueKt;
import androidx.compose.ui.platform.InspectorInfo;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a[\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\b2\u0006\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\u00012\b\u0010\f\u001a\u0004\u0018\u00010\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fH\u0002ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0010\u0010\u0011\u001a\u0095\u0001\u0010\u0012\u001a\u00020\u0013*\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0005\u001a\u00020\u00062\b\b\u0002\u0010\u0003\u001a\u00020\u00042\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b2*\b\u0002\u0010\u0016\u001a$\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00150\u0018\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\u00190\u0017¢\u0006\u0002\b\u001a¢\u0006\u0002\b\u001b2*\b\u0002\u0010\u001c\u001a$\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00150\u0018\u0012\n\u0012\b\u0012\u0004\u0012\u00020\n0\u00190\u0017¢\u0006\u0002\b\u001a¢\u0006\u0002\b\u001bø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u001d\u0010\u001e\u001a.\u0010\u001f\u001a\u00020 *\u00020\u00022\u0006\u0010!\u001a\u00020\"2\u0017\u0010#\u001a\u0013\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020 0\u0017¢\u0006\u0002\b\u001bH\u0082\b\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b\u0019¨\u0006$"}, d2 = {"drawPlaceholder", "Landroidx/compose/ui/graphics/Outline;", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "shape", "Landroidx/compose/ui/graphics/Shape;", TypedValues.Custom.S_COLOR, "Landroidx/compose/ui/graphics/Color;", "highlight", "Lcom/google/accompanist/placeholder/PlaceholderHighlight;", "progress", "", "lastOutline", "lastLayoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "lastSize", "Landroidx/compose/ui/geometry/Size;", "drawPlaceholder-hpmOzss", "(Landroidx/compose/ui/graphics/drawscope/DrawScope;Landroidx/compose/ui/graphics/Shape;JLcom/google/accompanist/placeholder/PlaceholderHighlight;FLandroidx/compose/ui/graphics/Outline;Landroidx/compose/ui/unit/LayoutDirection;Landroidx/compose/ui/geometry/Size;)Landroidx/compose/ui/graphics/Outline;", "placeholder", "Landroidx/compose/ui/Modifier;", "visible", "", "placeholderFadeTransitionSpec", "Lkotlin/Function1;", "Landroidx/compose/animation/core/Transition$Segment;", "Landroidx/compose/animation/core/FiniteAnimationSpec;", "Landroidx/compose/runtime/Composable;", "Lkotlin/ExtensionFunctionType;", "contentFadeTransitionSpec", "placeholder-cf5BqRc", "(Landroidx/compose/ui/Modifier;ZJLandroidx/compose/ui/graphics/Shape;Lcom/google/accompanist/placeholder/PlaceholderHighlight;Lkotlin/jvm/functions/Function3;Lkotlin/jvm/functions/Function3;)Landroidx/compose/ui/Modifier;", "withLayer", "", "paint", "Landroidx/compose/ui/graphics/Paint;", "drawBlock", "placeholder_release"}, k = 2, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
public final class PlaceholderKt {
    public static final Outline m2597drawPlaceholderhpmOzss(DrawScope drawScope, Shape shape, long j, PlaceholderHighlight placeholderHighlight, float f, Outline outline, LayoutDirection layoutDirection, Size size) {
        Outline outline2 = null;
        if (shape == RectangleShapeKt.getRectangleShape()) {
            DrawScope.-CC.drawRect-n-J9OG0$default(drawScope, j, 0L, 0L, 0.0f, (DrawStyle) null, (ColorFilter) null, 0, 126, (Object) null);
            if (placeholderHighlight != null) {
                DrawScope.-CC.drawRect-AsUm42w$default(drawScope, placeholderHighlight.mo2588brushd16Qtg0(f, drawScope.getSize-NH-jbRc()), 0L, 0L, placeholderHighlight.alpha(f), (DrawStyle) null, (ColorFilter) null, 0, 118, (Object) null);
            }
            return null;
        }
        if (Size.equals-impl(drawScope.getSize-NH-jbRc(), size) && drawScope.getLayoutDirection() == layoutDirection) {
            outline2 = outline;
        }
        if (outline2 == null) {
            outline2 = shape.createOutline-Pq9zytI(drawScope.getSize-NH-jbRc(), drawScope.getLayoutDirection(), (Density) drawScope);
        }
        OutlineKt.drawOutline-wDX37Ww$default(drawScope, outline2, j, 0.0f, (DrawStyle) null, (ColorFilter) null, 0, 60, (Object) null);
        if (placeholderHighlight != null) {
            OutlineKt.drawOutline-hn5TExg$default(drawScope, outline2, placeholderHighlight.mo2588brushd16Qtg0(f, drawScope.getSize-NH-jbRc()), placeholderHighlight.alpha(f), (DrawStyle) null, (ColorFilter) null, 0, 56, (Object) null);
        }
        return outline2;
    }

    public static final Modifier m2598placeholdercf5BqRc(Modifier modifier, final boolean z, final long j, final Shape shape, final PlaceholderHighlight placeholderHighlight, Function3<? super Transition.Segment<Boolean>, ? super Composer, ? super Integer, ? extends FiniteAnimationSpec<Float>> function3, Function3<? super Transition.Segment<Boolean>, ? super Composer, ? super Integer, ? extends FiniteAnimationSpec<Float>> function4) {
        Intrinsics.checkNotNullParameter(modifier, "$this$placeholder");
        Intrinsics.checkNotNullParameter(shape, "shape");
        Intrinsics.checkNotNullParameter(function3, "placeholderFadeTransitionSpec");
        Intrinsics.checkNotNullParameter(function4, "contentFadeTransitionSpec");
        return ComposedModifierKt.composed(modifier, InspectableValueKt.isDebugInspectorInfoEnabled() ? new Function1<InspectorInfo, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((InspectorInfo) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(InspectorInfo inspectorInfo) {
                Intrinsics.checkNotNullParameter(inspectorInfo, "$this$null");
                inspectorInfo.setName("placeholder");
                inspectorInfo.setValue(Boolean.valueOf(z));
                inspectorInfo.getProperties().set("visible", Boolean.valueOf(z));
                inspectorInfo.getProperties().set(TypedValues.Custom.S_COLOR, Color.box-impl(j));
                inspectorInfo.getProperties().set("highlight", placeholderHighlight);
                inspectorInfo.getProperties().set("shape", shape);
            }
        } : InspectableValueKt.getNoInspectorInfo(), new PlaceholderKt$placeholder$4(function3, function4, placeholderHighlight, z, j, shape));
    }

    private static final void withLayer(DrawScope drawScope, Paint paint, Function1<? super DrawScope, Unit> function1) {
        Canvas canvas = drawScope.getDrawContext().getCanvas();
        canvas.saveLayer(SizeKt.toRect-uvyYCjk(drawScope.getSize-NH-jbRc()), paint);
        function1.invoke(drawScope);
        canvas.restore();
    }
}
