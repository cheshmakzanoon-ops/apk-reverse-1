package androidx.compose.p002ui.graphics.drawscope;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.graphics.Canvas;
import androidx.compose.p002ui.graphics.InlineClassHelperKt;
import androidx.compose.p002ui.graphics.Path;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\f\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0002¨\u0006\u0003"}, d2 = {"asDrawTransform", "Landroidx/compose/ui/graphics/drawscope/DrawTransform;", "Landroidx/compose/ui/graphics/drawscope/DrawContext;", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class CanvasDrawScopeKt {
    public static final DrawTransform asDrawTransform(final DrawContext drawContext) {
        return new DrawTransform() {
            @Override
            public long mo5107getSizeNHjbRc() {
                return drawContext.mo5102getSizeNHjbRc();
            }

            @Override
            public long mo5106getCenterF1C5BW0() {
                return SizeKt.m4425getCenteruvyYCjk(mo5107getSizeNHjbRc());
            }

            @Override
            public void inset(float left, float top, float right, float bottom) {
                Canvas canvas = drawContext.getCanvas();
                DrawContext drawContext2 = drawContext;
                long jSize = SizeKt.Size(Size.m4415getWidthimpl(mo5107getSizeNHjbRc()) - (right + left), Size.m4412getHeightimpl(mo5107getSizeNHjbRc()) - (bottom + top));
                if (!(Size.m4415getWidthimpl(jSize) >= 0.0f && Size.m4412getHeightimpl(jSize) >= 0.0f)) {
                    InlineClassHelperKt.throwIllegalArgumentException("Width and height must be greater than or equal to zero");
                }
                drawContext2.mo5103setSizeuvyYCjk(jSize);
                canvas.translate(left, top);
            }

            @Override
            public void mo5105clipRectN_I0leg(float left, float top, float right, float bottom, int clipOp) {
                drawContext.getCanvas().mo4441clipRectN_I0leg(left, top, right, bottom, clipOp);
            }

            @Override
            public void mo5104clipPathmtrdDE(Path path, int clipOp) {
                drawContext.getCanvas().mo4440clipPathmtrdDE(path, clipOp);
            }

            @Override
            public void translate(float left, float top) {
                drawContext.getCanvas().translate(left, top);
            }

            @Override
            public void mo5108rotateUv8p0NA(float degrees, long pivot) {
                Canvas canvas = drawContext.getCanvas();
                canvas.translate(Offset.m4346getXimpl(pivot), Offset.m4347getYimpl(pivot));
                canvas.rotate(degrees);
                canvas.translate(-Offset.m4346getXimpl(pivot), -Offset.m4347getYimpl(pivot));
            }

            @Override
            public void mo5109scale0AR0LA0(float scaleX, float scaleY, long pivot) {
                Canvas canvas = drawContext.getCanvas();
                canvas.translate(Offset.m4346getXimpl(pivot), Offset.m4347getYimpl(pivot));
                canvas.scale(scaleX, scaleY);
                canvas.translate(-Offset.m4346getXimpl(pivot), -Offset.m4347getYimpl(pivot));
            }

            @Override
            public void mo5110transform58bKbWc(float[] matrix) {
                drawContext.getCanvas().mo4443concat58bKbWc(matrix);
            }
        };
    }
}
