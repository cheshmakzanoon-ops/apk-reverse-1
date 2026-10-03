package androidx.compose.p002ui.graphics;

import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\"\u001c\u0010\u0000\u001a\u00020\u00018\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0002\u0010\u0003\u001a\u0004\b\u0004\u0010\u0005¨\u0006\u0006"}, d2 = {"RectangleShape", "Landroidx/compose/ui/graphics/Shape;", "getRectangleShape$annotations", "()V", "getRectangleShape", "()Landroidx/compose/ui/graphics/Shape;", "ui-graphics_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class RectangleShapeKt {
    private static final Shape RectangleShape = new Shape() {
        @Override
        public Outline.Rectangle mo572createOutlinePq9zytI(long size, LayoutDirection layoutDirection, Density density) {
            return new Outline.Rectangle(SizeKt.m4436toRectuvyYCjk(size));
        }

        public String toString() {
            return "RectangleShape";
        }
    };

    public static void getRectangleShape$annotations() {
    }

    public static final Shape getRectangleShape() {
        return RectangleShape;
    }
}
