package androidx.compose.p000ui.text.android;

import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.Rect;
import android.graphics.RectF;
import androidx.constraintlayout.widget.ConstraintLayout;
import com.facebook.appevents.internal.ViewHierarchyConstants;
import kotlin.Metadata;

@Metadata(d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0010\b\n\u0000\bÃ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH\u0007J\u0018\u0010\t\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\u000bH\u0007J\u0018\u0010\t\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\n\u001a\u00020\fH\u0007J0\u0010\t\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u000e2\u0006\u0010\u0010\u001a\u00020\u000e2\u0006\u0010\u0011\u001a\u00020\u000eH\u0007J0\u0010\t\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\r\u001a\u00020\u00122\u0006\u0010\u000f\u001a\u00020\u00122\u0006\u0010\u0010\u001a\u00020\u00122\u0006\u0010\u0011\u001a\u00020\u0012H\u0007¨\u0006\u0013"}, d2 = {"Landroidx/compose/ui/text/android/CanvasCompatO;", "", "()V", "clipOutPath", "", "canvas", "Landroid/graphics/Canvas;", "path", "Landroid/graphics/Path;", "clipOutRect", "rect", "Landroid/graphics/Rect;", "Landroid/graphics/RectF;", ViewHierarchyConstants.DIMENSION_LEFT_KEY, "", ViewHierarchyConstants.DIMENSION_TOP_KEY, "right", "bottom", "", "ui-text_release"}, k = 1, mv = {1, 8, 0}, xi = ConstraintLayout.LayoutParams.Table.LAYOUT_CONSTRAINT_VERTICAL_CHAINSTYLE)
final class CanvasCompatO {
    public static final CanvasCompatO INSTANCE = new CanvasCompatO();

    private CanvasCompatO() {
    }

    public final boolean clipOutRect(Canvas canvas, RectF rect) {
        return canvas.clipOutRect(rect);
    }

    public final boolean clipOutRect(Canvas canvas, Rect rect) {
        return canvas.clipOutRect(rect);
    }

    public final boolean clipOutRect(Canvas canvas, float left, float top, float right, float bottom) {
        return canvas.clipOutRect(left, top, right, bottom);
    }

    public final boolean clipOutRect(Canvas canvas, int left, int top, int right, int bottom) {
        return canvas.clipOutRect(left, top, right, bottom);
    }

    public final boolean clipOutPath(Canvas canvas, Path path) {
        return canvas.clipOutPath(path);
    }
}
