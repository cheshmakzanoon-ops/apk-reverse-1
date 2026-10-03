package androidx.compose.animation;

import androidx.autofill.HintConstants;
import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.AnimationVector2D;
import androidx.compose.animation.core.VectorConvertersKt;
import androidx.compose.p002ui.Alignment;
import androidx.compose.p002ui.layout.Measurable;
import androidx.compose.p002ui.layout.MeasureResult;
import androidx.compose.p002ui.layout.MeasureScope;
import androidx.compose.p002ui.layout.Placeable;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import androidx.compose.ui.unit.ConstraintsKt;
import androidx.compose.ui.unit.IntSize;
import androidx.compose.ui.unit.IntSizeKt;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.CoroutineContext;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineStart;

@Metadata(d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0002\u0018\u00002\u00020\u0001:\u0001>BY\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\b\b\u0002\u0010\u0005\u001a\u00020\u0006\u0012:\b\u0002\u0010\u0007\u001a4\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\f\u0012\u0004\u0012\u00020\r\u0018\u00010\b¢\u0006\u0002\u0010\u000eJ\u0018\u0010-\u001a\u00020\u00042\u0006\u0010.\u001a\u00020\u0004ø\u0001\u0000¢\u0006\u0004\b/\u00100J\b\u00101\u001a\u00020\rH\u0016J\b\u00102\u001a\u00020\rH\u0016J\u001a\u00103\u001a\u00020%2\u0006\u00104\u001a\u00020%H\u0002ø\u0001\u0000¢\u0006\u0004\b5\u00100J&\u00106\u001a\u000207*\u0002082\u0006\u00109\u001a\u00020:2\u0006\u0010;\u001a\u00020%H\u0016ø\u0001\u0000¢\u0006\u0004\b<\u0010=R\u001a\u0010\u0005\u001a\u00020\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000f\u0010\u0010\"\u0004\b\u0011\u0010\u0012R/\u0010\u0015\u001a\u0004\u0018\u00010\u00142\b\u0010\u0013\u001a\u0004\u0018\u00010\u00148F@FX\u0086\u008e\u0002¢\u0006\u0012\n\u0004\b\u001a\u0010\u001b\u001a\u0004\b\u0016\u0010\u0017\"\u0004\b\u0018\u0010\u0019R \u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001c\u0010\u001d\"\u0004\b\u001e\u0010\u001fRL\u0010\u0007\u001a4\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\u000b\u0012\u0013\u0012\u00110\u0004¢\u0006\f\b\t\u0012\b\b\n\u0012\u0004\b\b(\f\u0012\u0004\u0012\u00020\r\u0018\u00010\bX\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b \u0010!\"\u0004\b\"\u0010#R&\u0010&\u001a\u00020%2\u0006\u0010$\u001a\u00020%@BX\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\n\n\u0002\u0010)\"\u0004\b'\u0010(R\u000e\u0010*\u001a\u00020+X\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010,\u001a\u00020\u0004X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010)\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006?"}, d2 = {"Landroidx/compose/animation/SizeAnimationModifierNode;", "Landroidx/compose/animation/LayoutModifierNodeWithPassThroughIntrinsics;", "animationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "Landroidx/compose/ui/unit/IntSize;", "alignment", "Landroidx/compose/ui/Alignment;", "listener", "Lkotlin/Function2;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "startSize", "endSize", "", "(Landroidx/compose/animation/core/AnimationSpec;Landroidx/compose/ui/Alignment;Lkotlin/jvm/functions/Function2;)V", "getAlignment", "()Landroidx/compose/ui/Alignment;", "setAlignment", "(Landroidx/compose/ui/Alignment;)V", "<set-?>", "Landroidx/compose/animation/SizeAnimationModifierNode$AnimData;", "animData", "getAnimData", "()Landroidx/compose/animation/SizeAnimationModifierNode$AnimData;", "setAnimData", "(Landroidx/compose/animation/SizeAnimationModifierNode$AnimData;)V", "animData$delegate", "Landroidx/compose/runtime/MutableState;", "getAnimationSpec", "()Landroidx/compose/animation/core/AnimationSpec;", "setAnimationSpec", "(Landroidx/compose/animation/core/AnimationSpec;)V", "getListener", "()Lkotlin/jvm/functions/Function2;", "setListener", "(Lkotlin/jvm/functions/Function2;)V", "value", "Landroidx/compose/ui/unit/Constraints;", "lookaheadConstraints", "setLookaheadConstraints-BRTryo0", "(J)V", "J", "lookaheadConstraintsAvailable", "", "lookaheadSize", "animateTo", "targetSize", "animateTo-mzRDjE0", "(J)J", "onAttach", "onReset", "targetConstraints", "default", "targetConstraints-ZezNO4M", "measure", "Landroidx/compose/ui/layout/MeasureResult;", "Landroidx/compose/ui/layout/MeasureScope;", "measurable", "Landroidx/compose/ui/layout/Measurable;", "constraints", "measure-3p2s80s", "(Landroidx/compose/ui/layout/MeasureScope;Landroidx/compose/ui/layout/Measurable;J)Landroidx/compose/ui/layout/MeasureResult;", "AnimData", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class SizeAnimationModifierNode extends LayoutModifierNodeWithPassThroughIntrinsics {
    private Alignment alignment;

    private final MutableState animData;
    private AnimationSpec<IntSize> animationSpec;
    private Function2<? super IntSize, ? super IntSize, Unit> listener;
    private long lookaheadConstraints;
    private boolean lookaheadConstraintsAvailable;
    private long lookaheadSize;

    public final AnimationSpec<IntSize> getAnimationSpec() {
        return this.animationSpec;
    }

    public final void setAnimationSpec(AnimationSpec<IntSize> animationSpec) {
        this.animationSpec = animationSpec;
    }

    public SizeAnimationModifierNode(AnimationSpec animationSpec, Alignment alignment, Function2 function2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(animationSpec, (i & 2) != 0 ? Alignment.INSTANCE.getTopStart() : alignment, (i & 4) != 0 ? null : function2);
    }

    public final Alignment getAlignment() {
        return this.alignment;
    }

    public final void setAlignment(Alignment alignment) {
        this.alignment = alignment;
    }

    public final Function2<IntSize, IntSize, Unit> getListener() {
        return this.listener;
    }

    public final void setListener(Function2<? super IntSize, ? super IntSize, Unit> function2) {
        this.listener = function2;
    }

    public SizeAnimationModifierNode(AnimationSpec<IntSize> animationSpec, Alignment alignment, Function2<? super IntSize, ? super IntSize, Unit> function2) {
        this.animationSpec = animationSpec;
        this.alignment = alignment;
        this.listener = function2;
        this.lookaheadSize = AnimationModifierKt.getInvalidSize();
        this.lookaheadConstraints = ConstraintsKt.Constraints$default(0, 0, 0, 0, 15, (Object) null);
        this.animData = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(null, null, 2, null);
    }

    private final void m388setLookaheadConstraintsBRTryo0(long j) {
        this.lookaheadConstraints = j;
        this.lookaheadConstraintsAvailable = true;
    }

    private final long m389targetConstraintsZezNO4M(long j) {
        return this.lookaheadConstraintsAvailable ? this.lookaheadConstraints : j;
    }

    @Metadata(d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0087\b\u0018\u00002\u00020\u0001B!\u0012\u0012\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0004¢\u0006\u0002\u0010\u0007J\u0015\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003HÆ\u0003J\u0016\u0010\u0010\u001a\u00020\u0004HÆ\u0003ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u0011\u0010\u000bJ3\u0010\u0012\u001a\u00020\u00002\u0014\b\u0002\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u0004HÆ\u0001ø\u0001\u0000¢\u0006\u0004\b\u0013\u0010\u0014J\u0013\u0010\u0015\u001a\u00020\u00162\b\u0010\u0017\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001J\t\u0010\u001a\u001a\u00020\u001bHÖ\u0001R\u001d\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\"\u0010\u0006\u001a\u00020\u0004X\u0086\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0010\n\u0002\u0010\u000e\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\r\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001c"}, d2 = {"Landroidx/compose/animation/SizeAnimationModifierNode$AnimData;", "", "anim", "Landroidx/compose/animation/core/Animatable;", "Landroidx/compose/ui/unit/IntSize;", "Landroidx/compose/animation/core/AnimationVector2D;", "startSize", "(Landroidx/compose/animation/core/Animatable;JLkotlin/jvm/internal/DefaultConstructorMarker;)V", "getAnim", "()Landroidx/compose/animation/core/Animatable;", "getStartSize-YbymL2g", "()J", "setStartSize-ozmzZPI", "(J)V", "J", "component1", "component2", "component2-YbymL2g", "copy", "copy-O0kMr_c", "(Landroidx/compose/animation/core/Animatable;J)Landroidx/compose/animation/SizeAnimationModifierNode$AnimData;", "equals", "", "other", "hashCode", "", "toString", "", "animation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
    public static final class AnimData {
        public static final int $stable = 8;
        private final Animatable<IntSize, AnimationVector2D> anim;
        private long startSize;

        public AnimData(Animatable animatable, long j, DefaultConstructorMarker defaultConstructorMarker) {
            this(animatable, j);
        }

        public static AnimData m391copyO0kMr_c$default(AnimData animData, Animatable animatable, long j, int i, Object obj) {
            if ((i & 1) != 0) {
                animatable = animData.anim;
            }
            if ((i & 2) != 0) {
                j = animData.startSize;
            }
            return animData.m393copyO0kMr_c(animatable, j);
        }

        public final Animatable<IntSize, AnimationVector2D> component1() {
            return this.anim;
        }

        public final long getStartSize() {
            return this.startSize;
        }

        public final AnimData m393copyO0kMr_c(Animatable<IntSize, AnimationVector2D> anim, long startSize) {
            return new AnimData(anim, startSize, null);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof AnimData)) {
                return false;
            }
            AnimData animData = (AnimData) other;
            return Intrinsics.areEqual(this.anim, animData.anim) && IntSize.equals-impl0(this.startSize, animData.startSize);
        }

        public int hashCode() {
            return (this.anim.hashCode() * 31) + IntSize.hashCode-impl(this.startSize);
        }

        public String toString() {
            return "AnimData(anim=" + this.anim + ", startSize=" + ((Object) IntSize.toString-impl(this.startSize)) + ')';
        }

        private AnimData(Animatable<IntSize, AnimationVector2D> animatable, long j) {
            this.anim = animatable;
            this.startSize = j;
        }

        public final Animatable<IntSize, AnimationVector2D> getAnim() {
            return this.anim;
        }

        public final long m394getStartSizeYbymL2g() {
            return this.startSize;
        }

        public final void m395setStartSizeozmzZPI(long j) {
            this.startSize = j;
        }
    }

    public final AnimData getAnimData() {
        return (AnimData) this.animData.getValue();
    }

    public final void setAnimData(AnimData animData) {
        this.animData.setValue(animData);
    }

    @Override
    public void onReset() {
        super.onReset();
        setAnimData(null);
    }

    @Override
    public void onAttach() {
        super.onAttach();
        this.lookaheadSize = AnimationModifierKt.getInvalidSize();
        this.lookaheadConstraintsAvailable = false;
    }

    @Override
    public MeasureResult mo352measure3p2s80s(final MeasureScope measureScope, Measurable measurable, long j) {
        Placeable placeableMo6026measureBRTryo0;
        long j2;
        if (measureScope.isLookingAhead()) {
            m388setLookaheadConstraintsBRTryo0(j);
            placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(j);
        } else {
            placeableMo6026measureBRTryo0 = measurable.mo6026measureBRTryo0(m389targetConstraintsZezNO4M(j));
        }
        final Placeable placeable = placeableMo6026measureBRTryo0;
        final long jIntSize = IntSizeKt.IntSize(placeable.getWidth(), placeable.getHeight());
        if (measureScope.isLookingAhead()) {
            this.lookaheadSize = jIntSize;
            j2 = jIntSize;
        } else {
            j2 = ConstraintsKt.constrain-4WqzIAM(j, m390animateTomzRDjE0(AnimationModifierKt.m327isValidozmzZPI(this.lookaheadSize) ? this.lookaheadSize : jIntSize));
        }
        final int i = IntSize.getWidth-impl(j2);
        final int i2 = IntSize.getHeight-impl(j2);
        return MeasureScope.CC.layout$default(measureScope, i, i2, null, new Function1<Placeable.PlacementScope, Unit>() {
            {
                super(1);
            }

            public Object invoke(Object obj) {
                invoke((Placeable.PlacementScope) obj);
                return Unit.INSTANCE;
            }

            public final void invoke(Placeable.PlacementScope placementScope) {
                Placeable.PlacementScope.m6135place70tqf50$default(placementScope, placeable, this.this$0.getAlignment().mo4171alignKFBX0sM(jIntSize, IntSizeKt.IntSize(i, i2), measureScope.getLayoutDirection()), 0.0f, 2, null);
            }
        }, 4, null);
    }

    public final long m390animateTomzRDjE0(long targetSize) {
        AnimData animData = getAnimData();
        if (animData != null) {
            boolean z = (IntSize.equals-impl0(targetSize, animData.getAnim().getValue().unbox-impl()) || animData.getAnim().isRunning()) ? false : true;
            if (!IntSize.equals-impl0(targetSize, animData.getAnim().getTargetValue().unbox-impl()) || z) {
                animData.m395setStartSizeozmzZPI(animData.getAnim().getValue().unbox-impl());
                BuildersKt.launch$default(getCoroutineScope(), (CoroutineContext) null, (CoroutineStart) null, new SizeAnimationModifierNode$animateTo$data$1$1(animData, targetSize, this, null), 3, (Object) null);
            }
        } else {
            animData = new AnimData(new Animatable(IntSize.box-impl(targetSize), VectorConvertersKt.getVectorConverter(IntSize.Companion), IntSize.box-impl(IntSizeKt.IntSize(1, 1)), null, 8, null), targetSize, null);
        }
        setAnimData(animData);
        return animData.getAnim().getValue().unbox-impl();
    }
}
