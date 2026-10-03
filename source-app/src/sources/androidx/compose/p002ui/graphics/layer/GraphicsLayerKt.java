package androidx.compose.p002ui.graphics.layer;

import androidx.compose.p002ui.geometry.CornerRadius;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.geometry.RoundRect;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.Outline;
import androidx.compose.p002ui.graphics.drawscope.DrawScope;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000 \n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u001a\u0012\u0010\u0002\u001a\u00020\u0003*\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006\u001a\u0012\u0010\u0007\u001a\u00020\u0003*\u00020\u00062\u0006\u0010\b\u001a\u00020\t\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0086T¢\u0006\u0002\n\u0000¨\u0006\n"}, d2 = {"DefaultCameraDistance", "", "drawLayer", "", "Landroidx/compose/ui/graphics/drawscope/DrawScope;", "graphicsLayer", "Landroidx/compose/ui/graphics/layer/GraphicsLayer;", "setOutline", "outline", "Landroidx/compose/ui/graphics/Outline;", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class GraphicsLayerKt {
    public static final float DefaultCameraDistance = 8.0f;

    public static final void setOutline(GraphicsLayer graphicsLayer, Outline outline) {
        if (outline instanceof Outline.Rectangle) {
            Outline.Rectangle rectangle = (Outline.Rectangle) outline;
            graphicsLayer.m5282setRectOutlinetz77jQw(OffsetKt.Offset(rectangle.getRect().getLeft(), rectangle.getRect().getTop()), SizeKt.Size(rectangle.getRect().getWidth(), rectangle.getRect().getHeight()));
            return;
        }
        if (outline instanceof Outline.Generic) {
            graphicsLayer.setPathOutline(((Outline.Generic) outline).getPath());
            return;
        }
        if (outline instanceof Outline.Rounded) {
            Outline.Rounded rounded = (Outline.Rounded) outline;
            if (rounded.getRoundRectPath() != null) {
                graphicsLayer.setPathOutline(rounded.getRoundRectPath());
            } else {
                RoundRect roundRect = rounded.getRoundRect();
                graphicsLayer.m5283setRoundRectOutlineTNW_H78(OffsetKt.Offset(roundRect.getLeft(), roundRect.getTop()), SizeKt.Size(roundRect.getWidth(), roundRect.getHeight()), CornerRadius.m4321getXimpl(roundRect.m4394getBottomLeftCornerRadiuskKHJgLs()));
            }
        }
    }

    public static final void drawLayer(DrawScope drawScope, GraphicsLayer graphicsLayer) {
        graphicsLayer.draw$ui_graphics_release(drawScope.getDrawContext().getCanvas(), drawScope.getDrawContext().getGraphicsLayer());
    }
}
