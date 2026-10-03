package androidx.compose.foundation.layout;

import androidx.compose.p002ui.layout.IntrinsicMeasurable;
import java.util.List;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u000b\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J$\u0010\u0003\u001a\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u0004J$\u0010\n\u001a\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\u000b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u0004J$\u0010\f\u001a\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u0004J$\u0010\r\u001a\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\u000b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u0004J$\u0010\u000e\u001a\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u0004J$\u0010\u000f\u001a\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\u000b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u0004J$\u0010\u0010\u001a\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u0004J$\u0010\u0011\u001a\u00020\u00042\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00020\u00070\u00062\u0006\u0010\u000b\u001a\u00020\u00042\u0006\u0010\t\u001a\u00020\u0004¨\u0006\u0012"}, d2 = {"Landroidx/compose/foundation/layout/IntrinsicMeasureBlocks;", "", "()V", "HorizontalMaxHeight", "", "measurables", "", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "availableWidth", "mainAxisSpacing", "HorizontalMaxWidth", "availableHeight", "HorizontalMinHeight", "HorizontalMinWidth", "VerticalMaxHeight", "VerticalMaxWidth", "VerticalMinHeight", "VerticalMinWidth", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class IntrinsicMeasureBlocks {
    public static final int $stable = 0;
    public static final IntrinsicMeasureBlocks INSTANCE = new IntrinsicMeasureBlocks();

    private IntrinsicMeasureBlocks() {
    }

    public final int HorizontalMinWidth(List<? extends IntrinsicMeasurable> measurables, int availableHeight, int mainAxisSpacing) {
        if (measurables.isEmpty()) {
            return 0;
        }
        int size = measurables.size();
        int iMax = 0;
        int i = 0;
        float f = 0.0f;
        for (int i2 = 0; i2 < size; i2++) {
            IntrinsicMeasurable intrinsicMeasurable = measurables.get(i2);
            float weight = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable));
            int iMinIntrinsicWidth = intrinsicMeasurable.minIntrinsicWidth(availableHeight);
            if (weight == 0.0f) {
                i += iMinIntrinsicWidth;
            } else if (weight > 0.0f) {
                f += weight;
                iMax = Math.max(iMax, Math.round(iMinIntrinsicWidth / weight));
            }
        }
        return Math.round(iMax * f) + i + ((measurables.size() - 1) * mainAxisSpacing);
    }

    public final int VerticalMinWidth(List<? extends IntrinsicMeasurable> measurables, int availableHeight, int mainAxisSpacing) {
        int iRound;
        if (measurables.isEmpty()) {
            return 0;
        }
        int iMin = Math.min((measurables.size() - 1) * mainAxisSpacing, availableHeight);
        int size = measurables.size();
        int iMax = 0;
        float f = 0.0f;
        for (int i = 0; i < size; i++) {
            IntrinsicMeasurable intrinsicMeasurable = measurables.get(i);
            float weight = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable));
            if (weight == 0.0f) {
                int iMin2 = Math.min(intrinsicMeasurable.maxIntrinsicHeight(Integer.MAX_VALUE), availableHeight == Integer.MAX_VALUE ? Integer.MAX_VALUE : availableHeight - iMin);
                iMin += iMin2;
                iMax = Math.max(iMax, intrinsicMeasurable.minIntrinsicWidth(iMin2));
            } else if (weight > 0.0f) {
                f += weight;
            }
        }
        if (f == 0.0f) {
            iRound = 0;
        } else {
            iRound = availableHeight == Integer.MAX_VALUE ? Integer.MAX_VALUE : Math.round(Math.max(availableHeight - iMin, 0) / f);
        }
        int size2 = measurables.size();
        for (int i2 = 0; i2 < size2; i2++) {
            IntrinsicMeasurable intrinsicMeasurable2 = measurables.get(i2);
            float weight2 = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable2));
            if (weight2 > 0.0f) {
                iMax = Math.max(iMax, intrinsicMeasurable2.minIntrinsicWidth(iRound != Integer.MAX_VALUE ? Math.round(iRound * weight2) : Integer.MAX_VALUE));
            }
        }
        return iMax;
    }

    public final int HorizontalMinHeight(List<? extends IntrinsicMeasurable> measurables, int availableWidth, int mainAxisSpacing) {
        int iRound;
        if (measurables.isEmpty()) {
            return 0;
        }
        int iMin = Math.min((measurables.size() - 1) * mainAxisSpacing, availableWidth);
        int size = measurables.size();
        int iMax = 0;
        float f = 0.0f;
        for (int i = 0; i < size; i++) {
            IntrinsicMeasurable intrinsicMeasurable = measurables.get(i);
            float weight = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable));
            if (weight == 0.0f) {
                int iMin2 = Math.min(intrinsicMeasurable.maxIntrinsicWidth(Integer.MAX_VALUE), availableWidth == Integer.MAX_VALUE ? Integer.MAX_VALUE : availableWidth - iMin);
                iMin += iMin2;
                iMax = Math.max(iMax, intrinsicMeasurable.minIntrinsicHeight(iMin2));
            } else if (weight > 0.0f) {
                f += weight;
            }
        }
        if (f == 0.0f) {
            iRound = 0;
        } else {
            iRound = availableWidth == Integer.MAX_VALUE ? Integer.MAX_VALUE : Math.round(Math.max(availableWidth - iMin, 0) / f);
        }
        int size2 = measurables.size();
        for (int i2 = 0; i2 < size2; i2++) {
            IntrinsicMeasurable intrinsicMeasurable2 = measurables.get(i2);
            float weight2 = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable2));
            if (weight2 > 0.0f) {
                iMax = Math.max(iMax, intrinsicMeasurable2.minIntrinsicHeight(iRound != Integer.MAX_VALUE ? Math.round(iRound * weight2) : Integer.MAX_VALUE));
            }
        }
        return iMax;
    }

    public final int VerticalMinHeight(List<? extends IntrinsicMeasurable> measurables, int availableWidth, int mainAxisSpacing) {
        if (measurables.isEmpty()) {
            return 0;
        }
        int size = measurables.size();
        int iMax = 0;
        int i = 0;
        float f = 0.0f;
        for (int i2 = 0; i2 < size; i2++) {
            IntrinsicMeasurable intrinsicMeasurable = measurables.get(i2);
            float weight = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable));
            int iMinIntrinsicHeight = intrinsicMeasurable.minIntrinsicHeight(availableWidth);
            if (weight == 0.0f) {
                i += iMinIntrinsicHeight;
            } else if (weight > 0.0f) {
                f += weight;
                iMax = Math.max(iMax, Math.round(iMinIntrinsicHeight / weight));
            }
        }
        return Math.round(iMax * f) + i + ((measurables.size() - 1) * mainAxisSpacing);
    }

    public final int HorizontalMaxWidth(List<? extends IntrinsicMeasurable> measurables, int availableHeight, int mainAxisSpacing) {
        if (measurables.isEmpty()) {
            return 0;
        }
        int size = measurables.size();
        int iMax = 0;
        int i = 0;
        float f = 0.0f;
        for (int i2 = 0; i2 < size; i2++) {
            IntrinsicMeasurable intrinsicMeasurable = measurables.get(i2);
            float weight = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable));
            int iMaxIntrinsicWidth = intrinsicMeasurable.maxIntrinsicWidth(availableHeight);
            if (weight == 0.0f) {
                i += iMaxIntrinsicWidth;
            } else if (weight > 0.0f) {
                f += weight;
                iMax = Math.max(iMax, Math.round(iMaxIntrinsicWidth / weight));
            }
        }
        return Math.round(iMax * f) + i + ((measurables.size() - 1) * mainAxisSpacing);
    }

    public final int VerticalMaxWidth(List<? extends IntrinsicMeasurable> measurables, int availableHeight, int mainAxisSpacing) {
        int iRound;
        if (measurables.isEmpty()) {
            return 0;
        }
        int iMin = Math.min((measurables.size() - 1) * mainAxisSpacing, availableHeight);
        int size = measurables.size();
        int iMax = 0;
        float f = 0.0f;
        for (int i = 0; i < size; i++) {
            IntrinsicMeasurable intrinsicMeasurable = measurables.get(i);
            float weight = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable));
            if (weight == 0.0f) {
                int iMin2 = Math.min(intrinsicMeasurable.maxIntrinsicHeight(Integer.MAX_VALUE), availableHeight == Integer.MAX_VALUE ? Integer.MAX_VALUE : availableHeight - iMin);
                iMin += iMin2;
                iMax = Math.max(iMax, intrinsicMeasurable.maxIntrinsicWidth(iMin2));
            } else if (weight > 0.0f) {
                f += weight;
            }
        }
        if (f == 0.0f) {
            iRound = 0;
        } else {
            iRound = availableHeight == Integer.MAX_VALUE ? Integer.MAX_VALUE : Math.round(Math.max(availableHeight - iMin, 0) / f);
        }
        int size2 = measurables.size();
        for (int i2 = 0; i2 < size2; i2++) {
            IntrinsicMeasurable intrinsicMeasurable2 = measurables.get(i2);
            float weight2 = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable2));
            if (weight2 > 0.0f) {
                iMax = Math.max(iMax, intrinsicMeasurable2.maxIntrinsicWidth(iRound != Integer.MAX_VALUE ? Math.round(iRound * weight2) : Integer.MAX_VALUE));
            }
        }
        return iMax;
    }

    public final int HorizontalMaxHeight(List<? extends IntrinsicMeasurable> measurables, int availableWidth, int mainAxisSpacing) {
        int iRound;
        if (measurables.isEmpty()) {
            return 0;
        }
        int iMin = Math.min((measurables.size() - 1) * mainAxisSpacing, availableWidth);
        int size = measurables.size();
        int iMax = 0;
        float f = 0.0f;
        for (int i = 0; i < size; i++) {
            IntrinsicMeasurable intrinsicMeasurable = measurables.get(i);
            float weight = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable));
            if (weight == 0.0f) {
                int iMin2 = Math.min(intrinsicMeasurable.maxIntrinsicWidth(Integer.MAX_VALUE), availableWidth == Integer.MAX_VALUE ? Integer.MAX_VALUE : availableWidth - iMin);
                iMin += iMin2;
                iMax = Math.max(iMax, intrinsicMeasurable.maxIntrinsicHeight(iMin2));
            } else if (weight > 0.0f) {
                f += weight;
            }
        }
        if (f == 0.0f) {
            iRound = 0;
        } else {
            iRound = availableWidth == Integer.MAX_VALUE ? Integer.MAX_VALUE : Math.round(Math.max(availableWidth - iMin, 0) / f);
        }
        int size2 = measurables.size();
        for (int i2 = 0; i2 < size2; i2++) {
            IntrinsicMeasurable intrinsicMeasurable2 = measurables.get(i2);
            float weight2 = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable2));
            if (weight2 > 0.0f) {
                iMax = Math.max(iMax, intrinsicMeasurable2.maxIntrinsicHeight(iRound != Integer.MAX_VALUE ? Math.round(iRound * weight2) : Integer.MAX_VALUE));
            }
        }
        return iMax;
    }

    public final int VerticalMaxHeight(List<? extends IntrinsicMeasurable> measurables, int availableWidth, int mainAxisSpacing) {
        if (measurables.isEmpty()) {
            return 0;
        }
        int size = measurables.size();
        int iMax = 0;
        int i = 0;
        float f = 0.0f;
        for (int i2 = 0; i2 < size; i2++) {
            IntrinsicMeasurable intrinsicMeasurable = measurables.get(i2);
            float weight = RowColumnImplKt.getWeight(RowColumnImplKt.getRowColumnParentData(intrinsicMeasurable));
            int iMaxIntrinsicHeight = intrinsicMeasurable.maxIntrinsicHeight(availableWidth);
            if (weight == 0.0f) {
                i += iMaxIntrinsicHeight;
            } else if (weight > 0.0f) {
                f += weight;
                iMax = Math.max(iMax, Math.round(iMaxIntrinsicHeight / weight));
            }
        }
        return Math.round(iMax * f) + i + ((measurables.size() - 1) * mainAxisSpacing);
    }
}
