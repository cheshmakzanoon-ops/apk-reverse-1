package androidx.compose.p002ui.layout;

import androidx.compose.p002ui.geometry.Rect;
import androidx.compose.p002ui.internal.InlineClassHelperKt;
import androidx.compose.p002ui.node.LookaheadCapablePlaceable;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.DpRect;
import androidx.compose.ui.unit.FontScaling;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.MapsKt;
import kotlin.jvm.functions.Function1;

@MeasureScopeMarker
@Metadata(d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001Jd\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00052\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00050\b2\u001b\b\u0002\u0010\n\u001a\u0015\u0012\u0004\u0012\u00020\f\u0012\u0004\u0012\u00020\r\u0018\u00010\u000b¢\u0006\u0002\b\u000e2\u0017\u0010\u000f\u001a\u0013\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\r0\u000b¢\u0006\u0002\b\u000eH\u0016JG\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u00052\u0014\b\u0002\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00050\b2\u0017\u0010\u000f\u001a\u0013\u0012\u0004\u0012\u00020\u0010\u0012\u0004\u0012\u00020\r0\u000b¢\u0006\u0002\b\u000eH\u0016ø\u0001\u0000\u0082\u0002\u0006\n\u0004\b!0\u0001¨\u0006\u0011À\u0006\u0003"}, d2 = {"Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "layout", "Landroidx/compose/ui/layout/MeasureResult;", "width", "", "height", "alignmentLines", "", "Landroidx/compose/ui/layout/AlignmentLine;", "rulers", "Lkotlin/Function1;", "Landroidx/compose/ui/layout/RulerScope;", "", "Lkotlin/ExtensionFunctionType;", "placementBlock", "Landroidx/compose/ui/layout/Placeable$PlacementScope;", "ui_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface MeasureScope extends IntrinsicMeasureScope {
    MeasureResult layout(int width, int height, Map<AlignmentLine, Integer> alignmentLines, Function1<? super Placeable.PlacementScope, Unit> placementBlock);

    MeasureResult layout(int width, int height, Map<AlignmentLine, Integer> alignmentLines, Function1<? super RulerScope, Unit> rulers, Function1<? super Placeable.PlacementScope, Unit> placementBlock);

    public final class CC {
        public static MeasureResult layout$default(MeasureScope measureScope, int i, int i2, Map map, Function1 function1, int i3, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: layout");
            }
            if ((i3 & 4) != 0) {
                map = MapsKt.emptyMap();
            }
            return measureScope.layout(i, i2, map, function1);
        }

        public static MeasureResult $default$layout(MeasureScope _this, int i, int i2, Map map, Function1 function1) {
            return _this.layout(i, i2, map, null, function1);
        }

        public static MeasureResult layout$default(MeasureScope measureScope, int i, int i2, Map map, Function1 function1, Function1 function2, int i3, Object obj) {
            if (obj != null) {
                throw new UnsupportedOperationException("Super calls with default arguments not supported in this target, function: layout");
            }
            if ((i3 & 4) != 0) {
                map = MapsKt.emptyMap();
            }
            Map map2 = map;
            if ((i3 & 8) != 0) {
                function1 = null;
            }
            return measureScope.layout(i, i2, map2, function1, function2);
        }

        public static MeasureResult $default$layout(MeasureScope _this, int i, int i2, Map map, Function1 function1, Function1 function2) {
            if (!((i & (-16777216)) == 0 && ((-16777216) & i2) == 0)) {
                InlineClassHelperKt.throwIllegalStateException("Size(" + i + " x " + i2 + ") is out of range. Each dimension must be between 0 and 16777215.");
            }
            return new MeasureResult(i, i2, map, function1, _this, function2) {
                final Function1<Placeable.PlacementScope, Unit> $placementBlock;
                final int $width;
                private final Map<AlignmentLine, Integer> alignmentLines;
                private final int height;
                private final Function1<RulerScope, Unit> rulers;
                final MeasureScope this$0;
                private final int width;

                {
                    this.$width = i;
                    this.this$0 = _this;
                    this.$placementBlock = function2;
                    this.width = i;
                    this.height = i2;
                    this.alignmentLines = map;
                    this.rulers = function1;
                }

                @Override
                public int getWidth() {
                    return this.width;
                }

                @Override
                public int getHeight() {
                    return this.height;
                }

                @Override
                public Map<AlignmentLine, Integer> getAlignmentLines() {
                    return this.alignmentLines;
                }

                @Override
                public Function1<RulerScope, Unit> getRulers() {
                    return this.rulers;
                }

                @Override
                public void placeChildren() {
                    MeasureScope measureScope = this.this$0;
                    if (measureScope instanceof LookaheadCapablePlaceable) {
                        this.$placementBlock.invoke(((LookaheadCapablePlaceable) measureScope).getPlacementScope());
                    } else {
                        this.$placementBlock.invoke(new SimplePlacementScope(this.$width, this.this$0.getLayoutDirection()));
                    }
                }
            };
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    public static final class DefaultImpls {
        @Deprecated
        public static boolean isLookingAhead(MeasureScope measureScope) {
            return IntrinsicMeasureScope.CC.$default$isLookingAhead(measureScope);
        }

        @Deprecated
        public static int m6112roundToPxR2X_6o(MeasureScope measureScope, long j) {
            return Density.-CC.$default$roundToPx--R2X_6o(measureScope, j);
        }

        @Deprecated
        public static int m6113roundToPx0680j_4(MeasureScope measureScope, float f) {
            return Density.-CC.$default$roundToPx-0680j_4(measureScope, f);
        }

        @Deprecated
        public static float m6114toDpGaN1DYA(MeasureScope measureScope, long j) {
            return FontScaling.-CC.$default$toDp-GaN1DYA(measureScope, j);
        }

        @Deprecated
        public static float m6115toDpu2uoSUM(MeasureScope measureScope, float f) {
            return Density.-CC.$default$toDp-u2uoSUM(measureScope, f);
        }

        @Deprecated
        public static float m6116toDpu2uoSUM(MeasureScope measureScope, int i) {
            return Density.-CC.$default$toDp-u2uoSUM(measureScope, i);
        }

        @Deprecated
        public static long m6117toDpSizekrfVVM(MeasureScope measureScope, long j) {
            return Density.-CC.$default$toDpSize-k-rfVVM(measureScope, j);
        }

        @Deprecated
        public static float m6118toPxR2X_6o(MeasureScope measureScope, long j) {
            return Density.-CC.$default$toPx--R2X_6o(measureScope, j);
        }

        @Deprecated
        public static float m6119toPx0680j_4(MeasureScope measureScope, float f) {
            return Density.-CC.$default$toPx-0680j_4(measureScope, f);
        }

        @Deprecated
        public static Rect toRect(MeasureScope measureScope, DpRect dpRect) {
            return Density.-CC.$default$toRect(measureScope, dpRect);
        }

        @Deprecated
        public static long m6120toSizeXkaWNTQ(MeasureScope measureScope, long j) {
            return Density.-CC.$default$toSize-XkaWNTQ(measureScope, j);
        }

        @Deprecated
        public static long m6121toSp0xMU5do(MeasureScope measureScope, float f) {
            return FontScaling.-CC.$default$toSp-0xMU5do(measureScope, f);
        }

        @Deprecated
        public static long m6122toSpkPz2Gy4(MeasureScope measureScope, float f) {
            return Density.-CC.$default$toSp-kPz2Gy4(measureScope, f);
        }

        @Deprecated
        public static long m6123toSpkPz2Gy4(MeasureScope measureScope, int i) {
            return Density.-CC.$default$toSp-kPz2Gy4(measureScope, i);
        }

        @Deprecated
        public static MeasureResult layout(MeasureScope measureScope, int i, int i2, Map<AlignmentLine, Integer> map, Function1<? super Placeable.PlacementScope, Unit> function1) {
            return CC.$default$layout(measureScope, i, i2, map, function1);
        }

        @Deprecated
        public static MeasureResult layout(MeasureScope measureScope, int i, int i2, Map<AlignmentLine, Integer> map, Function1<? super RulerScope, Unit> function1, Function1<? super Placeable.PlacementScope, Unit> function2) {
            return CC.$default$layout(measureScope, i, i2, map, function1, function2);
        }
    }
}
