package androidx.compose.p002ui.layout;

import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.ui.unit.IntSize;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0007\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J%\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00042\u0006\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u0007H\u0010¢\u0006\u0002\b\t¨\u0006\n"}, d2 = {"Landroidx/compose/ui/layout/HorizontalRuler;", "Landroidx/compose/ui/layout/Ruler;", "()V", "calculateCoordinate", "", "coordinate", "sourceCoordinates", "Landroidx/compose/ui/layout/LayoutCoordinates;", "targetCoordinates", "calculateCoordinate$ui_release", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class HorizontalRuler extends Ruler {
    public static final int $stable = 0;

    public HorizontalRuler() {
        super(null);
    }

    @Override
    public float calculateCoordinate$ui_release(float coordinate, LayoutCoordinates sourceCoordinates, LayoutCoordinates targetCoordinates) {
        return Offset.m4347getYimpl(targetCoordinates.mo6041localPositionOfR5De75A(sourceCoordinates, OffsetKt.Offset(IntSize.getWidth-impl(sourceCoordinates.mo6040getSizeYbymL2g()) / 2.0f, coordinate)));
    }
}
