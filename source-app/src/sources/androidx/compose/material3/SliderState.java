package androidx.compose.material3;

import androidx.compose.foundation.MutatePriority;
import androidx.compose.foundation.MutatorMutex;
import androidx.compose.foundation.gestures.DragScope;
import androidx.compose.foundation.gestures.DraggableState;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.runtime.MutableFloatState;
import androidx.compose.runtime.MutableIntState;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.PrimitiveSnapshotStateKt;
import androidx.compose.runtime.SnapshotIntStateKt;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.ranges.ClosedFloatingPointRange;
import kotlin.ranges.RangesKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;

@Metadata(d1 = {"\u0000r\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0007\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0012\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010\u0014\n\u0002\b\u0019\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\r\b\u0007\u0018\u00002\u00020\u0001B;\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0003\u0010\u0004\u001a\u00020\u0005\u0012\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\u000e\b\u0002\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00030\n¢\u0006\u0002\u0010\u000bJ\u0010\u0010R\u001a\u00020\b2\u0006\u0010S\u001a\u00020\u0003H\u0016J?\u0010T\u001a\u00020\b2\u0006\u0010U\u001a\u00020V2'\u0010W\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0010\u0012\n\u0012\b\u0012\u0004\u0012\u00020\b0Y\u0012\u0006\u0012\u0004\u0018\u00010Z0X¢\u0006\u0002\b[H\u0096@¢\u0006\u0002\u0010\\J\u001a\u0010]\u001a\u00020\b2\u0006\u0010^\u001a\u00020_H\u0000ø\u0001\u0000¢\u0006\u0004\b`\u0010aJ \u0010b\u001a\u00020\u00032\u0006\u0010c\u001a\u00020\u00032\u0006\u0010d\u001a\u00020\u00032\u0006\u0010e\u001a\u00020\u0003H\u0002J \u0010f\u001a\u00020\u00032\u0006\u0010c\u001a\u00020\u00032\u0006\u0010d\u001a\u00020\u00032\u0006\u0010g\u001a\u00020\u0003H\u0002J\u001d\u0010h\u001a\u00020\b2\u0006\u0010i\u001a\u00020\u00032\u0006\u0010j\u001a\u00020\u0005H\u0000¢\u0006\u0002\bkR\u0014\u0010\f\u001a\u00020\u00038@X\u0080\u0004¢\u0006\u0006\u001a\u0004\b\r\u0010\u000eR\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R+\u0010\u0016\u001a\u00020\u00152\u0006\u0010\u0014\u001a\u00020\u00158@@BX\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b\u001b\u0010\u001c\u001a\u0004\b\u0017\u0010\u0018\"\u0004\b\u0019\u0010\u001aR\u001a\u0010\u001d\u001a\u00020\u0015X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u001e\u0010\u0018\"\u0004\b\u001f\u0010\u001aR(\u0010 \u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\b\u0018\u00010!X\u0080\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\"\u0010#\"\u0004\b$\u0010%R\"\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b&\u0010\u0013\"\u0004\b'\u0010(R+\u0010)\u001a\u00020\u00032\u0006\u0010\u0014\u001a\u00020\u00038B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b-\u0010.\u001a\u0004\b*\u0010\u000e\"\u0004\b+\u0010,R+\u0010/\u001a\u00020\u00032\u0006\u0010\u0014\u001a\u00020\u00038B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b2\u0010.\u001a\u0004\b0\u0010\u000e\"\u0004\b1\u0010,R\u000e\u00103\u001a\u000204X\u0082\u0004¢\u0006\u0002\n\u0000R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b5\u00106R+\u00107\u001a\u00020\u00032\u0006\u0010\u0014\u001a\u00020\u00038@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\b:\u0010.\u001a\u0004\b8\u0010\u000e\"\u0004\b9\u0010,R\u0014\u0010;\u001a\u00020<X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b=\u0010>R+\u0010?\u001a\u00020\u00052\u0006\u0010\u0014\u001a\u00020\u00058B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\bC\u0010D\u001a\u0004\b@\u00106\"\u0004\bA\u0010BR+\u0010E\u001a\u00020\u00032\u0006\u0010\u0014\u001a\u00020\u00038@@@X\u0080\u008e\u0002¢\u0006\u0012\n\u0004\bH\u0010.\u001a\u0004\bF\u0010\u000e\"\u0004\bG\u0010,R$\u0010\u0002\u001a\u00020\u00032\u0006\u0010I\u001a\u00020\u00038F@FX\u0086\u000e¢\u0006\f\u001a\u0004\bJ\u0010\u000e\"\u0004\bK\u0010,R\u0017\u0010\t\u001a\b\u0012\u0004\u0012\u00020\u00030\n¢\u0006\b\n\u0000\u001a\u0004\bL\u0010MR+\u0010N\u001a\u00020\u00032\u0006\u0010\u0014\u001a\u00020\u00038B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\bQ\u0010.\u001a\u0004\bO\u0010\u000e\"\u0004\bP\u0010,\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006l"}, d2 = {"Landroidx/compose/material3/SliderState;", "Landroidx/compose/foundation/gestures/DraggableState;", "value", "", "steps", "", "onValueChangeFinished", "Lkotlin/Function0;", "", "valueRange", "Lkotlin/ranges/ClosedFloatingPointRange;", "(FILkotlin/jvm/functions/Function0;Lkotlin/ranges/ClosedFloatingPointRange;)V", "coercedValueAsFraction", "getCoercedValueAsFraction$material3_release", "()F", "dragScope", "Landroidx/compose/foundation/gestures/DragScope;", "gestureEndAction", "getGestureEndAction$material3_release", "()Lkotlin/jvm/functions/Function0;", "<set-?>", "", "isDragging", "isDragging$material3_release", "()Z", "setDragging", "(Z)V", "isDragging$delegate", "Landroidx/compose/runtime/MutableState;", "isRtl", "isRtl$material3_release", "setRtl$material3_release", "onValueChange", "Lkotlin/Function1;", "getOnValueChange$material3_release", "()Lkotlin/jvm/functions/Function1;", "setOnValueChange$material3_release", "(Lkotlin/jvm/functions/Function1;)V", "getOnValueChangeFinished", "setOnValueChangeFinished", "(Lkotlin/jvm/functions/Function0;)V", "pressOffset", "getPressOffset", "setPressOffset", "(F)V", "pressOffset$delegate", "Landroidx/compose/runtime/MutableFloatState;", "rawOffset", "getRawOffset", "setRawOffset", "rawOffset$delegate", "scrollMutex", "Landroidx/compose/foundation/MutatorMutex;", "getSteps", "()I", "thumbWidth", "getThumbWidth$material3_release", "setThumbWidth$material3_release", "thumbWidth$delegate", "tickFractions", "", "getTickFractions$material3_release", "()[F", "totalWidth", "getTotalWidth", "setTotalWidth", "(I)V", "totalWidth$delegate", "Landroidx/compose/runtime/MutableIntState;", "trackHeight", "getTrackHeight$material3_release", "setTrackHeight$material3_release", "trackHeight$delegate", "newVal", "getValue", "setValue", "getValueRange", "()Lkotlin/ranges/ClosedFloatingPointRange;", "valueState", "getValueState", "setValueState", "valueState$delegate", "dispatchRawDelta", "delta", "drag", "dragPriority", "Landroidx/compose/foundation/MutatePriority;", "block", "Lkotlin/Function2;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/MutatePriority;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "onPress", "pos", "Landroidx/compose/ui/geometry/Offset;", "onPress-k-4lQ0M$material3_release", "(J)V", "scaleToOffset", "minPx", "maxPx", "userValue", "scaleToUserValue", "offset", "updateDimensions", "newTrackHeight", "newTotalWidth", "updateDimensions$material3_release", "material3_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class SliderState implements DraggableState {
    public static final int $stable = 8;
    private final DragScope dragScope;
    private final Function0<Unit> gestureEndAction;

    private final MutableState isDragging;
    private boolean isRtl;
    private Function1<? super Float, Unit> onValueChange;
    private Function0<Unit> onValueChangeFinished;

    private final MutableFloatState pressOffset;

    private final MutableFloatState rawOffset;
    private final MutatorMutex scrollMutex;
    private final int steps;

    private final MutableFloatState thumbWidth;
    private final float[] tickFractions;

    private final MutableIntState totalWidth;

    private final MutableFloatState trackHeight;
    private final ClosedFloatingPointRange<Float> valueRange;

    private final MutableFloatState valueState;

    public SliderState() {
        this(0.0f, 0, null, null, 15, null);
    }

    public SliderState(float f, int i, Function0<Unit> function0, ClosedFloatingPointRange<Float> closedFloatingPointRange) {
        this.steps = i;
        this.onValueChangeFinished = function0;
        this.valueRange = closedFloatingPointRange;
        this.valueState = PrimitiveSnapshotStateKt.mutableFloatStateOf(f);
        this.tickFractions = SliderKt.stepsToTickFractions(i);
        this.totalWidth = SnapshotIntStateKt.mutableIntStateOf(0);
        this.trackHeight = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);
        this.thumbWidth = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);
        this.isDragging = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
        this.gestureEndAction = new Function0<Unit>() {
            {
                super(0);
            }

            public Object invoke() {
                m2845invoke();
                return Unit.INSTANCE;
            }

            public final void m2845invoke() {
                Function0<Unit> onValueChangeFinished;
                if (this.this$0.isDragging$material3_release() || (onValueChangeFinished = this.this$0.getOnValueChangeFinished()) == null) {
                    return;
                }
                onValueChangeFinished.invoke();
            }
        };
        this.rawOffset = PrimitiveSnapshotStateKt.mutableFloatStateOf(scaleToOffset(0.0f, 0.0f, f));
        this.pressOffset = PrimitiveSnapshotStateKt.mutableFloatStateOf(0.0f);
        this.dragScope = new DragScope() {
            @Override
            public void dragBy(float pixels) {
                this.this$0.dispatchRawDelta(pixels);
            }
        };
        this.scrollMutex = new MutatorMutex();
    }

    public final int getSteps() {
        return this.steps;
    }

    public final Function0<Unit> getOnValueChangeFinished() {
        return this.onValueChangeFinished;
    }

    public final void setOnValueChangeFinished(Function0<Unit> function0) {
        this.onValueChangeFinished = function0;
    }

    public SliderState(float f, int i, Function0 function0, ClosedFloatingPointRange closedFloatingPointRange, int i2, DefaultConstructorMarker defaultConstructorMarker) {
        this((i2 & 1) != 0 ? 0.0f : f, (i2 & 2) != 0 ? 0 : i, (i2 & 4) != 0 ? null : function0, (i2 & 8) != 0 ? RangesKt.rangeTo(0.0f, 1.0f) : closedFloatingPointRange);
    }

    public final ClosedFloatingPointRange<Float> getValueRange() {
        return this.valueRange;
    }

    private final float getValueState() {
        return this.valueState.getFloatValue();
    }

    private final void setValueState(float f) {
        this.valueState.setFloatValue(f);
    }

    public final void setValue(float f) {
        setValueState(SliderKt.snapValueToTick(RangesKt.coerceIn(f, ((Number) this.valueRange.getStart()).floatValue(), ((Number) this.valueRange.getEndInclusive()).floatValue()), this.tickFractions, ((Number) this.valueRange.getStart()).floatValue(), ((Number) this.valueRange.getEndInclusive()).floatValue()));
    }

    public final float getValue() {
        return getValueState();
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.material3.SliderState$drag$2", f = "Slider.kt", i = {}, l = {1972}, m = "invokeSuspend", n = {}, s = {})
    static final class C13722 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Function2<DragScope, Continuation<? super Unit>, Object> $block;
        final MutatePriority $dragPriority;
        int label;

        C13722(MutatePriority mutatePriority, Function2<? super DragScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super C13722> continuation) {
            super(2, continuation);
            this.$dragPriority = mutatePriority;
            this.$block = function2;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return SliderState.this.new C13722(this.$dragPriority, this.$block, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                SliderState.this.setDragging(true);
                this.label = 1;
                if (SliderState.this.scrollMutex.mutateWith(SliderState.this.dragScope, this.$dragPriority, this.$block, (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            SliderState.this.setDragging(false);
            return Unit.INSTANCE;
        }
    }

    @Override
    public Object drag(MutatePriority mutatePriority, Function2<? super DragScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super Unit> continuation) {
        Object objCoroutineScope = CoroutineScopeKt.coroutineScope(new C13722(mutatePriority, function2, null), continuation);
        return objCoroutineScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCoroutineScope : Unit.INSTANCE;
    }

    @Override
    public void dispatchRawDelta(float delta) {
        float f = 2;
        float fMax = Math.max(getTotalWidth() - (getThumbWidth$material3_release() / f), 0.0f);
        float fMin = Math.min(getThumbWidth$material3_release() / f, fMax);
        setRawOffset(getRawOffset() + delta + getPressOffset());
        setPressOffset(0.0f);
        float fScaleToUserValue = scaleToUserValue(fMin, fMax, SliderKt.snapValueToTick(getRawOffset(), this.tickFractions, fMin, fMax));
        if (fScaleToUserValue == getValue()) {
            return;
        }
        Function1<? super Float, Unit> function1 = this.onValueChange;
        if (function1 == null) {
            setValue(fScaleToUserValue);
        } else if (function1 != null) {
            function1.invoke(Float.valueOf(fScaleToUserValue));
        }
    }

    public final Function1<Float, Unit> getOnValueChange$material3_release() {
        return this.onValueChange;
    }

    public final void setOnValueChange$material3_release(Function1<? super Float, Unit> function1) {
        this.onValueChange = function1;
    }

    public final float[] getTickFractions() {
        return this.tickFractions;
    }

    private final int getTotalWidth() {
        return this.totalWidth.getIntValue();
    }

    private final void setTotalWidth(int i) {
        this.totalWidth.setIntValue(i);
    }

    public final boolean getIsRtl() {
        return this.isRtl;
    }

    public final void setRtl$material3_release(boolean z) {
        this.isRtl = z;
    }

    public final float getTrackHeight$material3_release() {
        return this.trackHeight.getFloatValue();
    }

    public final void setTrackHeight$material3_release(float f) {
        this.trackHeight.setFloatValue(f);
    }

    public final float getThumbWidth$material3_release() {
        return this.thumbWidth.getFloatValue();
    }

    public final void setThumbWidth$material3_release(float f) {
        this.thumbWidth.setFloatValue(f);
    }

    public final float getCoercedValueAsFraction$material3_release() {
        return SliderKt.calcFraction(((Number) this.valueRange.getStart()).floatValue(), ((Number) this.valueRange.getEndInclusive()).floatValue(), RangesKt.coerceIn(getValue(), ((Number) this.valueRange.getStart()).floatValue(), ((Number) this.valueRange.getEndInclusive()).floatValue()));
    }

    public final void setDragging(boolean z) {
        this.isDragging.setValue(Boolean.valueOf(z));
    }

    public final boolean isDragging$material3_release() {
        return ((Boolean) this.isDragging.getValue()).booleanValue();
    }

    public final void updateDimensions$material3_release(float newTrackHeight, int newTotalWidth) {
        setTrackHeight$material3_release(newTrackHeight);
        setTotalWidth(newTotalWidth);
    }

    public final Function0<Unit> getGestureEndAction$material3_release() {
        return this.gestureEndAction;
    }

    public final void m2844onPressk4lQ0M$material3_release(long pos) {
        setPressOffset((this.isRtl ? getTotalWidth() - Offset.m4346getXimpl(pos) : Offset.m4346getXimpl(pos)) - getRawOffset());
    }

    private final float getRawOffset() {
        return this.rawOffset.getFloatValue();
    }

    private final void setRawOffset(float f) {
        this.rawOffset.setFloatValue(f);
    }

    private final float getPressOffset() {
        return this.pressOffset.getFloatValue();
    }

    private final void setPressOffset(float f) {
        this.pressOffset.setFloatValue(f);
    }

    private final float scaleToUserValue(float minPx, float maxPx, float offset) {
        return SliderKt.scale(minPx, maxPx, offset, ((Number) this.valueRange.getStart()).floatValue(), ((Number) this.valueRange.getEndInclusive()).floatValue());
    }

    private final float scaleToOffset(float minPx, float maxPx, float userValue) {
        return SliderKt.scale(((Number) this.valueRange.getStart()).floatValue(), ((Number) this.valueRange.getEndInclusive()).floatValue(), userValue, minPx, maxPx);
    }
}
