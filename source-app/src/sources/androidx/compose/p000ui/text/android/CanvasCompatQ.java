package androidx.compose.p000ui.text.android;

import android.graphics.BlendMode;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.RenderNode;
import android.graphics.text.MeasuredText;
import androidx.activity.ComponentDialog$;
import androidx.compose.ui.graphics.Api26Bitmap$;
import androidx.constraintlayout.core.motion.utils.TypedValues;
import androidx.constraintlayout.widget.ConstraintLayout;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000`\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0014\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\u0002\bÃ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007J \u0010\u0007\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH\u0007J\u0018\u0010\u0007\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\b\u001a\u00020\fH\u0007J \u0010\u0007\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\b\u001a\u00020\f2\u0006\u0010\n\u001a\u00020\u000bH\u0007JH\u0010\r\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\u00112\u0006\u0010\u0012\u001a\u00020\u00112\u0006\u0010\u0013\u001a\u00020\u000f2\u0006\u0010\u0014\u001a\u00020\u00112\u0006\u0010\u0015\u001a\u00020\u00112\u0006\u0010\u0016\u001a\u00020\u0017H\u0007J8\u0010\r\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u0013\u001a\u00020\u000f2\u0006\u0010\u001a\u001a\u00020\u00192\u0006\u0010\u0016\u001a\u00020\u0017H\u0007J\u0018\u0010\u001b\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u001c\u001a\u00020\u001dH\u0007JX\u0010\u001e\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\t2\u0006\u0010\"\u001a\u00020\t2\u0006\u0010#\u001a\u00020\t2\u0006\u0010$\u001a\u00020\t2\u0006\u0010%\u001a\u00020\u00112\u0006\u0010&\u001a\u00020\u00112\u0006\u0010'\u001a\u00020(2\u0006\u0010\u0016\u001a\u00020\u0017H\u0007J\u0010\u0010)\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006*"}, d2 = {"Landroidx/compose/ui/text/android/CanvasCompatQ;", "", "()V", "disableZ", "", "canvas", "Landroid/graphics/Canvas;", "drawColor", TypedValues.Custom.S_COLOR, "", "mode", "Landroid/graphics/BlendMode;", "", "drawDoubleRoundRect", "outer", "Landroid/graphics/RectF;", "outerRx", "", "outerRy", "inner", "innerRx", "innerRy", "paint", "Landroid/graphics/Paint;", "outerRadii", "", "innerRadii", "drawRenderNode", "renderNode", "Landroid/graphics/RenderNode;", "drawTextRun", "text", "Landroid/graphics/text/MeasuredText;", "start", "end", "contextStart", "contextEnd", "x", "y", "isRtl", "", "enableZ", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
final class CanvasCompatQ {
    public static final CanvasCompatQ INSTANCE = new CanvasCompatQ();

    private CanvasCompatQ() {
    }

    public final void enableZ(Canvas canvas) {
        Api26Bitmap$.ExternalSyntheticApiModelOutline0.m(canvas);
    }

    public final void disableZ(Canvas canvas) {
        Api26Bitmap$.ExternalSyntheticApiModelOutline0.m$1(canvas);
    }

    public final void drawColor(Canvas canvas, long color) {
        canvas.drawColor(color);
    }

    public final void drawColor(Canvas canvas, int color, BlendMode mode) {
        canvas.drawColor(color, mode);
    }

    public final void drawColor(Canvas canvas, long color, BlendMode mode) {
        canvas.drawColor(color, mode);
    }

    public final void drawDoubleRoundRect(Canvas canvas, RectF outer, float outerRx, float outerRy, RectF inner, float innerRx, float innerRy, Paint paint) {
        canvas.drawDoubleRoundRect(outer, outerRx, outerRy, inner, innerRx, innerRy, paint);
    }

    public final void drawDoubleRoundRect(Canvas canvas, RectF outer, float[] outerRadii, RectF inner, float[] innerRadii, Paint paint) {
        canvas.drawDoubleRoundRect(outer, outerRadii, inner, innerRadii, paint);
    }

    public final void drawTextRun(Canvas canvas, MeasuredText text, int start, int end, int contextStart, int contextEnd, float x, float y, boolean isRtl, Paint paint) {
        canvas.drawTextRun(text, start, end, contextStart, contextEnd, x, y, isRtl, paint);
    }

    public final void drawRenderNode(Canvas canvas, RenderNode renderNode) {
        ComponentDialog$.ExternalSyntheticApiModelOutline0.m(canvas, renderNode);
    }
}
