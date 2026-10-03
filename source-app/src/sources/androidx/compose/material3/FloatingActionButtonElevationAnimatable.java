package androidx.compose.material3;

import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.animation.core.VectorConvertersKt;
import androidx.compose.foundation.interaction.FocusInteraction;
import androidx.compose.foundation.interaction.HoverInteraction;
import androidx.compose.foundation.interaction.Interaction;
import androidx.compose.foundation.interaction.PressInteraction;
import androidx.compose.material3.internal.ElevationKt;
import androidx.compose.runtime.State;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.DefaultConstructorMarker;

@Metadata(d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\t\b\u0002\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003¢\u0006\u0002\u0010\u0007J\u0018\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\rH\u0086@¢\u0006\u0002\u0010\u0012J\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00030\u0014J\u000e\u0010\u0015\u001a\u00020\u0010H\u0082@¢\u0006\u0002\u0010\u0016J3\u0010\u0017\u001a\u00020\u00102\u0006\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00032\u0006\u0010\u0005\u001a\u00020\u00032\u0006\u0010\u0006\u001a\u00020\u0003H\u0086@ø\u0001\u0000¢\u0006\u0004\b\u0018\u0010\u0019J\u001b\u0010\u001a\u001a\u00020\u0003*\u0004\u0018\u00010\rH\u0002ø\u0001\u0001ø\u0001\u0000¢\u0006\u0004\b\u001b\u0010\u001cR\u001a\u0010\b\u001a\u000e\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\n0\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0002\u001a\u00020\u0003X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u000bR\u0016\u0010\u0006\u001a\u00020\u0003X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u000bR\u0016\u0010\u0005\u001a\u00020\u0003X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u000bR\u0010\u0010\f\u001a\u0004\u0018\u00010\rX\u0082\u000e¢\u0006\u0002\n\u0000R\u0016\u0010\u0004\u001a\u00020\u0003X\u0082\u000eø\u0001\u0000ø\u0001\u0001¢\u0006\u0004\n\u0002\u0010\u000bR\u0010\u0010\u000e\u001a\u0004\u0018\u00010\rX\u0082\u000e¢\u0006\u0002\n\u0000\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006\u001d"}, d2 = {"Landroidx/compose/material3/FloatingActionButtonElevationAnimatable;", "", "defaultElevation", "Landroidx/compose/ui/unit/Dp;", "pressedElevation", "hoveredElevation", "focusedElevation", "(FFFFLkotlin/jvm/internal/DefaultConstructorMarker;)V", "animatable", "Landroidx/compose/animation/core/Animatable;", "Landroidx/compose/animation/core/AnimationVector1D;", "F", "lastTargetInteraction", "Landroidx/compose/foundation/interaction/Interaction;", "targetInteraction", "animateElevation", "", "to", "(Landroidx/compose/foundation/interaction/Interaction;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "asState", "Landroidx/compose/runtime/State;", "snapElevation", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateElevation", "updateElevation-lDy3nrA", "(FFFFLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "calculateTarget", "calculateTarget-u2uoSUM", "(Landroidx/compose/foundation/interaction/Interaction;)F", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class FloatingActionButtonElevationAnimatable {
    private final Animatable<Dp, AnimationVector1D> animatable;
    private float defaultElevation;
    private float focusedElevation;
    private float hoveredElevation;
    private Interaction lastTargetInteraction;
    private float pressedElevation;
    private Interaction targetInteraction;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.FloatingActionButtonElevationAnimatable", f = "FloatingActionButton.kt", i = {0, 0}, l = {650}, m = "animateElevation", n = {"this", "to"}, s = {"L$0", "L$1"})
    static final class C11911 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C11911(Continuation<? super C11911> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FloatingActionButtonElevationAnimatable.this.animateElevation(null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.FloatingActionButtonElevationAnimatable", f = "FloatingActionButton.kt", i = {0}, l = {636}, m = "snapElevation", n = {"this"}, s = {"L$0"})
    static final class C11921 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C11921(Continuation<? super C11921> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FloatingActionButtonElevationAnimatable.this.snapElevation((Continuation) this);
        }
    }

    public FloatingActionButtonElevationAnimatable(float f, float f2, float f3, float f4, DefaultConstructorMarker defaultConstructorMarker) {
        this(f, f2, f3, f4);
    }

    private FloatingActionButtonElevationAnimatable(float f, float f2, float f3, float f4) {
        this.defaultElevation = f;
        this.pressedElevation = f2;
        this.hoveredElevation = f3;
        this.focusedElevation = f4;
        this.animatable = new Animatable<>(Dp.box-impl(this.defaultElevation), VectorConvertersKt.getVectorConverter(Dp.Companion), null, null, 12, null);
    }

    private final float m2404calculateTargetu2uoSUM(Interaction interaction) {
        if (interaction instanceof PressInteraction.Press) {
            return this.pressedElevation;
        }
        if (interaction instanceof HoverInteraction.Enter) {
            return this.hoveredElevation;
        }
        return interaction instanceof FocusInteraction.Focus ? this.focusedElevation : this.defaultElevation;
    }

    public final Object m2405updateElevationlDy3nrA(float f, float f2, float f3, float f4, Continuation<? super Unit> continuation) throws Throwable {
        this.defaultElevation = f;
        this.pressedElevation = f2;
        this.hoveredElevation = f3;
        this.focusedElevation = f4;
        Object objSnapElevation = snapElevation(continuation);
        return objSnapElevation == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSnapElevation : Unit.INSTANCE;
    }

    public final Object snapElevation(Continuation<? super Unit> continuation) throws Throwable {
        C11921 c11921;
        FloatingActionButtonElevationAnimatable floatingActionButtonElevationAnimatable;
        if (continuation instanceof C11921) {
            c11921 = (C11921) continuation;
            if ((c11921.label & Integer.MIN_VALUE) != 0) {
                c11921.label -= Integer.MIN_VALUE;
            } else {
                c11921 = new C11921(continuation);
            }
        } else {
            c11921 = new C11921(continuation);
        }
        Object obj = c11921.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11921.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            float fM2404calculateTargetu2uoSUM = m2404calculateTargetu2uoSUM(this.targetInteraction);
            if (!Dp.equals-impl0(this.animatable.getTargetValue().unbox-impl(), fM2404calculateTargetu2uoSUM)) {
                try {
                    Animatable<Dp, AnimationVector1D> animatable = this.animatable;
                    Dp dp = Dp.box-impl(fM2404calculateTargetu2uoSUM);
                    c11921.L$0 = this;
                    c11921.label = 1;
                    if (animatable.snapTo(dp, c11921) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                    floatingActionButtonElevationAnimatable = this;
                    floatingActionButtonElevationAnimatable.lastTargetInteraction = floatingActionButtonElevationAnimatable.targetInteraction;
                } catch (Throwable th) {
                    th = th;
                    floatingActionButtonElevationAnimatable = this;
                    floatingActionButtonElevationAnimatable.lastTargetInteraction = floatingActionButtonElevationAnimatable.targetInteraction;
                    throw th;
                }
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            floatingActionButtonElevationAnimatable = (FloatingActionButtonElevationAnimatable) c11921.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                floatingActionButtonElevationAnimatable.lastTargetInteraction = floatingActionButtonElevationAnimatable.targetInteraction;
            } catch (Throwable th2) {
                th = th2;
                floatingActionButtonElevationAnimatable.lastTargetInteraction = floatingActionButtonElevationAnimatable.targetInteraction;
                throw th;
            }
        }
        return Unit.INSTANCE;
    }

    public final Object animateElevation(Interaction interaction, Continuation<? super Unit> continuation) throws Throwable {
        C11911 c11911;
        FloatingActionButtonElevationAnimatable floatingActionButtonElevationAnimatable;
        if (continuation instanceof C11911) {
            c11911 = (C11911) continuation;
            if ((c11911.label & Integer.MIN_VALUE) != 0) {
                c11911.label -= Integer.MIN_VALUE;
            } else {
                c11911 = new C11911(continuation);
            }
        } else {
            c11911 = new C11911(continuation);
        }
        Object obj = c11911.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c11911.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            interaction = (Interaction) c11911.L$1;
            floatingActionButtonElevationAnimatable = (FloatingActionButtonElevationAnimatable) c11911.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                floatingActionButtonElevationAnimatable.lastTargetInteraction = interaction;
                return Unit.INSTANCE;
            } catch (Throwable th) {
                th = th;
                floatingActionButtonElevationAnimatable.lastTargetInteraction = interaction;
                throw th;
            }
        }
        ResultKt.throwOnFailure(obj);
        float fM2404calculateTargetu2uoSUM = m2404calculateTargetu2uoSUM(interaction);
        this.targetInteraction = interaction;
        try {
            if (!Dp.equals-impl0(this.animatable.getTargetValue().unbox-impl(), fM2404calculateTargetu2uoSUM)) {
                Animatable<Dp, AnimationVector1D> animatable = this.animatable;
                Interaction interaction2 = this.lastTargetInteraction;
                c11911.L$0 = this;
                c11911.L$1 = interaction;
                c11911.label = 1;
                if (ElevationKt.m3260animateElevationrAjV9yQ(animatable, fM2404calculateTargetu2uoSUM, interaction2, interaction, c11911) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            floatingActionButtonElevationAnimatable = this;
            floatingActionButtonElevationAnimatable.lastTargetInteraction = interaction;
            return Unit.INSTANCE;
        } catch (Throwable th2) {
            th = th2;
            floatingActionButtonElevationAnimatable = this;
            floatingActionButtonElevationAnimatable.lastTargetInteraction = interaction;
            throw th;
        }
    }

    public final State<Dp> asState() {
        return this.animatable.asState();
    }
}
