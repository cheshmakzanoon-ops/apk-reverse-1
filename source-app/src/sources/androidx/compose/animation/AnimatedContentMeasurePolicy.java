package androidx.compose.animation;

import androidx.compose.p002ui.layout.IntrinsicMeasurable;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasurePolicy;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.ui.unit.IntOffset;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import androidx.compose.ui.unit.LayoutDirection;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.collections.ArraysKt;
import kotlin.collections.CollectionsKt;
import kotlin.collections.IntIterator;
import kotlin.jvm.functions.Function1;
import kotlin.ranges.IntRange;

@Metadata(d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u0001B\u0011\u0012\n\u0010\u0002\u001a\u0006\u0012\u0002\b\u00030\u0003¢\u0006\u0002\u0010\u0004J\"\u0010\u0007\u001a\u00020\b*\u00020\t2\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\u0006\u0010\r\u001a\u00020\bH\u0016J\"\u0010\u000e\u001a\u00020\b*\u00020\t2\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\u0006\u0010\u000f\u001a\u00020\bH\u0016J,\u0010\u0010\u001a\u00020\u0011*\u00020\u00122\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\u00130\u000b2\u0006\u0010\u0014\u001a\u00020\u0015H\u0016ø\u0001\u0000¢\u0006\u0004\b\u0016\u0010\u0017J\"\u0010\u0018\u001a\u00020\b*\u00020\t2\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\u0006\u0010\r\u001a\u00020\bH\u0016J\"\u0010\u0019\u001a\u00020\b*\u00020\t2\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\u0006\u0010\u000f\u001a\u00020\bH\u0016R\u0015\u0010\u0002\u001a\u0006\u0012\u0002\b\u00030\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006\u001a"}, d2 = {"Landroidx/compose/animation/AnimatedContentMeasurePolicy;", "Landroidx/compose/ui/layout/MeasurePolicy;", "rootScope", "Landroidx/compose/animation/AnimatedContentTransitionScopeImpl;", "(Landroidx/compose/animation/AnimatedContentTransitionScopeImpl;)V", "getRootScope", "()Landroidx/compose/animation/AnimatedContentTransitionScopeImpl;", "maxIntrinsicHeight", "", "Landroidx/compose/ui/layout/IntrinsicMeasureScope;", "measurables", "", "Landroidx/compose/ui/layout/IntrinsicMeasurable;", "width", "maxIntrinsicWidth", "height", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Ljava/util/List;J)Landroidx/compose/ui/layout/MeasureResult;", "minIntrinsicHeight", "minIntrinsicWidth", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class AnimatedContentMeasurePolicy implements MeasurePolicy {
    private final AnimatedContentTransitionScopeImpl<?> rootScope;

    public AnimatedContentMeasurePolicy(AnimatedContentTransitionScopeImpl<?> animatedContentTransitionScopeImpl) {
        this.rootScope = animatedContentTransitionScopeImpl;
    }

    public final AnimatedContentTransitionScopeImpl<?> getRootScope() {
        return this.rootScope;
    }

    @Override
    public MeasureResult mo296measure3p2s80s(MeasureScope measureScope, List<? extends Measurable> list, long j) {
        Placeable placeable;
        Placeable placeable2;
        final int i;
        int width;
        int lastIndex;
        int height;
        IntIterator it;
        Placeable placeable3;
        int height2;
        final int i2;
        int size = list.size();
        final Placeable[] placeableArr = new Placeable[size];
        long j2 = IntSize.Companion.getZero-YbymL2g();
        int size2 = list.size();
        int height3 = 0;
        int i3 = 0;
        while (true) {
            placeable = null;
            if (i3 >= size2) {
                break;
            }
            Measurable measurable = list.get(i3);
            Object parentData = measurable.getParentData();
            AnimatedContentTransitionScopeImpl.ChildData childData = parentData instanceof AnimatedContentTransitionScopeImpl.ChildData ? (AnimatedContentTransitionScopeImpl.ChildData) parentData : null;
            if (childData != null && childData.isTarget()) {
                Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(j);
                long jIntSize = IntSizeKt.IntSize(placeableMo6026measureBRTryo0.getWidth(), placeableMo6026measureBRTryo0.getHeight());
                Unit unit = Unit.INSTANCE;
                placeableArr[i3] = placeableMo6026measureBRTryo0;
                j2 = jIntSize;
            }
            i3++;
        }
        int size3 = list.size();
        for (int i4 = 0; i4 < size3; i4++) {
            Measurable measurable2 = list.get(i4);
            if (placeableArr[i4] == null) {
                placeableArr[i4] = measurable2.mo6026measureBRTryo0(j);
            }
        }
        if (measureScope.isLookingAhead()) {
            width = IntSize.getWidth-impl(j2);
        } else {
            if (size == 0) {
                placeable2 = null;
            } else {
                placeable2 = placeableArr[0];
                int lastIndex2 = ArraysKt.getLastIndex(placeableArr);
                if (lastIndex2 != 0) {
                    int width2 = placeable2 != null ? placeable2.getWidth() : 0;
                    IntIterator it2 = new IntRange(1, lastIndex2).iterator();
                    while (it2.hasNext()) {
                        Placeable placeable4 = placeableArr[it2.nextInt()];
                        int width3 = placeable4 != null ? placeable4.getWidth() : 0;
                        if (width2 < width3) {
                            placeable2 = placeable4;
                            width2 = width3;
                        }
                    }
                }
            }
            if (placeable2 != null) {
                width = placeable2.getWidth();
            } else {
                i = 0;
            }
            if (measureScope.isLookingAhead()) {
                height3 = IntSize.getHeight-impl(j2);
            } else {
                if (size != 0) {
                    placeable = placeableArr[0];
                    lastIndex = ArraysKt.getLastIndex(placeableArr);
                    if (lastIndex != 0) {
                        if (placeable != null) {
                            height = placeable.getHeight();
                        } else {
                            height = 0;
                        }
                        it = new IntRange(1, lastIndex).iterator();
                        while (it.hasNext()) {
                            placeable3 = placeableArr[it.nextInt()];
                            if (placeable3 != null) {
                                height2 = placeable3.getHeight();
                            } else {
                                height2 = 0;
                            }
                            if (height < height2) {
                                placeable = placeable3;
                                height = height2;
                            }
                        }
                    }
                }
                if (placeable != null) {
                    height3 = placeable.getHeight();
                }
            }
            i2 = height3;
            if (!measureScope.isLookingAhead()) {
                this.rootScope.m321setMeasuredSizeozmzZPI$animation_release(IntSizeKt.IntSize(i, i2));
            }
            return MeasureScope.CC.layout$default(measureScope, i, i2, null, new Function1<Placeable.PlacementScope, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }

                public final void invoke(Placeable.PlacementScope placementScope) {
                    Placeable[] placeableArr2 = placeableArr;
                    AnimatedContentMeasurePolicy animatedContentMeasurePolicy = this;
                    int i5 = i;
                    int i6 = i2;
                    for (Placeable placeable5 : placeableArr2) {
                        if (placeable5 != null) {
                            long jMo4171alignKFBX0sM = animatedContentMeasurePolicy.getRootScope().getContentAlignment().mo4171alignKFBX0sM(IntSizeKt.IntSize(placeable5.getWidth(), placeable5.getHeight()), IntSizeKt.IntSize(i5, i6), LayoutDirection.Ltr);
                            Placeable.PlacementScope.place$default(placementScope, placeable5, IntOffset.getX-impl(jMo4171alignKFBX0sM), IntOffset.getY-impl(jMo4171alignKFBX0sM), 0.0f, 4, null);
                        }
                    }
                }
            }, 4, null);
        }
        i = width;
        if (measureScope.isLookingAhead()) {
            height3 = IntSize.getHeight-impl(j2);
        } else {
            if (size != 0) {
                placeable = placeableArr[0];
                lastIndex = ArraysKt.getLastIndex(placeableArr);
                if (lastIndex != 0) {
                    if (placeable != null) {
                        height = placeable.getHeight();
                    } else {
                        height = 0;
                    }
                    it = new IntRange(1, lastIndex).iterator();
                    while (it.hasNext()) {
                        placeable3 = placeableArr[it.nextInt()];
                        if (placeable3 != null) {
                            height2 = placeable3.getHeight();
                        } else {
                            height2 = 0;
                        }
                        if (height < height2) {
                            placeable = placeable3;
                            height = height2;
                        }
                    }
                }
            }
            if (placeable != null) {
                height3 = placeable.getHeight();
            }
        }
        i2 = height3;
        if (!measureScope.isLookingAhead()) {
            this.rootScope.m321setMeasuredSizeozmzZPI$animation_release(IntSizeKt.IntSize(i, i2));
        }
        return MeasureScope.CC.layout$default(measureScope, i, i2, null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                Placeable[] placeableArr2 = placeableArr;
                AnimatedContentMeasurePolicy animatedContentMeasurePolicy = this;
                int i5 = i;
                int i6 = i2;
                for (Placeable placeable5 : placeableArr2) {
                    if (placeable5 != null) {
                        long jMo4171alignKFBX0sM = animatedContentMeasurePolicy.getRootScope().getContentAlignment().mo4171alignKFBX0sM(IntSizeKt.IntSize(placeable5.getWidth(), placeable5.getHeight()), IntSizeKt.IntSize(i5, i6), LayoutDirection.Ltr);
                        Placeable.PlacementScope.place$default(placementScope, placeable5, IntOffset.getX-impl(jMo4171alignKFBX0sM), IntOffset.getY-impl(jMo4171alignKFBX0sM), 0.0f, 4, null);
                    }
                }
            }
        }, 4, null);
    }

    @Override
    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        Integer numValueOf;
        if (!list.isEmpty()) {
            numValueOf = Integer.valueOf(list.get(0).minIntrinsicWidth(i));
            int lastIndex = CollectionsKt.getLastIndex(list);
            int i2 = 1;
            if (1 <= lastIndex) {
                while (true) {
                    Integer numValueOf2 = Integer.valueOf(list.get(i2).minIntrinsicWidth(i));
                    if (numValueOf2.compareTo(numValueOf) > 0) {
                        numValueOf = numValueOf2;
                    }
                    if (i2 == lastIndex) {
                        break;
                    }
                    i2++;
                }
            }
        } else {
            numValueOf = null;
        }
        Integer num = numValueOf;
        if (num != null) {
            return num.intValue();
        }
        return 0;
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        Integer numValueOf;
        if (!list.isEmpty()) {
            numValueOf = Integer.valueOf(list.get(0).minIntrinsicHeight(i));
            int lastIndex = CollectionsKt.getLastIndex(list);
            int i2 = 1;
            if (1 <= lastIndex) {
                while (true) {
                    Integer numValueOf2 = Integer.valueOf(list.get(i2).minIntrinsicHeight(i));
                    if (numValueOf2.compareTo(numValueOf) > 0) {
                        numValueOf = numValueOf2;
                    }
                    if (i2 == lastIndex) {
                        break;
                    }
                    i2++;
                }
            }
        } else {
            numValueOf = null;
        }
        Integer num = numValueOf;
        if (num != null) {
            return num.intValue();
        }
        return 0;
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        Integer numValueOf;
        if (!list.isEmpty()) {
            numValueOf = Integer.valueOf(list.get(0).maxIntrinsicWidth(i));
            int lastIndex = CollectionsKt.getLastIndex(list);
            int i2 = 1;
            if (1 <= lastIndex) {
                while (true) {
                    Integer numValueOf2 = Integer.valueOf(list.get(i2).maxIntrinsicWidth(i));
                    if (numValueOf2.compareTo(numValueOf) > 0) {
                        numValueOf = numValueOf2;
                    }
                    if (i2 == lastIndex) {
                        break;
                    }
                    i2++;
                }
            }
        } else {
            numValueOf = null;
        }
        Integer num = numValueOf;
        if (num != null) {
            return num.intValue();
        }
        return 0;
    }

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, List<? extends IntrinsicMeasurable> list, int i) {
        Integer numValueOf;
        if (!list.isEmpty()) {
            numValueOf = Integer.valueOf(list.get(0).maxIntrinsicHeight(i));
            int lastIndex = CollectionsKt.getLastIndex(list);
            int i2 = 1;
            if (1 <= lastIndex) {
                while (true) {
                    Integer numValueOf2 = Integer.valueOf(list.get(i2).maxIntrinsicHeight(i));
                    if (numValueOf2.compareTo(numValueOf) > 0) {
                        numValueOf = numValueOf2;
                    }
                    if (i2 == lastIndex) {
                        break;
                    }
                    i2++;
                }
            }
        } else {
            numValueOf = null;
        }
        Integer num = numValueOf;
        if (num != null) {
            return num.intValue();
        }
        return 0;
    }
}
