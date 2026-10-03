package androidx.compose.foundation.lazy.layout;

import androidx.compose.p002ui.geometry.InlineClassHelperKt;
import androidx.compose.p002ui.geometry.Size;
import androidx.compose.p002ui.geometry.SizeKt;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.ui.unit.Dp;
import androidx.compose.ui.unit.DpKt;
import androidx.compose.ui.unit.DpSize;
import androidx.compose.ui.unit.TextUnit;
import androidx.compose.ui.unit.TextUnitType;
import java.util.List;
import kotlin.Metadata;

@Metadata(d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0007\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0018\u0002\n\u0000\bw\u0018\u00002\u00020\u0001J(\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH&ø\u0001\u0000¢\u0006\u0004\b\t\u0010\nJ\u0016\u0010\u000b\u001a\u00020\f*\u00020\rH\u0017ø\u0001\u0000¢\u0006\u0004\b\u000e\u0010\u000fJ\u0019\u0010\u000b\u001a\u00020\f*\u00020\u0010H\u0017ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0012J\u0019\u0010\u000b\u001a\u00020\f*\u00020\u0006H\u0017ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u0013J\u0016\u0010\u0014\u001a\u00020\u0015*\u00020\u0016H\u0017ø\u0001\u0000¢\u0006\u0004\b\u0017\u0010\u0018J\u0016\u0010\u0019\u001a\u00020\u0016*\u00020\u0015H\u0017ø\u0001\u0000¢\u0006\u0004\b\u001a\u0010\u0018J\u0016\u0010\u001b\u001a\u00020\r*\u00020\fH\u0017ø\u0001\u0000¢\u0006\u0004\b\u001c\u0010\u001dJ\u0019\u0010\u001b\u001a\u00020\r*\u00020\u0010H\u0017ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001dJ\u0019\u0010\u001b\u001a\u00020\r*\u00020\u0006H\u0017ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001e\u0010\u001f\u0082\u0001\u0001 ø\u0001\u0002\u0082\u0002\u0011\n\u0005\b¡\u001e0\u0001\n\u0002\b!\n\u0004\b!0\u0001¨\u0006!À\u0006\u0001"}, d2 = {"Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScope;", "Landroidx/compose/ui/layout/MeasureScope;", "measure", "", "Landroidx/compose/ui/layout/Placeable;", "index", "", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-0kLqBqw", "(IJ)Ljava/util/List;", "toDp", "Landroidx/compose/ui/unit/Dp;", "Landroidx/compose/ui/unit/TextUnit;", "toDp-GaN1DYA", "(J)F", "", "toDp-u2uoSUM", "(F)F", "(I)F", "toDpSize", "Landroidx/compose/ui/unit/DpSize;", "Landroidx/compose/ui/geometry/Size;", "toDpSize-k-rfVVM", "(J)J", "toSize", "toSize-XkaWNTQ", "toSp", "toSp-0xMU5do", "(F)J", "toSp-kPz2Gy4", "(I)J", "Landroidx/compose/foundation/lazy/layout/LazyLayoutMeasureScopeImpl;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface LazyLayoutMeasureScope extends MeasureScope {
    List<Placeable> mo1222measure0kLqBqw(int index, long constraints);

    float mo1223toDpGaN1DYA(long j);

    float mo1224toDpu2uoSUM(float f);

    float mo1225toDpu2uoSUM(int i);

    long mo1226toDpSizekrfVVM(long j);

    long mo1227toSizeXkaWNTQ(long j);

    long mo1228toSp0xMU5do(float f);

    long mo1229toSpkPz2Gy4(float f);

    long mo1230toSpkPz2Gy4(int i);

    public final class CC {
        public static float m1231$default$toDpGaN1DYA(LazyLayoutMeasureScope _this, long j) {
            if (!TextUnitType.equals-impl0(TextUnit.getType-UIouoOA(j), TextUnitType.Companion.getSp-UIouoOA())) {
                throw new IllegalStateException("Only Sp can convert to Px".toString());
            }
            return Dp.constructor-impl(TextUnit.getValue-impl(j) * _this.getFontScale());
        }

        public static long m1235$default$toSizeXkaWNTQ(LazyLayoutMeasureScope _this, long j) {
            return j != InlineClassHelperKt.UnspecifiedPackedFloats ? SizeKt.Size(_this.toPx-0680j_4(DpSize.getWidth-D9Ej5fM(j)), _this.toPx-0680j_4(DpSize.getHeight-D9Ej5fM(j))) : Size.INSTANCE.m4423getUnspecifiedNHjbRc();
        }

        public static long m1234$default$toDpSizekrfVVM(LazyLayoutMeasureScope _this, long j) {
            return j != InlineClassHelperKt.UnspecifiedPackedFloats ? DpKt.DpSize-YgX7TsA(_this.mo1224toDpu2uoSUM(Size.m4415getWidthimpl(j)), _this.mo1224toDpu2uoSUM(Size.m4412getHeightimpl(j))) : DpSize.Companion.getUnspecified-MYxV2XQ();
        }
    }
}
