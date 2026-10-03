package androidx.compose.foundation.gestures.snapping;

import androidx.autofill.HintConstants;
import androidx.compose.animation.SplineBasedFloatDecayAnimationSpec_androidKt;
import androidx.compose.animation.core.AnimationScope;
import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.AnimationState;
import androidx.compose.animation.core.AnimationStateKt;
import androidx.compose.animation.core.AnimationVector1D;
import androidx.compose.animation.core.DecayAnimationSpec;
import androidx.compose.animation.core.SuspendAnimationKt;
import androidx.compose.foundation.gestures.ScrollScope;
import androidx.compose.foundation.gestures.TargetedFlingBehavior;
import androidx.compose.p002ui.platform.CompositionLocalsKt;
import androidx.compose.runtime.Composer;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.ProvidableCompositionLocal;
import androidx.compose.ui.unit.Density;
import androidx.compose.ui.unit.Dp;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Ref;
import kotlin.ranges.ClosedFloatingPointRange;
import kotlin.ranges.RangesKt;

@Metadata(d1 = {"\u0000\u0080\u0001\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0007\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u000f\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a*\u0010\n\u001a\u00020\b2\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\b2\u0006\u0010\u000e\u001a\u00020\bH\u0000ø\u0001\u0000¢\u0006\u0004\b\u000f\u0010\u0010\u001a\u0017\u0010\u0011\u001a\u00020\u00122\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00150\u0014H\u0082\b\u001a\u0015\u0010\u0016\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u0019H\u0007¢\u0006\u0002\u0010\u001a\u001a*\u0010\u001b\u001a\u00020\u00172\u0006\u0010\u0018\u001a\u00020\u00192\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\b0\u001d2\f\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020\b0\u001f\u001ak\u0010 \u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\"0!*\u00020#2\u0006\u0010$\u001a\u00020\b2\u0012\u0010%\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\"0&2\f\u0010\u001c\u001a\b\u0012\u0004\u0012\u00020\b0\u001d2!\u0010'\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020\u00120(H\u0082@¢\u0006\u0002\u0010,\u001as\u0010-\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\"0!*\u00020#2\u0006\u0010$\u001a\u00020\b2\u0006\u0010.\u001a\u00020\b2\u0012\u0010%\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\"0&2\f\u0010/\u001a\b\u0012\u0004\u0012\u00020\b0\u001f2!\u0010'\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020\u00120(H\u0082@¢\u0006\u0002\u00100\u001ae\u00101\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\"0!*\u00020#2\u0006\u00102\u001a\u00020\b2\u0006\u00103\u001a\u00020\b2\u0012\u00104\u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\"052!\u0010'\u001a\u001d\u0012\u0013\u0012\u00110\b¢\u0006\f\b)\u0012\b\b*\u0012\u0004\b\b(+\u0012\u0004\u0012\u00020\u00120(H\u0082@¢\u0006\u0002\u00106\u001a\u0014\u00107\u001a\u00020\b*\u00020\b2\u0006\u00108\u001a\u00020\bH\u0002\u001a(\u00109\u001a\u0002H:\"\u000e\b\u0000\u0010:*\b\u0012\u0004\u0012\u0002H:0;*\b\u0012\u0004\u0012\u0002H:0<H\u0082\u0002¢\u0006\u0002\u0010=\u001a(\u0010>\u001a\u0002H:\"\u000e\b\u0000\u0010:*\b\u0012\u0004\u0012\u0002H:0;*\b\u0012\u0004\u0012\u0002H:0<H\u0082\u0002¢\u0006\u0002\u0010=\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0082T¢\u0006\u0002\n\u0000\"\u0016\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\n\n\u0002\u0010\u0006\u001a\u0004\b\u0004\u0010\u0005\"\u000e\u0010\u0007\u001a\u00020\bX\u0080T¢\u0006\u0002\n\u0000\"\u000e\u0010\t\u001a\u00020\bX\u0080T¢\u0006\u0002\n\u0000\u0082\u0002\u0007\n\u0005\b¡\u001e0\u0001¨\u0006?"}, d2 = {"DEBUG", "", "MinFlingVelocityDp", "Landroidx/compose/ui/unit/Dp;", "getMinFlingVelocityDp", "()F", "F", "NoDistance", "", "NoVelocity", "calculateFinalOffset", "snappingOffset", "Landroidx/compose/foundation/gestures/snapping/FinalSnappingItem;", "lowerBound", "upperBound", "calculateFinalOffset-Fhqu1e0", "(IFF)F", "debugLog", "", "generateMsg", "Lkotlin/Function0;", "", "rememberSnapFlingBehavior", "Landroidx/compose/foundation/gestures/TargetedFlingBehavior;", "snapLayoutInfoProvider", "Landroidx/compose/foundation/gestures/snapping/SnapLayoutInfoProvider;", "(Landroidx/compose/foundation/gestures/snapping/SnapLayoutInfoProvider;Landroidx/compose/runtime/Composer;I)Landroidx/compose/foundation/gestures/TargetedFlingBehavior;", "snapFlingBehavior", "decayAnimationSpec", "Landroidx/compose/animation/core/DecayAnimationSpec;", "snapAnimationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "animateDecay", "Landroidx/compose/foundation/gestures/snapping/AnimationResult;", "Landroidx/compose/animation/core/AnimationVector1D;", "Landroidx/compose/foundation/gestures/ScrollScope;", "targetOffset", "animationState", "Landroidx/compose/animation/core/AnimationState;", "onAnimationStep", "Lkotlin/Function1;", "Lkotlin/ParameterName;", HintConstants.AUTOFILL_HINT_NAME, "delta", "(Landroidx/compose/foundation/gestures/ScrollScope;FLandroidx/compose/animation/core/AnimationState;Landroidx/compose/animation/core/DecayAnimationSpec;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "animateWithTarget", "cancelOffset", "animationSpec", "(Landroidx/compose/foundation/gestures/ScrollScope;FFLandroidx/compose/animation/core/AnimationState;Landroidx/compose/animation/core/AnimationSpec;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "approach", "initialTargetOffset", "initialVelocity", "animation", "Landroidx/compose/foundation/gestures/snapping/ApproachAnimation;", "(Landroidx/compose/foundation/gestures/ScrollScope;FFLandroidx/compose/foundation/gestures/snapping/ApproachAnimation;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "coerceToTarget", "target", "component1", "T", "", "Lkotlin/ranges/ClosedFloatingPointRange;", "(Lkotlin/ranges/ClosedFloatingPointRange;)Ljava/lang/Comparable;", "component2", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class SnapFlingBehaviorKt {
    private static final boolean DEBUG = false;
    private static final float MinFlingVelocityDp = Dp.constructor-impl(400);
    public static final float NoDistance = 0.0f;
    public static final float NoVelocity = 0.0f;

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.snapping.SnapFlingBehaviorKt", f = "SnapFlingBehavior.kt", i = {0, 0, 0}, l = {334}, m = "animateDecay", n = {"animationState", "previousValue", "targetOffset"}, s = {"L$0", "L$1", "F$0"})
    static final class C05191 extends ContinuationImpl {
        float F$0;
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C05191(Continuation<? super C05191> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SnapFlingBehaviorKt.animateDecay(null, 0.0f, null, null, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.snapping.SnapFlingBehaviorKt", f = "SnapFlingBehavior.kt", i = {0, 0, 0, 0}, l = {379}, m = "animateWithTarget", n = {"animationState", "consumedUpToNow", "targetOffset", "initialVelocity"}, s = {"L$0", "L$1", "F$0", "F$1"})
    static final class C05211 extends ContinuationImpl {
        float F$0;
        float F$1;
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C05211(Continuation<? super C05211> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return SnapFlingBehaviorKt.animateWithTarget(null, 0.0f, 0.0f, null, null, null, (Continuation) this);
        }
    }

    private static final boolean calculateFinalOffset_Fhqu1e0$isValidDistance(float f) {
        return (f == Float.POSITIVE_INFINITY || f == Float.NEGATIVE_INFINITY) ? false : true;
    }

    private static final void debugLog(Function0<String> function0) {
    }

    public static final TargetedFlingBehavior snapFlingBehavior(SnapLayoutInfoProvider snapLayoutInfoProvider, DecayAnimationSpec<Float> decayAnimationSpec, AnimationSpec<Float> animationSpec) {
        return new SnapFlingBehavior(snapLayoutInfoProvider, decayAnimationSpec, animationSpec);
    }

    public static final TargetedFlingBehavior rememberSnapFlingBehavior(SnapLayoutInfoProvider snapLayoutInfoProvider, Composer composer, int i) {
        ComposerKt.sourceInformationMarkerStart(composer, -1921733134, "C(rememberSnapFlingBehavior)257@10415L7,258@10485L26,259@10523L340:SnapFlingBehavior.kt#ppz6w6");
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventStart(-1921733134, i, -1, "androidx.compose.foundation.gestures.snapping.rememberSnapFlingBehavior (SnapFlingBehavior.kt:256)");
        }
        ProvidableCompositionLocal<Density> localDensity = CompositionLocalsKt.getLocalDensity();
        ComposerKt.sourceInformationMarkerStart(composer, 2023513938, "CC:CompositionLocal.kt#9igjgp");
        Object objConsume = composer.consume(localDensity);
        ComposerKt.sourceInformationMarkerEnd(composer);
        Object obj = (Density) objConsume;
        DecayAnimationSpec decayAnimationSpecRememberSplineBasedDecay = SplineBasedFloatDecayAnimationSpec_androidKt.rememberSplineBasedDecay(composer, 0);
        ComposerKt.sourceInformationMarkerStart(composer, 962717891, "CC(remember):SnapFlingBehavior.kt#9igjgp");
        boolean zChanged = composer.changed(decayAnimationSpecRememberSplineBasedDecay) | ((((i & 14) ^ 6) > 4 && composer.changed(snapLayoutInfoProvider)) || (i & 6) == 4) | composer.changed(obj);
        Object objRememberedValue = composer.rememberedValue();
        if (zChanged || objRememberedValue == Composer.INSTANCE.getEmpty()) {
            objRememberedValue = snapFlingBehavior(snapLayoutInfoProvider, decayAnimationSpecRememberSplineBasedDecay, AnimationSpecKt.spring$default(0.0f, 400.0f, null, 5, null));
            composer.updateRememberedValue(objRememberedValue);
        }
        TargetedFlingBehavior targetedFlingBehavior = (TargetedFlingBehavior) objRememberedValue;
        ComposerKt.sourceInformationMarkerEnd(composer);
        if (ComposerKt.isTraceInProgress()) {
            ComposerKt.traceEventEnd();
        }
        ComposerKt.sourceInformationMarkerEnd(composer);
        return targetedFlingBehavior;
    }

    public static final Object approach(ScrollScope scrollScope, float f, float f2, ApproachAnimation<Float, AnimationVector1D> approachAnimation, Function1<? super Float, Unit> function1, Continuation<? super AnimationResult<Float, AnimationVector1D>> continuation) {
        return approachAnimation.approachAnimation(scrollScope, Boxing.boxFloat(f), Boxing.boxFloat(f2), function1, continuation);
    }

    private static final <T extends Comparable<? super T>> T component1(ClosedFloatingPointRange<T> closedFloatingPointRange) {
        return (T) closedFloatingPointRange.getStart();
    }

    private static final <T extends Comparable<? super T>> T component2(ClosedFloatingPointRange<T> closedFloatingPointRange) {
        return (T) closedFloatingPointRange.getEndInclusive();
    }

    public static final Object animateDecay(final ScrollScope scrollScope, final float f, AnimationState<Float, AnimationVector1D> animationState, DecayAnimationSpec<Float> decayAnimationSpec, final Function1<? super Float, Unit> function1, Continuation<? super AnimationResult<Float, AnimationVector1D>> continuation) {
        C05191 c05191;
        Ref.FloatRef floatRef;
        if (continuation instanceof C05191) {
            c05191 = (C05191) continuation;
            if ((c05191.label & Integer.MIN_VALUE) != 0) {
                c05191.label -= Integer.MIN_VALUE;
            } else {
                c05191 = new C05191(continuation);
            }
        } else {
            c05191 = new C05191(continuation);
        }
        Object obj = c05191.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c05191.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            final Ref.FloatRef floatRef2 = new Ref.FloatRef();
            boolean z = animationState.getVelocity().floatValue() == 0.0f;
            Function1<AnimationScope<Float, AnimationVector1D>, Unit> function2 = new Function1<AnimationScope<Float, AnimationVector1D>, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj2) {
                    invoke((AnimationScope<Float, AnimationVector1D>) obj2);
                    return Unit.INSTANCE;
                }

                public final void invoke(AnimationScope<Float, AnimationVector1D> animationScope) {
                    if (Math.abs(animationScope.getValue().floatValue()) >= Math.abs(f)) {
                        float fCoerceToTarget = SnapFlingBehaviorKt.coerceToTarget(animationScope.getValue().floatValue(), f);
                        SnapFlingBehaviorKt.animateDecay$consumeDelta(animationScope, scrollScope, function1, fCoerceToTarget - floatRef2.element);
                        animationScope.cancelAnimation();
                        floatRef2.element = fCoerceToTarget;
                        return;
                    }
                    SnapFlingBehaviorKt.animateDecay$consumeDelta(animationScope, scrollScope, function1, animationScope.getValue().floatValue() - floatRef2.element);
                    floatRef2.element = animationScope.getValue().floatValue();
                }
            };
            c05191.L$0 = animationState;
            c05191.L$1 = floatRef2;
            c05191.F$0 = f;
            c05191.label = 1;
            if (SuspendAnimationKt.animateDecay(animationState, decayAnimationSpec, !z, function2, (Continuation<? super Unit>) c05191) == coroutine_suspended) {
                return coroutine_suspended;
            }
            floatRef = floatRef2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            f = c05191.F$0;
            floatRef = (Ref.FloatRef) c05191.L$1;
            animationState = (AnimationState) c05191.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return new AnimationResult(Boxing.boxFloat(f - floatRef.element), animationState);
    }

    public static final void animateDecay$consumeDelta(AnimationScope<Float, AnimationVector1D> animationScope, ScrollScope scrollScope, Function1<? super Float, Unit> function1, float f) {
        float fScrollBy = scrollScope.scrollBy(f);
        function1.invoke(Float.valueOf(fScrollBy));
        if (Math.abs(f - fScrollBy) > 0.5f) {
            animationScope.cancelAnimation();
        }
    }

    public static final Object animateWithTarget(final ScrollScope scrollScope, float f, final float f2, AnimationState<Float, AnimationVector1D> animationState, AnimationSpec<Float> animationSpec, final Function1<? super Float, Unit> function1, Continuation<? super AnimationResult<Float, AnimationVector1D>> continuation) {
        C05211 c05211;
        float f3;
        Ref.FloatRef floatRef;
        float f4;
        AnimationState<Float, AnimationVector1D> animationState2;
        if (continuation instanceof C05211) {
            c05211 = (C05211) continuation;
            if ((c05211.label & Integer.MIN_VALUE) != 0) {
                c05211.label -= Integer.MIN_VALUE;
            } else {
                c05211 = new C05211(continuation);
            }
        } else {
            c05211 = new C05211(continuation);
        }
        C05211 c05212 = c05211;
        Object obj = c05212.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c05212.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            final Ref.FloatRef floatRef2 = new Ref.FloatRef();
            float fFloatValue = animationState.getVelocity().floatValue();
            Float fBoxFloat = Boxing.boxFloat(f);
            boolean z = !(animationState.getVelocity().floatValue() == 0.0f);
            Function1<AnimationScope<Float, AnimationVector1D>, Unit> function2 = new Function1<AnimationScope<Float, AnimationVector1D>, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj2) {
                    invoke((AnimationScope<Float, AnimationVector1D>) obj2);
                    return Unit.INSTANCE;
                }

                public final void invoke(AnimationScope<Float, AnimationVector1D> animationScope) {
                    float fCoerceToTarget = SnapFlingBehaviorKt.coerceToTarget(animationScope.getValue().floatValue(), f2);
                    float f5 = fCoerceToTarget - floatRef2.element;
                    float fScrollBy = scrollScope.scrollBy(f5);
                    function1.invoke(Float.valueOf(fScrollBy));
                    if (Math.abs(f5 - fScrollBy) > 0.5f || fCoerceToTarget != animationScope.getValue().floatValue()) {
                        animationScope.cancelAnimation();
                    }
                    floatRef2.element += fScrollBy;
                }
            };
            c05212.L$0 = animationState;
            c05212.L$1 = floatRef2;
            f3 = f;
            c05212.F$0 = f3;
            c05212.F$1 = fFloatValue;
            c05212.label = 1;
            if (SuspendAnimationKt.animateTo(animationState, fBoxFloat, animationSpec, z, function2, c05212) == coroutine_suspended) {
                return coroutine_suspended;
            }
            floatRef = floatRef2;
            f4 = fFloatValue;
            animationState2 = animationState;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            f4 = c05212.F$1;
            float f5 = c05212.F$0;
            floatRef = (Ref.FloatRef) c05212.L$1;
            AnimationState<Float, AnimationVector1D> animationState3 = (AnimationState) c05212.L$0;
            ResultKt.throwOnFailure(obj);
            f3 = f5;
            animationState2 = animationState3;
        }
        return new AnimationResult(Boxing.boxFloat(f3 - floatRef.element), AnimationStateKt.copy$default((AnimationState) animationState2, 0.0f, coerceToTarget(animationState2.getVelocity().floatValue(), f4), 0L, 0L, false, 29, (Object) null));
    }

    public static final float coerceToTarget(float f, float f2) {
        if (f2 == 0.0f) {
            return 0.0f;
        }
        return f2 > 0.0f ? RangesKt.coerceAtMost(f, f2) : RangesKt.coerceAtLeast(f, f2);
    }

    public static final float getMinFlingVelocityDp() {
        return MinFlingVelocityDp;
    }

    public static final float m876calculateFinalOffsetFhqu1e0(int i, float f, float f2) {
        if (FinalSnappingItem.m869equalsimpl0(i, FinalSnappingItem.INSTANCE.m873getClosestItembbeMdSM())) {
            if (Math.abs(f2) <= Math.abs(f)) {
                f = f2;
            }
        } else if (FinalSnappingItem.m869equalsimpl0(i, FinalSnappingItem.INSTANCE.m874getNextItembbeMdSM())) {
            f = f2;
        } else if (!FinalSnappingItem.m869equalsimpl0(i, FinalSnappingItem.INSTANCE.m875getPreviousItembbeMdSM())) {
            f = 0.0f;
        }
        if (calculateFinalOffset_Fhqu1e0$isValidDistance(f)) {
            return f;
        }
        return 0.0f;
    }
}
