package androidx.compose.material3;

import androidx.collection.IntList;
import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimatableKt;
import androidx.compose.animation.core.AnimationResult;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.foundation.MutatePriority;
import androidx.compose.foundation.MutatorMutex;
import androidx.compose.runtime.snapshots.Snapshot;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000H\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0002\b\u0007\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u000f\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0001¢\u0006\u0002\u0010\u0003J\u000e\u0010*\u001a\u00020+H\u0086@¢\u0006\u0002\u0010,J\u0010\u0010-\u001a\u00020\u00062\u0006\u0010.\u001a\u00020\u0006H\u0002J\b\u0010/\u001a\u00020\u0018H\u0002J\u0010\u00100\u001a\u00020\u00062\u0006\u00101\u001a\u00020\u0006H\u0002J\u000e\u00102\u001a\u00020+H\u0086@¢\u0006\u0002\u0010,J \u00103\u001a\u00020+2\u0006\u00101\u001a\u00020\u00062\b\b\u0002\u00104\u001a\u00020\u0018H\u0086@¢\u0006\u0002\u00105J\b\u00106\u001a\u00020+H\u0002J\f\u00107\u001a\u00020\u0006*\u00020\u0006H\u0002J\f\u00108\u001a\u00020\u0010*\u00020\u0006H\u0002J\f\u00109\u001a\u00020\u0010*\u00020\u0006H\u0002R\u001a\u0010\u0004\u001a\u000e\u0012\u0004\u0012\u00020\u0006\u0012\u0004\u0012\u00020\u00070\u0005X\u0082\u000e¢\u0006\u0002\n\u0000R\u0011\u0010\b\u001a\u00020\t8F¢\u0006\u0006\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\f\u001a\u00020\u00068F¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR$\u0010\u0011\u001a\u00020\u00102\u0006\u0010\u000f\u001a\u00020\u00108V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\u0012\u0010\u0013\"\u0004\b\u0014\u0010\u0015R\u000e\u0010\u0016\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0018\u0010\u0017\u001a\u00020\u0018X\u0096\u000f¢\u0006\f\u001a\u0004\b\u0017\u0010\u0019\"\u0004\b\u001a\u0010\u001bR\u0018\u0010\u001c\u001a\u00020\u0018X\u0096\u000f¢\u0006\f\u001a\u0004\b\u001c\u0010\u0019\"\u0004\b\u001d\u0010\u001bR$\u0010\u001e\u001a\u00020\u00102\u0006\u0010\u000f\u001a\u00020\u00108V@VX\u0096\u000e¢\u0006\f\u001a\u0004\b\u001f\u0010\u0013\"\u0004\b \u0010\u0015R\u000e\u0010!\u001a\u00020\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\"\u001a\u00020#X\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010$\u001a\u00020%X\u0096\u000fø\u0001\u0000ø\u0001\u0001¢\u0006\f\u001a\u0004\b&\u0010\u0013\"\u0004\b'\u0010\u0015R\u0011\u0010\u0002\u001a\u00020\u0001¢\u0006\b\n\u0000\u001a\u0004\b(\u0010)\u0082\u0002\u000b\n\u0005\b¡\u001e0\u0001\n\u0002\b!¨\u0006:"}, d2 = {"Landroidx/compose/material3/AnalogTimePickerState;", "Landroidx/compose/material3/TimePickerState;", "state", "(Landroidx/compose/material3/TimePickerState;)V", "anim", "Landroidx/compose/animation/core/Animatable;", "", "Landroidx/compose/animation/core/AnimationVector1D;", "clockFaceValues", "Landroidx/collection/IntList;", "getClockFaceValues", "()Landroidx/collection/IntList;", "currentAngle", "getCurrentAngle", "()F", "value", "", "hour", "getHour", "()I", "setHour", "(I)V", "hourAngle", "is24hour", "", "()Z", "set24hour", "(Z)V", "isAfternoon", "setAfternoon", "minute", "getMinute", "setMinute", "minuteAngle", "mutex", "Landroidx/compose/foundation/MutatorMutex;", "selection", "Landroidx/compose/material3/TimePickerSelectionMode;", "getSelection-yecRtBI", "setSelection-6_8s6DQ", "getState", "()Landroidx/compose/material3/TimePickerState;", "animateToCurrent", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "endValueForAnimation", "new", "isUpdated", "offsetAngle", "angle", "onGestureEnd", "rotateTo", "animate", "(FZLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateBaseStateMinute", "normalize", "toHour", "toMinute", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class AnalogTimePickerState implements TimePickerState {
    public static final int $stable = 8;
    private Animatable<Float, AnimationVector1D> anim;
    private float hourAngle;
    private float minuteAngle;
    private final MutatorMutex mutex = new MutatorMutex();
    private final TimePickerState state;

    private final float normalize(float f) {
        double d = ((double) f) % 6.283185307179586d;
        if (d < 0.0d) {
            d += 6.283185307179586d;
        }
        return (float) d;
    }

    public final float offsetAngle(float angle) {
        float f = angle + 1.5707964f;
        return f < 0.0f ? f + 6.2831855f : f;
    }

    @Override
    public int mo1990getSelectionyecRtBI() {
        return this.state.mo1990getSelectionyecRtBI();
    }

    @Override
    public boolean is24hour() {
        return this.state.is24hour();
    }

    @Override
    public boolean isAfternoon() {
        return this.state.isAfternoon();
    }

    @Override
    public void set24hour(boolean z) {
        this.state.set24hour(z);
    }

    @Override
    public void setAfternoon(boolean z) {
        this.state.setAfternoon(z);
    }

    @Override
    public void mo1991setSelection6_8s6DQ(int i) {
        this.state.mo1991setSelection6_8s6DQ(i);
    }

    public AnalogTimePickerState(TimePickerState timePickerState) {
        this.state = timePickerState;
        this.hourAngle = ((timePickerState.getHour() % 12) * 0.5235988f) - 1.5707964f;
        this.minuteAngle = (timePickerState.getMinute() * 0.10471976f) - 1.5707964f;
        this.anim = AnimatableKt.Animatable$default(this.hourAngle, 0.0f, 2, null);
    }

    public final TimePickerState getState() {
        return this.state;
    }

    public final float getCurrentAngle() {
        return this.anim.getValue().floatValue();
    }

    public final Object animateToCurrent(Continuation<? super Unit> continuation) {
        float fEndValueForAnimation;
        if (!isUpdated()) {
            return Unit.INSTANCE;
        }
        if (TimePickerSelectionMode.m3083equalsimpl0(mo1990getSelectionyecRtBI(), TimePickerSelectionMode.INSTANCE.m3087getHouryecRtBI())) {
            fEndValueForAnimation = endValueForAnimation(this.hourAngle);
        } else {
            fEndValueForAnimation = endValueForAnimation(this.minuteAngle);
        }
        Object objMutate = this.mutex.mutate(MutatePriority.PreventUserInput, new C10442(fEndValueForAnimation, null), continuation);
        return objMutate == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objMutate : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\u0010\u0000\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001H\u008a@"}, d2 = {"<anonymous>", "Landroidx/compose/animation/core/AnimationResult;", "", "Landroidx/compose/animation/core/AnimationVector1D;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.AnalogTimePickerState$animateToCurrent$2", f = "TimePicker.kt", i = {}, l = {738}, m = "invokeSuspend", n = {}, s = {})
    static final class C10442 extends SuspendLambda implements Function1<Continuation<? super AnimationResult<Float, AnimationVector1D>>, Object> {
        final float $end;
        int label;

        C10442(float f, Continuation<? super C10442> continuation) {
            super(1, continuation);
            this.$end = f;
        }

        public final Continuation<Unit> create(Continuation<?> continuation) {
            return AnalogTimePickerState.this.new C10442(this.$end, continuation);
        }

        public final Object invoke(Continuation<? super AnimationResult<Float, AnimationVector1D>> continuation) {
            return create(continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = Animatable.animateTo$default(AnalogTimePickerState.this.anim, Boxing.boxFloat(this.$end), AnimationSpecKt.spring$default(1.0f, 700.0f, null, 4, null), null, null, (Continuation) this, 12, null);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return obj;
        }
    }

    private final boolean isUpdated() {
        if (TimePickerSelectionMode.m3083equalsimpl0(mo1990getSelectionyecRtBI(), TimePickerSelectionMode.INSTANCE.m3087getHouryecRtBI()) && normalize(this.anim.getTargetValue().floatValue()) == normalize(this.hourAngle)) {
            return false;
        }
        return (TimePickerSelectionMode.m3083equalsimpl0(mo1990getSelectionyecRtBI(), TimePickerSelectionMode.INSTANCE.m3088getMinuteyecRtBI()) && normalize(this.anim.getTargetValue().floatValue()) == normalize(this.minuteAngle)) ? false : true;
    }

    public final IntList getClockFaceValues() {
        return TimePickerSelectionMode.m3083equalsimpl0(mo1990getSelectionyecRtBI(), TimePickerSelectionMode.INSTANCE.m3088getMinuteyecRtBI()) ? TimePickerKt.Minutes : TimePickerKt.Hours;
    }

    public final float endValueForAnimation(float f) {
        float fFloatValue = this.anim.getValue().floatValue() - f;
        while (fFloatValue > 3.1415927f) {
            fFloatValue -= 6.2831855f;
        }
        while (fFloatValue <= -3.1415927f) {
            fFloatValue += 6.2831855f;
        }
        return this.anim.getValue().floatValue() - fFloatValue;
    }

    public final Object onGestureEnd(Continuation<? super Unit> continuation) {
        float f;
        if (TimePickerSelectionMode.m3083equalsimpl0(mo1990getSelectionyecRtBI(), TimePickerSelectionMode.INSTANCE.m3087getHouryecRtBI())) {
            f = this.hourAngle;
        } else {
            f = this.minuteAngle;
        }
        Object objMutate = this.mutex.mutate(MutatePriority.PreventUserInput, new C10452(endValueForAnimation(f), null), continuation);
        return objMutate == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objMutate : Unit.INSTANCE;
    }

    @Metadata(d1 = {"\u0000\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\u0018\u0002\u0010\u0000\u001a\u000e\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u00030\u0001H\u008a@"}, d2 = {"<anonymous>", "Landroidx/compose/animation/core/AnimationResult;", "", "Landroidx/compose/animation/core/AnimationVector1D;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.AnalogTimePickerState$onGestureEnd$2", f = "TimePicker.kt", i = {}, l = {789}, m = "invokeSuspend", n = {}, s = {})
    static final class C10452 extends SuspendLambda implements Function1<Continuation<? super AnimationResult<Float, AnimationVector1D>>, Object> {
        final float $end;
        int label;

        C10452(float f, Continuation<? super C10452> continuation) {
            super(1, continuation);
            this.$end = f;
        }

        public final Continuation<Unit> create(Continuation<?> continuation) {
            return AnalogTimePickerState.this.new C10452(this.$end, continuation);
        }

        public final Object invoke(Continuation<? super AnimationResult<Float, AnimationVector1D>> continuation) {
            return create(continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = Animatable.animateTo$default(AnalogTimePickerState.this.anim, Boxing.boxFloat(this.$end), AnimationSpecKt.spring$default(0.0f, 0.0f, null, 7, null), null, null, (Continuation) this, 12, null);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return obj;
        }
    }

    @Metadata(d1 = {"\u0000\u0006\n\u0000\n\u0002\u0010\u0000\u0010\u0000\u001a\u00020\u0001H\u008a@"}, d2 = {"<anonymous>", ""}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.AnalogTimePickerState$rotateTo$2", f = "TimePicker.kt", i = {}, l = {803, 806}, m = "invokeSuspend", n = {}, s = {})
    static final class C10462 extends SuspendLambda implements Function1<Continuation<? super Object>, Object> {
        final float $angle;
        final boolean $animate;
        int label;

        C10462(float f, boolean z, Continuation<? super C10462> continuation) {
            super(1, continuation);
            this.$angle = f;
            this.$animate = z;
        }

        public final Continuation<Unit> create(Continuation<?> continuation) {
            return AnalogTimePickerState.this.new C10462(this.$angle, this.$animate, continuation);
        }

        public final Object invoke(Continuation<Object> continuation) {
            return create(continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                if (TimePickerSelectionMode.m3083equalsimpl0(AnalogTimePickerState.this.mo1990getSelectionyecRtBI(), TimePickerSelectionMode.INSTANCE.m3087getHouryecRtBI())) {
                    AnalogTimePickerState analogTimePickerState = AnalogTimePickerState.this;
                    analogTimePickerState.hourAngle = (analogTimePickerState.toHour(this.$angle) % 12) * 0.5235988f;
                    TimePickerState state = AnalogTimePickerState.this.getState();
                    AnalogTimePickerState analogTimePickerState2 = AnalogTimePickerState.this;
                    state.setHour((analogTimePickerState2.toHour(analogTimePickerState2.hourAngle) % 12) + (AnalogTimePickerState.this.isAfternoon() ? 12 : 0));
                } else {
                    AnalogTimePickerState analogTimePickerState3 = AnalogTimePickerState.this;
                    analogTimePickerState3.minuteAngle = analogTimePickerState3.toMinute(this.$angle) * 0.10471976f;
                    TimePickerState state2 = AnalogTimePickerState.this.getState();
                    AnalogTimePickerState analogTimePickerState4 = AnalogTimePickerState.this;
                    state2.setMinute(analogTimePickerState4.toMinute(analogTimePickerState4.minuteAngle));
                }
                if (!this.$animate) {
                    this.label = 1;
                    if (AnalogTimePickerState.this.anim.snapTo(Boxing.boxFloat(AnalogTimePickerState.this.offsetAngle(this.$angle)), (Continuation) this) == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    AnalogTimePickerState analogTimePickerState5 = AnalogTimePickerState.this;
                    float fEndValueForAnimation = analogTimePickerState5.endValueForAnimation(analogTimePickerState5.offsetAngle(this.$angle));
                    this.label = 2;
                    Object objAnimateTo$default = Animatable.animateTo$default(AnalogTimePickerState.this.anim, Boxing.boxFloat(fEndValueForAnimation), AnimationSpecKt.spring$default(1.0f, 700.0f, null, 4, null), null, null, (Continuation) this, 12, null);
                    return objAnimateTo$default == coroutine_suspended ? coroutine_suspended : objAnimateTo$default;
                }
            } else {
                if (i != 1) {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                    return obj;
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public static Object rotateTo$default(AnalogTimePickerState analogTimePickerState, float f, boolean z, Continuation continuation, int i, Object obj) {
        if ((i & 2) != 0) {
            z = false;
        }
        return analogTimePickerState.rotateTo(f, z, continuation);
    }

    public final Object rotateTo(float f, boolean z, Continuation<? super Unit> continuation) {
        Object objMutate = this.mutex.mutate(MutatePriority.UserInput, new C10462(f, z, null), continuation);
        return objMutate == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objMutate : Unit.INSTANCE;
    }

    @Override
    public int getMinute() {
        return this.state.getMinute();
    }

    @Override
    public void setMinute(int i) {
        this.minuteAngle = (i * 0.10471976f) - 1.5707964f;
        this.state.setMinute(i);
        if (TimePickerSelectionMode.m3083equalsimpl0(mo1990getSelectionyecRtBI(), TimePickerSelectionMode.INSTANCE.m3088getMinuteyecRtBI())) {
            this.anim = AnimatableKt.Animatable$default(this.minuteAngle, 0.0f, 2, null);
        }
        updateBaseStateMinute();
    }

    private final void updateBaseStateMinute() {
        Snapshot.Companion companion = Snapshot.INSTANCE;
        Snapshot currentThreadSnapshot = companion.getCurrentThreadSnapshot();
        Function1<Object, Unit> readObserver = currentThreadSnapshot != null ? currentThreadSnapshot.getReadObserver() : null;
        Snapshot snapshotMakeCurrentNonObservable = companion.makeCurrentNonObservable(currentThreadSnapshot);
        try {
            this.state.setMinute(getMinute());
            Unit unit = Unit.INSTANCE;
        } finally {
            companion.restoreNonObservable(currentThreadSnapshot, snapshotMakeCurrentNonObservable, readObserver);
        }
    }

    @Override
    public int getHour() {
        return this.state.getHour();
    }

    @Override
    public void setHour(int i) {
        this.hourAngle = ((i % 12) * 0.5235988f) - 1.5707964f;
        this.state.setHour(i);
        if (TimePickerSelectionMode.m3083equalsimpl0(mo1990getSelectionyecRtBI(), TimePickerSelectionMode.INSTANCE.m3087getHouryecRtBI())) {
            this.anim = AnimatableKt.Animatable$default(this.hourAngle, 0.0f, 2, null);
        }
    }

    public final int toHour(float f) {
        return ((int) ((((double) f) + (((double) 0.2617994f) + 1.5707963267948966d)) / ((double) 0.5235988f))) % 12;
    }

    public final int toMinute(float f) {
        return ((int) ((((double) f) + (((double) 0.05235988f) + 1.5707963267948966d)) / ((double) 0.10471976f))) % 60;
    }
}
