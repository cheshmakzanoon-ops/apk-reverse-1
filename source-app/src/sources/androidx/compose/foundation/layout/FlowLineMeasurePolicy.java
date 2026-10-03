package androidx.compose.foundation.layout;

import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.ui.unit.LayoutDirection;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u0000p\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0015\n\u0002\b\u0007\n\u0002\u0010\u0002\n\u0002\b\u0004\b`\u0018\u00002\u00020\u0001J=\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u00142\u0006\u0010\u0015\u001a\u00020\u00142\u0006\u0010\u0016\u001a\u00020\u00142\u0006\u0010\u0017\u001a\u00020\u00142\u0006\u0010\u0018\u001a\u00020\u000bH\u0016ø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\b\u0019\u0010\u001aJ2\u0010\u001b\u001a\u00020\u00142\u0006\u0010\u001c\u001a\u00020\u001d2\b\u0010\u001e\u001a\u0004\u0018\u00010\u001f2\u0006\u0010 \u001a\u00020\u00142\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020\u0014H\u0016Jg\u0010$\u001a\u00020%2\u000e\u0010&\u001a\n\u0012\u0006\u0012\u0004\u0018\u00010\u001d0'2\u0006\u0010(\u001a\u00020)2\u0006\u0010#\u001a\u00020\u00142\u0006\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020\u00142\u0006\u0010 \u001a\u00020\u00142\b\u0010-\u001a\u0004\u0018\u00010+2\u0006\u0010.\u001a\u00020\u00142\u0006\u0010/\u001a\u00020\u00142\u0006\u00100\u001a\u00020\u0014H\u0016¢\u0006\u0002\u00101J(\u00102\u001a\u0002032\u0006\u0010,\u001a\u00020\u00142\u0006\u00104\u001a\u00020+2\u0006\u0010*\u001a\u00020+2\u0006\u0010(\u001a\u00020)H\u0016J\f\u00105\u001a\u00020\u0014*\u00020\u001dH\u0016J\f\u00106\u001a\u00020\u0014*\u00020\u001dH\u0016R\u0012\u0010\u0002\u001a\u00020\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005R\u0012\u0010\u0006\u001a\u00020\u0007X¦\u0004¢\u0006\u0006\u001a\u0004\b\b\u0010\tR\u0012\u0010\n\u001a\u00020\u000bX¦\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\fR\u0012\u0010\r\u001a\u00020\u000eX¦\u0004¢\u0006\u0006\u001a\u0004\b\u000f\u0010\u0010ø\u0001\u0002\u0082\u0002\u0011\n\u0002\b!\n\u0005\b¡\u001e0\u0001\n\u0004\b!0\u0001¨\u00067À\u0006\u0001"}, d2 = {"Landroidx/compose/foundation/layout/FlowLineMeasurePolicy;", "Landroidx/compose/foundation/layout/RowColumnMeasurePolicy;", "crossAxisAlignment", "Landroidx/compose/foundation/layout/CrossAxisAlignment;", "getCrossAxisAlignment", "()Landroidx/compose/foundation/layout/CrossAxisAlignment;", "horizontalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "getHorizontalArrangement", "()Landroidx/compose/foundation/layout/Arrangement$Horizontal;", "isHorizontal", "", "()Z", "verticalArrangement", "Landroidx/compose/foundation/layout/Arrangement$Vertical;", "getVerticalArrangement", "()Landroidx/compose/foundation/layout/Arrangement$Vertical;", "createConstraints", "Landroidx/compose/ui/unit/Constraints;", "mainAxisMin", "", "crossAxisMin", "mainAxisMax", "crossAxisMax", "isPrioritizing", "createConstraints-xF2OJ5Q", "(IIIIZ)J", "getCrossAxisPosition", "placeable", "Landroidx/compose/ui/layout/Placeable;", "rowColumnParentData", "Landroidx/compose/foundation/layout/RowColumnParentData;", "crossAxisLayoutSize", "layoutDirection", "Landroidx/compose/ui/unit/LayoutDirection;", "beforeCrossAxisAlignmentLine", "placeHelper", "Landroidx/compose/ui/layout/MeasureResult;", "placeables", "", "measureScope", "Landroidx/compose/ui/layout/MeasureScope;", "mainAxisPositions", "", "mainAxisLayoutSize", "crossAxisOffset", "currentLineIndex", "startIndex", "endIndex", "([Landroidx/compose/ui/layout/Placeable;Landroidx/compose/ui/layout/MeasureScope;I[III[IIII)Landroidx/compose/ui/layout/MeasureResult;", "populateMainAxisPositions", "", "childrenMainAxisSize", "crossAxisSize", "mainAxisSize", "foundation-layout_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public interface FlowLineMeasurePolicy extends RowColumnMeasurePolicy {
    @Override
    long mo949createConstraintsxF2OJ5Q(int mainAxisMin, int crossAxisMin, int mainAxisMax, int crossAxisMax, boolean isPrioritizing);

    @Override
    int crossAxisSize(Placeable placeable);

    CrossAxisAlignment getCrossAxisAlignment();

    int getCrossAxisPosition(Placeable placeable, RowColumnParentData rowColumnParentData, int crossAxisLayoutSize, LayoutDirection layoutDirection, int beforeCrossAxisAlignmentLine);

    Arrangement.Horizontal getHorizontalArrangement();

    Arrangement.Vertical getVerticalArrangement();

    boolean isHorizontal();

    @Override
    int mainAxisSize(Placeable placeable);

    @Override
    MeasureResult placeHelper(Placeable[] placeables, MeasureScope measureScope, int beforeCrossAxisAlignmentLine, int[] mainAxisPositions, int mainAxisLayoutSize, int crossAxisLayoutSize, int[] crossAxisOffset, int currentLineIndex, int startIndex, int endIndex);

    @Override
    void populateMainAxisPositions(int mainAxisLayoutSize, int[] childrenMainAxisSize, int[] mainAxisPositions, MeasureScope measureScope);

    public final class CC {
        public static int $default$mainAxisSize(FlowLineMeasurePolicy _this, Placeable placeable) {
            return _this.isHorizontal() ? placeable.getMeasuredWidth() : placeable.getMeasuredHeight();
        }

        public static int $default$crossAxisSize(FlowLineMeasurePolicy _this, Placeable placeable) {
            return _this.isHorizontal() ? placeable.getMeasuredHeight() : placeable.getMeasuredWidth();
        }

        public static long m971$default$createConstraintsxF2OJ5Q(FlowLineMeasurePolicy _this, int i, int i2, int i3, int i4, boolean z) {
            if (_this.isHorizontal()) {
                return RowKt.createRowConstraints(z, i, i2, i3, i4);
            }
            return ColumnKt.createColumnConstraints(z, i, i2, i3, i4);
        }

        public static MeasureResult $default$placeHelper(final FlowLineMeasurePolicy _this, final Placeable[] placeableArr, final MeasureScope measureScope, final int i, final int[] iArr, int i2, final int i3, final int[] iArr2, final int i4, final int i5, final int i6) {
            int i7;
            int i8;
            if (_this.isHorizontal()) {
                i8 = i2;
                i7 = i3;
            } else {
                i7 = i2;
                i8 = i3;
            }
            return MeasureScope.CC.layout$default(measureScope, i8, i7, null, new Function1<Placeable.PlacementScope, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(Placeable.PlacementScope placementScope) {
                    int[] iArr3 = iArr2;
                    int i9 = iArr3 != null ? iArr3[i4] : 0;
                    for (int i10 = i5; i10 < i6; i10++) {
                        Placeable placeable = placeableArr[i10];
                        Intrinsics.checkNotNull(placeable);
                        int crossAxisPosition = _this.getCrossAxisPosition(placeable, RowColumnImplKt.getRowColumnParentData(placeable), i3, measureScope.getLayoutDirection(), i) + i9;
                        if (_this.isHorizontal()) {
                            Placeable.PlacementScope.place$default(placementScope, placeable, iArr[i10 - i5], crossAxisPosition, 0.0f, 4, null);
                        } else {
                            Placeable.PlacementScope.place$default(placementScope, placeable, crossAxisPosition, iArr[i10 - i5], 0.0f, 4, null);
                        }
                    }
                }
            }, 4, null);
        }

        public static int $default$getCrossAxisPosition(FlowLineMeasurePolicy _this, Placeable placeable, RowColumnParentData rowColumnParentData, int i, LayoutDirection layoutDirection, int i2) {
            CrossAxisAlignment crossAxisAlignment;
            if (rowColumnParentData == null || (crossAxisAlignment = rowColumnParentData.getCrossAxisAlignment()) == null) {
                crossAxisAlignment = _this.getCrossAxisAlignment();
            }
            int iCrossAxisSize = i - _this.crossAxisSize(placeable);
            if (_this.isHorizontal()) {
                layoutDirection = LayoutDirection.Ltr;
            }
            return crossAxisAlignment.align$foundation_layout_release(iCrossAxisSize, layoutDirection, placeable, i2);
        }

        public static void $default$populateMainAxisPositions(FlowLineMeasurePolicy _this, int i, int[] iArr, int[] iArr2, MeasureScope measureScope) {
            if (_this.isHorizontal()) {
                _this.getHorizontalArrangement().arrange(measureScope, i, iArr, measureScope.getLayoutDirection(), iArr2);
            } else {
                _this.getVerticalArrangement().arrange(measureScope, i, iArr, iArr2);
            }
        }
    }
}
