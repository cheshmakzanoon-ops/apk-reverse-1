package androidx.compose.p002ui.draw;

import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.graphics.GraphicsLayerModifierKt;
import androidx.compose.p002ui.graphics.GraphicsLayerScope;
import androidx.compose.p002ui.graphics.RectangleShapeKt;
import androidx.compose.p002ui.graphics.RenderEffectKt;
import androidx.compose.p002ui.graphics.Shape;
import androidx.compose.p002ui.graphics.TileMode;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000\u0016\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\u001a(\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005H\u0007ø\u0001\u0000¢\u0006\u0004\b\u0006\u0010\u0007\u001a0\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0006\u0010\b\u001a\u00020\u00032\u0006\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005H\u0007ø\u0001\u0000¢\u0006\u0004\b\n\u0010\u000b\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\f"}, d2 = {"blur", "Landroidx/compose/ui/Modifier;", "radius", "Landroidx/compose/ui/unit/Dp;", "edgeTreatment", "Landroidx/compose/ui/draw/BlurredEdgeTreatment;", "blur-F8QBwvs", "(Landroidx/compose/ui/Modifier;FLandroidx/compose/ui/graphics/Shape;)Landroidx/compose/ui/Modifier;", "radiusX", "radiusY", "blur-1fqS-gw", "(Landroidx/compose/ui/Modifier;FFLandroidx/compose/ui/graphics/Shape;)Landroidx/compose/ui/Modifier;", "ui_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class BlurKt {
    public static Modifier m4201blur1fqSgw$default(Modifier modifier, float f, float f2, BlurredEdgeTreatment blurredEdgeTreatment, int i, Object obj) {
        if ((i & 4) != 0) {
            blurredEdgeTreatment = BlurredEdgeTreatment.m4204boximpl(BlurredEdgeTreatment.INSTANCE.m4211getRectangleGoahg());
        }
        return m4200blur1fqSgw(modifier, f, f2, blurredEdgeTreatment.m4210unboximpl());
    }

    public static final Modifier m4200blur1fqSgw(Modifier modifier, final float f, final float f2, final Shape shape) {
        final boolean z;
        final int iM4984getDecal3opZhB0;
        if (shape != null) {
            iM4984getDecal3opZhB0 = TileMode.INSTANCE.m4983getClamp3opZhB0();
            z = true;
        } else {
            z = false;
            iM4984getDecal3opZhB0 = TileMode.INSTANCE.m4984getDecal3opZhB0();
        }
        float f3 = 0;
        return ((Dp.compareTo-0680j_4(f, Dp.constructor-impl(f3)) <= 0 || Dp.compareTo-0680j_4(f2, Dp.constructor-impl(f3)) <= 0) && !z) ? modifier : GraphicsLayerModifierKt.graphicsLayer(modifier, new Function1<GraphicsLayerScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((GraphicsLayerScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(GraphicsLayerScope graphicsLayerScope) {
                float f4 = graphicsLayerScope.toPx-0680j_4(f);
                float f5 = graphicsLayerScope.toPx-0680j_4(f2);
                graphicsLayerScope.setRenderEffect((f4 <= 0.0f || f5 <= 0.0f) ? null : RenderEffectKt.m4906BlurEffect3YTHUZs(f4, f5, iM4984getDecal3opZhB0));
                Shape rectangleShape = shape;
                if (rectangleShape == null) {
                    rectangleShape = RectangleShapeKt.getRectangleShape();
                }
                graphicsLayerScope.setShape(rectangleShape);
                graphicsLayerScope.setClip(z);
            }
        });
    }

    public static Modifier m4203blurF8QBwvs$default(Modifier modifier, float f, BlurredEdgeTreatment blurredEdgeTreatment, int i, Object obj) {
        if ((i & 2) != 0) {
            blurredEdgeTreatment = BlurredEdgeTreatment.m4204boximpl(BlurredEdgeTreatment.INSTANCE.m4211getRectangleGoahg());
        }
        return m4202blurF8QBwvs(modifier, f, blurredEdgeTreatment.m4210unboximpl());
    }

    public static final Modifier m4202blurF8QBwvs(Modifier modifier, float f, Shape shape) {
        return m4200blur1fqSgw(modifier, f, f, shape);
    }
}
