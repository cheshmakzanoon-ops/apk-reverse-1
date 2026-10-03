package androidx.compose.foundation.text.selection;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.Rect;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u000b\b\u0080\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\"\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH ø\u0001\u0000¢\u0006\u0004\b\t\u0010\nJ*\u0010\u000b\u001a\u00020\f2\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\r\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u0006H\u0000ø\u0001\u0000¢\u0006\u0004\b\u000f\u0010\u0010J\u001e\u0010\u0011\u001a\u00020\f*\u00020\b2\u0006\u0010\u0012\u001a\u00020\u0006H\u0002ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014j\u0002\b\u0015j\u0002\b\u0016\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u0017"}, d2 = {"Landroidx/compose/foundation/text/selection/SelectionMode;", "", "(Ljava/lang/String;I)V", "compare", "", "position", "Landroidx/compose/ui/geometry/Offset;", "bounds", "Landroidx/compose/ui/geometry/Rect;", "compare-3MmeM6k$foundation_release", "(JLandroidx/compose/ui/geometry/Rect;)I", "isSelected", "", "start", "end", "isSelected-2x9bVx0$foundation_release", "(Landroidx/compose/ui/geometry/Rect;JJ)Z", "containsInclusive", "offset", "containsInclusive-Uv8p0NA", "(Landroidx/compose/ui/geometry/Rect;J)Z", "Vertical", "Horizontal", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public enum SelectionMode {
    Vertical {
        @Override
        public int mo1925compare3MmeM6k$foundation_release(long position, Rect bounds) {
            if (SelectionManagerKt.m1916containsInclusiveUv8p0NA(bounds, position)) {
                return 0;
            }
            if (Offset.m4347getYimpl(position) < bounds.getTop()) {
                return -1;
            }
            return (Offset.m4346getXimpl(position) >= bounds.getLeft() || Offset.m4347getYimpl(position) >= bounds.getBottom()) ? 1 : -1;
        }
    },
    Horizontal {
        @Override
        public int mo1925compare3MmeM6k$foundation_release(long position, Rect bounds) {
            if (SelectionManagerKt.m1916containsInclusiveUv8p0NA(bounds, position)) {
                return 0;
            }
            if (Offset.m4346getXimpl(position) < bounds.getLeft()) {
                return -1;
            }
            return (Offset.m4347getYimpl(position) >= bounds.getTop() || Offset.m4346getXimpl(position) >= bounds.getRight()) ? 1 : -1;
        }
    };

    SelectionMode(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    public abstract int mo1925compare3MmeM6k$foundation_release(long position, Rect bounds);

    public final boolean m1926isSelected2x9bVx0$foundation_release(Rect bounds, long start, long end) {
        if (m1924containsInclusiveUv8p0NA(bounds, start) || m1924containsInclusiveUv8p0NA(bounds, end)) {
            return true;
        }
        return (mo1925compare3MmeM6k$foundation_release(start, bounds) > 0) ^ (mo1925compare3MmeM6k$foundation_release(end, bounds) > 0);
    }

    private final boolean m1924containsInclusiveUv8p0NA(Rect rect, long j) {
        float left = rect.getLeft();
        float right = rect.getRight();
        float fM4346getXimpl = Offset.m4346getXimpl(j);
        if (left <= fM4346getXimpl && fM4346getXimpl <= right) {
            float top = rect.getTop();
            float bottom = rect.getBottom();
            float fM4347getYimpl = Offset.m4347getYimpl(j);
            if (top <= fM4347getYimpl && fM4347getYimpl <= bottom) {
                return true;
            }
        }
        return false;
    }
}
