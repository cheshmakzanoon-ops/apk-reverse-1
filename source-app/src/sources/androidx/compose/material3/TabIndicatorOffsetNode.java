package androidx.compose.material3;

import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.animation.core.VectorConvertersKt;
import androidx.compose.p002ui.Modifier;
import androidx.compose.p002ui.layout.IntrinsicMeasurable;
import androidx.compose.p002ui.layout.IntrinsicMeasureScope;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.p002ui.node.LayoutModifierNode;
import androidx.compose.p002ui.node.NodeMeasuringIntrinsics;
import androidx.compose.runtime.State;
import androidx.compose.ui.unit.Constraints;
import androidx.compose.ui.unit.Dp;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.CoroutineContext;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000V\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u00012\u00020\u0002B)\u0012\u0012\u0010\u0003\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u00050\u0004\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n¢\u0006\u0002\u0010\u000bJ&\u0010\u001f\u001a\u00020 *\u00020!2\u0006\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020%H\u0016ø\u0001\u0000¢\u0006\u0004\b&\u0010'R\u001a\u0010\t\u001a\u00020\nX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\f\u0010\r\"\u0004\b\u000e\u0010\u000fR\u0016\u0010\u0010\u001a\u0004\u0018\u00010\u0011X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0002\n\u0000R\u0016\u0010\u0012\u001a\u0004\u0018\u00010\u0011X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0002\n\u0000R\u001c\u0010\u0013\u001a\u0010\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u0015\u0018\u00010\u0014X\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\u0007\u001a\u00020\bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R&\u0010\u0003\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00060\u00050\u0004X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001a\u0010\u001b\"\u0004\b\u001c\u0010\u001dR\u001c\u0010\u001e\u001a\u0010\u0012\u0004\u0012\u00020\u0011\u0012\u0004\u0012\u00020\u0015\u0018\u00010\u0014X\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006("}, d2 = {"Landroidx/compose/material3/TabIndicatorOffsetNode;", "Landroidx/compose/ui/Modifier$Node;", "Landroidx/compose/ui/node/LayoutModifierNode;", "tabPositionsState", "Landroidx/compose/runtime/State;", "", "Landroidx/compose/material3/TabPosition;", "selectedTabIndex", "", "followContentSize", "", "(Landroidx/compose/runtime/State;IZ)V", "getFollowContentSize", "()Z", "setFollowContentSize", "(Z)V", "initialOffset", "Landroidx/compose/ui/unit/Dp;", "initialWidth", "offsetAnimatable", "Landroidx/compose/animation/core/Animatable;", "Landroidx/compose/animation/core/AnimationVector1D;", "getSelectedTabIndex", "()I", "setSelectedTabIndex", "(I)V", "getTabPositionsState", "()Landroidx/compose/runtime/State;", "setTabPositionsState", "(Landroidx/compose/runtime/State;)V", "widthAnimatable", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "measurable", "Landroidx/compose/ui/layout/Measurable;", "constraints", "Landroidx/compose/ui/unit/Constraints;", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Measurable;J)Landroidx/compose/ui/layout/MeasureResult;", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class TabIndicatorOffsetNode extends Modifier.Node implements LayoutModifierNode {
    public static final int $stable = 8;
    private boolean followContentSize;
    private Dp initialOffset;
    private Dp initialWidth;
    private Animatable<Dp, AnimationVector1D> offsetAnimatable;
    private int selectedTabIndex;
    private State<? extends List<TabPosition>> tabPositionsState;
    private Animatable<Dp, AnimationVector1D> widthAnimatable;

    @Override
    public int maxIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        return NodeMeasuringIntrinsics.INSTANCE.maxHeight$ui_release(new NodeMeasuringIntrinsics.MeasureBlock() {
            public C16751() {
            }

            @Override
            public final MeasureResult mo6225measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                return LayoutModifierNode.this.mo352measure3p2s80s(measureScope, measurable, j);
            }
        }, intrinsicMeasureScope, intrinsicMeasurable, i);
    }

    @Override
    public int maxIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        return NodeMeasuringIntrinsics.INSTANCE.maxWidth$ui_release(new NodeMeasuringIntrinsics.MeasureBlock() {
            public C16761() {
            }

            @Override
            public final MeasureResult mo6225measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                return LayoutModifierNode.this.mo352measure3p2s80s(measureScope, measurable, j);
            }
        }, intrinsicMeasureScope, intrinsicMeasurable, i);
    }

    @Override
    public int minIntrinsicHeight(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        return NodeMeasuringIntrinsics.INSTANCE.minHeight$ui_release(new NodeMeasuringIntrinsics.MeasureBlock() {
            public C16771() {
            }

            @Override
            public final MeasureResult mo6225measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                return LayoutModifierNode.this.mo352measure3p2s80s(measureScope, measurable, j);
            }
        }, intrinsicMeasureScope, intrinsicMeasurable, i);
    }

    @Override
    public int minIntrinsicWidth(IntrinsicMeasureScope intrinsicMeasureScope, IntrinsicMeasurable intrinsicMeasurable, int i) {
        return NodeMeasuringIntrinsics.INSTANCE.minWidth$ui_release(new NodeMeasuringIntrinsics.MeasureBlock() {
            public C16781() {
            }

            @Override
            public final MeasureResult mo6225measure3p2s80s(MeasureScope measureScope, Measurable measurable, long j) {
                return LayoutModifierNode.this.mo352measure3p2s80s(measureScope, measurable, j);
            }
        }, intrinsicMeasureScope, intrinsicMeasurable, i);
    }

    public final State<List<TabPosition>> getTabPositionsState() {
        return this.tabPositionsState;
    }

    public final void setTabPositionsState(State<? extends List<TabPosition>> state) {
        this.tabPositionsState = state;
    }

    public final int getSelectedTabIndex() {
        return this.selectedTabIndex;
    }

    public final void setSelectedTabIndex(int i) {
        this.selectedTabIndex = i;
    }

    public final boolean getFollowContentSize() {
        return this.followContentSize;
    }

    public final void setFollowContentSize(boolean z) {
        this.followContentSize = z;
    }

    public TabIndicatorOffsetNode(State<? extends List<TabPosition>> state, int i, boolean z) {
        this.tabPositionsState = state;
        this.selectedTabIndex = i;
        this.followContentSize = z;
    }

    @Override
    public MeasureResult mo352measure3p2s80s(final MeasureScope measureScope, Measurable measurable, long j) {
        float width;
        if (this.tabPositionsState.getValue().isEmpty()) {
            return MeasureScope.CC.layout$default(measureScope, 0, 0, null, new Function1<Placeable.PlacementScope, Unit>() {
                public final void invoke(Placeable.PlacementScope placementScope) {
                }

                public Object invoke(Object obj) {
                    invoke((Placeable.PlacementScope) obj);
                    return Unit.INSTANCE;
                }
            }, 4, null);
        }
        if (this.followContentSize) {
            width = this.tabPositionsState.getValue().get(this.selectedTabIndex).getContentWidth();
        } else {
            width = this.tabPositionsState.getValue().get(this.selectedTabIndex).getWidth();
        }
        if (this.initialWidth != null) {
            Animatable<Dp, AnimationVector1D> animatable = this.widthAnimatable;
            if (animatable == null) {
                Dp dp = this.initialWidth;
                Intrinsics.checkNotNull(dp);
                animatable = new Animatable<>(dp, VectorConvertersKt.getVectorConverter(Dp.Companion), null, null, 12, null);
                this.widthAnimatable = animatable;
            }
            if (!Dp.equals-impl0(width, animatable.getTargetValue().unbox-impl())) {
                BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new TabIndicatorOffsetNode$measure$2(animatable, width, null), 3, (Object) null);
            }
        } else {
            this.initialWidth = Dp.box-impl(width);
        }
        final float left = this.tabPositionsState.getValue().get(this.selectedTabIndex).getLeft();
        if (this.initialOffset != null) {
            Animatable<Dp, AnimationVector1D> animatable2 = this.offsetAnimatable;
            if (animatable2 == null) {
                Dp dp2 = this.initialOffset;
                Intrinsics.checkNotNull(dp2);
                animatable2 = new Animatable<>(dp2, VectorConvertersKt.getVectorConverter(Dp.Companion), null, null, 12, null);
                this.offsetAnimatable = animatable2;
            }
            if (!Dp.equals-impl0(left, animatable2.getTargetValue().unbox-impl())) {
                BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new TabIndicatorOffsetNode$measure$3(animatable2, left, null), 3, (Object) null);
            }
        } else {
            this.initialOffset = Dp.box-impl(left);
        }
        Animatable<Dp, AnimationVector1D> animatable3 = this.offsetAnimatable;
        if (animatable3 != null) {
            left = animatable3.getValue().unbox-impl();
        }
        Animatable<Dp, AnimationVector1D> animatable4 = this.widthAnimatable;
        if (animatable4 != null) {
            width = animatable4.getValue().unbox-impl();
        }
        final Placeable placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(Constraints.copy-Zbe2FdA$default(j, measureScope.roundToPx-0680j_4(width), measureScope.roundToPx-0680j_4(width), 0, 0, 12, (Object) null));
        return MeasureScope.CC.layout$default(measureScope, placeableMo6026measureBRTryo0.getWidth(), placeableMo6026measureBRTryo0.getHeight(), null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                Placeable.PlacementScope.place$default(placementScope, placeableMo6026measureBRTryo0, measureScope.roundToPx-0680j_4(left), 0, 0.0f, 4, null);
            }
        }, 4, null);
    }
}
