package androidx.compose.p002ui.layout;

import androidx.compose.ui.unit.Constraints;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0002\u0010\bJ\u0010\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0010H\u0016J\u0010\u0010\u0012\u001a\u00020\u00102\u0006\u0010\u0013\u001a\u00020\u0010H\u0016J\u001a\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u0017H\u0016ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019J\u0010\u0010\u001a\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u0010H\u0016J\u0010\u0010\u001b\u001a\u00020\u00102\u0006\u0010\u0013\u001a\u00020\u0010H\u0016R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u000b\u001a\u0004\u0018\u00010\f8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001c"}, d2 = {"Landroidx/compose/ui/layout/DefaultIntrinsicMeasurable;", "Landroidx/compose/ui/layout/Measurable;", "measurable", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "minMax", "Landroidx/compose/ui/layout/IntrinsicMinMax;", "widthHeight", "Landroidx/compose/ui/layout/IntrinsicWidthHeight;", "(Landroidx/compose/ui/layout/IntrinsicMeasurable;Landroidx/compose/ui/layout/IntrinsicMinMax;Landroidx/compose/ui/layout/IntrinsicWidthHeight;)V", "getMeasurable", "()Landroidx/compose/ui/layout/IntrinsicMeasurable;", "parentData", "", "getParentData", "()Ljava/lang/Object;", "maxIntrinsicHeight", "", "width", "maxIntrinsicWidth", "height", "measure", "Landroidx/compose/ui/layout/Placeable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-BRTryo0", "(J)Landroidx/compose/ui/layout/Placeable;", "minIntrinsicHeight", "minIntrinsicWidth", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class DefaultIntrinsicMeasurable implements Measurable {
    public static final int $stable = 8;
    private final IntrinsicMeasurable measurable;
    private final IntrinsicMinMax minMax;
    private final IntrinsicWidthHeight widthHeight;

    public DefaultIntrinsicMeasurable(IntrinsicMeasurable intrinsicMeasurable, IntrinsicMinMax intrinsicMinMax, IntrinsicWidthHeight intrinsicWidthHeight) {
        this.measurable = intrinsicMeasurable;
        this.minMax = intrinsicMinMax;
        this.widthHeight = intrinsicWidthHeight;
    }

    public final IntrinsicMeasurable getMeasurable() {
        return this.measurable;
    }

    @Override
    public Object getParentData() {
        return this.measurable.getParentData();
    }

    @Override
    public Placeable mo6026measureBRTryo0(long constraints) {
        int iMinIntrinsicHeight;
        int iMinIntrinsicWidth;
        IntrinsicWidthHeight intrinsicWidthHeight = this.widthHeight;
        IntrinsicWidthHeight intrinsicWidthHeight2 = IntrinsicWidthHeight.Width;
        int i = LayoutKt.LargeDimension;
        if (intrinsicWidthHeight == intrinsicWidthHeight2) {
            if (this.minMax == IntrinsicMinMax.Max) {
                iMinIntrinsicWidth = this.measurable.maxIntrinsicWidth(Constraints.getMaxHeight-impl(constraints));
            } else {
                iMinIntrinsicWidth = this.measurable.minIntrinsicWidth(Constraints.getMaxHeight-impl(constraints));
            }
            if (Constraints.getHasBoundedHeight-impl(constraints)) {
                i = Constraints.getMaxHeight-impl(constraints);
            }
            return new FixedSizeIntrinsicsPlaceable(iMinIntrinsicWidth, i);
        }
        if (this.minMax == IntrinsicMinMax.Max) {
            iMinIntrinsicHeight = this.measurable.maxIntrinsicHeight(Constraints.getMaxWidth-impl(constraints));
        } else {
            iMinIntrinsicHeight = this.measurable.minIntrinsicHeight(Constraints.getMaxWidth-impl(constraints));
        }
        if (Constraints.getHasBoundedWidth-impl(constraints)) {
            i = Constraints.getMaxWidth-impl(constraints);
        }
        return new FixedSizeIntrinsicsPlaceable(i, iMinIntrinsicHeight);
    }

    @Override
    public int minIntrinsicWidth(int height) {
        return this.measurable.minIntrinsicWidth(height);
    }

    @Override
    public int maxIntrinsicWidth(int height) {
        return this.measurable.maxIntrinsicWidth(height);
    }

    @Override
    public int minIntrinsicHeight(int width) {
        return this.measurable.minIntrinsicHeight(width);
    }

    @Override
    public int maxIntrinsicHeight(int width) {
        return this.measurable.maxIntrinsicHeight(width);
    }
}
