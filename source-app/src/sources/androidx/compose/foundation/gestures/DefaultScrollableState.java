package androidx.compose.foundation.gestures;

import androidx.compose.foundation.MutatePriority;
import androidx.compose.foundation.MutatorMutex;
import androidx.compose.runtime.ComposerKt;
import androidx.compose.runtime.MutableState;
import androidx.compose.runtime.SnapshotStateKt__SnapshotStateKt;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineScopeKt;

@Metadata(d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0007\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u000b\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0002\u0018\u00002\u00020\u0001B\u0019\u0012\u0012\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u0010\u0010\u0017\u001a\u00020\u00042\u0006\u0010\u0018\u001a\u00020\u0004H\u0016J?\u0010\u0019\u001a\u00020\u001a2\u0006\u0010\u001b\u001a\u00020\u001c2'\u0010\u001d\u001a#\b\u0001\u0012\u0004\u0012\u00020\u0016\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u001a0\u001f\u0012\u0006\u0012\u0004\u0018\u00010 0\u001e¢\u0006\u0002\b!H\u0096@¢\u0006\u0002\u0010\"R\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\t\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\n\u001a\u00020\b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\u000bR\u0014\u0010\f\u001a\b\u0012\u0004\u0012\u00020\b0\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\r\u001a\u00020\b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u000e\u0010\u000bR\u0014\u0010\u000f\u001a\u00020\b8VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\u0010\u0010\u000bR\u001d\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006#"}, d2 = {"Landroidx/compose/foundation/gestures/DefaultScrollableState;", "Landroidx/compose/foundation/gestures/ScrollableState;", "onDelta", "Lkotlin/Function1;", "", "(Lkotlin/jvm/functions/Function1;)V", "isLastScrollBackwardState", "Landroidx/compose/runtime/MutableState;", "", "isLastScrollForwardState", "isScrollInProgress", "()Z", "isScrollingState", "lastScrolledBackward", "getLastScrolledBackward", "lastScrolledForward", "getLastScrolledForward", "getOnDelta", "()Lkotlin/jvm/functions/Function1;", "scrollMutex", "Landroidx/compose/foundation/MutatorMutex;", "scrollScope", "Landroidx/compose/foundation/gestures/ScrollScope;", "dispatchRawDelta", "delta", "scroll", "", "scrollPriority", "Landroidx/compose/foundation/MutatePriority;", "block", "Lkotlin/Function2;", "Lkotlin/coroutines/Continuation;", "", "Lkotlin/ExtensionFunctionType;", "(Landroidx/compose/foundation/MutatePriority;Lkotlin/jvm/functions/Function2;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "foundation_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
final class DefaultScrollableState implements ScrollableState {
    private final Function1<Float, Float> onDelta;
    private final ScrollScope scrollScope = new ScrollScope() {
        @Override
        public float scrollBy(float pixels) {
            if (Float.isNaN(pixels)) {
                return 0.0f;
            }
            float fFloatValue = ((Number) this.this$0.getOnDelta().invoke(Float.valueOf(pixels))).floatValue();
            this.this$0.isLastScrollForwardState.setValue(Boolean.valueOf(fFloatValue > 0.0f));
            this.this$0.isLastScrollBackwardState.setValue(Boolean.valueOf(fFloatValue < 0.0f));
            return fFloatValue;
        }
    };
    private final MutatorMutex scrollMutex = new MutatorMutex();
    private final MutableState<Boolean> isScrollingState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
    private final MutableState<Boolean> isLastScrollForwardState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);
    private final MutableState<Boolean> isLastScrollBackwardState = SnapshotStateKt__SnapshotStateKt.mutableStateOf$default(false, null, 2, null);

    @Override
    public boolean getCanScrollBackward() {
        return ScrollableState.CC.$default$getCanScrollBackward(this);
    }

    @Override
    public boolean getCanScrollForward() {
        return ScrollableState.CC.$default$getCanScrollForward(this);
    }

    public DefaultScrollableState(Function1<? super Float, Float> function1) {
        this.onDelta = function1;
    }

    public final Function1<Float, Float> getOnDelta() {
        return this.onDelta;
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.DefaultScrollableState$scroll$2", f = "ScrollableState.kt", i = {}, l = {ComposerKt.providerKey}, m = "invokeSuspend", n = {}, s = {})
    static final class C04432 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Function2<ScrollScope, Continuation<? super Unit>, Object> $block;
        final MutatePriority $scrollPriority;
        int label;

        C04432(MutatePriority mutatePriority, Function2<? super ScrollScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super C04432> continuation) {
            super(2, continuation);
            this.$scrollPriority = mutatePriority;
            this.$block = function2;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultScrollableState.this.new C04432(this.$scrollPriority, this.$block, continuation);
        }

        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/ScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
        @DebugMetadata(c = "androidx.compose.foundation.gestures.DefaultScrollableState$scroll$2$1", f = "ScrollableState.kt", i = {}, l = {ComposerKt.providerMapsKey}, m = "invokeSuspend", n = {}, s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<ScrollScope, Continuation<? super Unit>, Object> {
            final Function2<ScrollScope, Continuation<? super Unit>, Object> $block;
            private Object L$0;
            int label;
            final DefaultScrollableState this$0;

            AnonymousClass1(DefaultScrollableState defaultScrollableState, Function2<? super ScrollScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = defaultScrollableState;
                this.$block = function2;
            }

            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                Continuation<Unit> anonymousClass1 = new AnonymousClass1(this.this$0, this.$block, continuation);
                anonymousClass1.L$0 = obj;
                return anonymousClass1;
            }

            public final Object invoke(ScrollScope scrollScope, Continuation<? super Unit> continuation) {
                return create(scrollScope, continuation).invokeSuspend(Unit.INSTANCE);
            }

            public final Object invokeSuspend(Object obj) {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                try {
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj);
                        ScrollScope scrollScope = (ScrollScope) this.L$0;
                        this.this$0.isScrollingState.setValue(Boxing.boxBoolean(true));
                        Function2<ScrollScope, Continuation<? super Unit>, Object> function2 = this.$block;
                        this.label = 1;
                        if (function2.invoke(scrollScope, this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                    }
                    this.this$0.isScrollingState.setValue(Boxing.boxBoolean(false));
                    return Unit.INSTANCE;
                } catch (Throwable th) {
                    this.this$0.isScrollingState.setValue(Boxing.boxBoolean(false));
                    throw th;
                }
            }
        }

        public final Object invokeSuspend(Object obj) {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultScrollableState.this.scrollMutex.mutateWith(DefaultScrollableState.this.scrollScope, this.$scrollPriority, new AnonymousClass1(DefaultScrollableState.this, this.$block, null), (Continuation) this) == coroutine_suspended) {
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

    @Override
    public Object scroll(MutatePriority mutatePriority, Function2<? super ScrollScope, ? super Continuation<? super Unit>, ? extends Object> function2, Continuation<? super Unit> continuation) {
        Object objCoroutineScope = CoroutineScopeKt.coroutineScope(new C04432(mutatePriority, function2, null), continuation);
        return objCoroutineScope == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCoroutineScope : Unit.INSTANCE;
    }

    @Override
    public float dispatchRawDelta(float delta) {
        return ((Number) this.onDelta.invoke(Float.valueOf(delta))).floatValue();
    }

    @Override
    public boolean isScrollInProgress() {
        return this.isScrollingState.getValue().booleanValue();
    }

    @Override
    public boolean getLastScrolledForward() {
        return this.isLastScrollForwardState.getValue().booleanValue();
    }

    @Override
    public boolean getLastScrolledBackward() {
        return this.isLastScrollBackwardState.getValue().booleanValue();
    }
}
