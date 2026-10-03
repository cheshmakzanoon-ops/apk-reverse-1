package androidx.compose.foundation.gestures;

import androidx.compose.animation.core.AnimationSpec;
import androidx.compose.animation.core.AnimationSpecKt;
import androidx.compose.animation.core.SuspendAnimationKt;
import androidx.compose.foundation.MutatePriority;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000$\n\u0000\n\u0002\u0010\u0007\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a*\u0010\u0000\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u00012\u000e\b\u0002\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00010\u0005H\u0086@¢\u0006\u0002\u0010\u0006\u001a\u001a\u0010\u0007\u001a\u00020\u0001*\u00020\u00022\u0006\u0010\u0003\u001a\u00020\u0001H\u0086@¢\u0006\u0002\u0010\b\u001a\u001c\u0010\t\u001a\u00020\n*\u00020\u00022\b\b\u0002\u0010\u000b\u001a\u00020\fH\u0086@¢\u0006\u0002\u0010\r¨\u0006\u000e"}, d2 = {"animateScrollBy", "", "Landroidx/compose/foundation/gestures/ScrollableState;", "value", "animationSpec", "Landroidx/compose/animation/core/AnimationSpec;", "(Landroidx/compose/foundation/gestures/ScrollableState;FLandroidx/compose/animation/core/AnimationSpec;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "scrollBy", "(Landroidx/compose/foundation/gestures/ScrollableState;FLkotlin/coroutines/Continuation;)Ljava/lang/Object;", "stopScroll", "", "scrollPriority", "Landroidx/compose/foundation/MutatePriority;", "(Landroidx/compose/foundation/gestures/ScrollableState;Landroidx/compose/foundation/MutatePriority;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "foundation_release"}, k = 2, mv = {1, 8, 0}, xi = 48)
public final class ScrollExtensionsKt {

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollExtensionsKt", f = "ScrollExtensions.kt", i = {0}, l = {40}, m = "animateScrollBy", n = {"previousValue"}, s = {"L$0"})
    static final class C04791 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C04791(Continuation<? super C04791> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ScrollExtensionsKt.animateScrollBy(null, 0.0f, null, (Continuation) this);
        }
    }

    @Metadata(k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollExtensionsKt", f = "ScrollExtensions.kt", i = {0}, l = {61}, m = "scrollBy", n = {"consumed"}, s = {"L$0"})
    static final class C04811 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C04811(Continuation<? super C04811> continuation) {
            super(continuation);
        }

        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ScrollExtensionsKt.scrollBy(null, 0.0f, (Continuation) this);
        }
    }

    public static final Object animateScrollBy(ScrollableState scrollableState, float f, AnimationSpec<Float> animationSpec, Continuation<? super Float> continuation) {
        C04791 c04791;
        Ref.FloatRef floatRef;
        if (continuation instanceof C04791) {
            c04791 = (C04791) continuation;
            if ((c04791.label & Integer.MIN_VALUE) != 0) {
                c04791.label -= Integer.MIN_VALUE;
            } else {
                c04791 = new C04791(continuation);
            }
        } else {
            c04791 = new C04791(continuation);
        }
        C04791 c04792 = c04791;
        Object obj = c04792.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c04792.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Ref.FloatRef floatRef2 = new Ref.FloatRef();
            C04802 c04802 = new C04802(f, animationSpec, floatRef2, null);
            c04792.L$0 = floatRef2;
            c04792.label = 1;
            if (ScrollableState.CC.scroll$default(scrollableState, null, c04802, c04792, 1, null) == coroutine_suspended) {
                return coroutine_suspended;
            }
            floatRef = floatRef2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            floatRef = (Ref.FloatRef) c04792.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return Boxing.boxFloat(floatRef.element);
    }

    public static Object animateScrollBy$default(ScrollableState scrollableState, float f, AnimationSpec animationSpec, Continuation continuation, int i, Object obj) {
        if ((i & 2) != 0) {
            animationSpec = AnimationSpecKt.spring$default(0.0f, 0.0f, null, 7, null);
        }
        return animateScrollBy(scrollableState, f, animationSpec, continuation);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/ScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollExtensionsKt$animateScrollBy$2", f = "ScrollExtensions.kt", i = {}, l = {41}, m = "invokeSuspend", n = {}, s = {})
    static final class C04802 extends SuspendLambda implements Function2<ScrollScope, Continuation<? super Unit>, Object> {
        final AnimationSpec<Float> $animationSpec;
        final Ref.FloatRef $previousValue;
        final float $value;
        private Object L$0;
        int label;

        C04802(float f, AnimationSpec<Float> animationSpec, Ref.FloatRef floatRef, Continuation<? super C04802> continuation) {
            super(2, continuation);
            this.$value = f;
            this.$animationSpec = animationSpec;
            this.$previousValue = floatRef;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04802 = new C04802(this.$value, this.$animationSpec, this.$previousValue, continuation);
            c04802.L$0 = obj;
            return c04802;
        }

        public final Object invoke(ScrollScope scrollScope, Continuation<? super Unit> continuation) {
            return create(scrollScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                final ScrollScope scrollScope = (ScrollScope) this.L$0;
                float f = this.$value;
                AnimationSpec<Float> animationSpec = this.$animationSpec;
                final Ref.FloatRef floatRef = this.$previousValue;
                this.label = 1;
                if (SuspendAnimationKt.animate$default(0.0f, f, 0.0f, animationSpec, new Function2<Float, Float, Unit>() {
                    {
                        super(2);
                    }

                    public Object invoke(Object obj2, Object obj3) {
                        invoke(((Number) obj2).floatValue(), ((Number) obj3).floatValue());
                        return Unit.INSTANCE;
                    }

                    public final void invoke(float f2, float f3) {
                        floatRef.element += scrollScope.scrollBy(f2 - floatRef.element);
                    }
                }, (Continuation) this, 4, null) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public static final Object scrollBy(ScrollableState scrollableState, float f, Continuation<? super Float> continuation) {
        C04811 c04811;
        Ref.FloatRef floatRef;
        if (continuation instanceof C04811) {
            c04811 = (C04811) continuation;
            if ((c04811.label & Integer.MIN_VALUE) != 0) {
                c04811.label -= Integer.MIN_VALUE;
            } else {
                c04811 = new C04811(continuation);
            }
        } else {
            c04811 = new C04811(continuation);
        }
        C04811 c04812 = c04811;
        Object obj = c04812.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c04812.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Ref.FloatRef floatRef2 = new Ref.FloatRef();
            C04822 c04822 = new C04822(floatRef2, f, null);
            c04812.L$0 = floatRef2;
            c04812.label = 1;
            if (ScrollableState.CC.scroll$default(scrollableState, null, c04822, c04812, 1, null) == coroutine_suspended) {
                return coroutine_suspended;
            }
            floatRef = floatRef2;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            floatRef = (Ref.FloatRef) c04812.L$0;
            ResultKt.throwOnFailure(obj);
        }
        return Boxing.boxFloat(floatRef.element);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/ScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollExtensionsKt$scrollBy$2", f = "ScrollExtensions.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C04822 extends SuspendLambda implements Function2<ScrollScope, Continuation<? super Unit>, Object> {
        final Ref.FloatRef $consumed;
        final float $value;
        private Object L$0;
        int label;

        C04822(Ref.FloatRef floatRef, float f, Continuation<? super C04822> continuation) {
            super(2, continuation);
            this.$consumed = floatRef;
            this.$value = f;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04822 = new C04822(this.$consumed, this.$value, continuation);
            c04822.L$0 = obj;
            return c04822;
        }

        public final Object invoke(ScrollScope scrollScope, Continuation<? super Unit> continuation) {
            return create(scrollScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            ScrollScope scrollScope = (ScrollScope) this.L$0;
            this.$consumed.element = scrollScope.scrollBy(this.$value);
            return Unit.INSTANCE;
        }
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/ScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollExtensionsKt$stopScroll$2", f = "ScrollExtensions.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C04832 extends SuspendLambda implements Function2<ScrollScope, Continuation<? super Unit>, Object> {
        int label;

        C04832(Continuation<? super C04832> continuation) {
            super(2, continuation);
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return new C04832(continuation);
        }

        public final Object invoke(ScrollScope scrollScope, Continuation<? super Unit> continuation) {
            return create(scrollScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            return Unit.INSTANCE;
        }
    }

    public static Object stopScroll$default(ScrollableState scrollableState, MutatePriority mutatePriority, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            mutatePriority = MutatePriority.Default;
        }
        return stopScroll(scrollableState, mutatePriority, continuation);
    }

    public static final Object stopScroll(ScrollableState scrollableState, MutatePriority mutatePriority, Continuation<? super Unit> continuation) {
        Object objScroll = scrollableState.scroll(mutatePriority, new C04832(null), continuation);
        return objScroll == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objScroll : Unit.INSTANCE;
    }
}
