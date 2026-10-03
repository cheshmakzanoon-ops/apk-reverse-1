package androidx.compose.foundation.text.selection;

import androidx.compose.animation.core.Animatable;
import androidx.compose.animation.core.AnimationVector2D;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.runtime.SnapshotStateKt;
import androidx.compose.runtime.State;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.CoroutineStart;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1", f = "SelectionMagnifier.kt", i = {}, l = {86}, m = "invokeSuspend", n = {}, s = {})
final class SelectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final Animatable<Offset, AnimationVector2D> $animatable;
    final State<Offset> $targetValue$delegate;
    private Object L$0;
    int label;

    SelectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1(State<Offset> state, Animatable<Offset, AnimationVector2D> animatable, Continuation<? super SelectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1> continuation) {
        super(2, continuation);
        this.$targetValue$delegate = state;
        this.$animatable = animatable;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> selectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1 = new SelectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1(this.$targetValue$delegate, this.$animatable, continuation);
        selectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1.L$0 = obj;
        return selectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1;
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            final CoroutineScope coroutineScope = (CoroutineScope) this.L$0;
            final State<Offset> state = this.$targetValue$delegate;
            Flow flowSnapshotFlow = SnapshotStateKt.snapshotFlow(new Function0<Offset>() {
                {
                    super(0);
                }

                public Object invoke() {
                    return Offset.m4335boximpl(m1882invokeF1C5BW0());
                }

                public final long m1882invokeF1C5BW0() {
                    return SelectionMagnifierKt.rememberAnimatedMagnifierPosition$lambda$1(state);
                }
            });
            final Animatable<Offset, AnimationVector2D> animatable = this.$animatable;
            this.label = 1;
            if (flowSnapshotFlow.collect(new FlowCollector() {
                public Object emit(Object obj2, Continuation continuation) {
                    return m1883emit3MmeM6k(((Offset) obj2).getPackedValue(), continuation);
                }

                public final Object m1883emit3MmeM6k(long j, Continuation<? super Unit> continuation) {
                    if (OffsetKt.m4365isSpecifiedk4lQ0M(animatable.getValue().getPackedValue()) && OffsetKt.m4365isSpecifiedk4lQ0M(j) && Offset.m4347getYimpl(animatable.getValue().getPackedValue()) != Offset.m4347getYimpl(j)) {
                        BuildersKt.launch$default(coroutineScope, (CoroutineContext) null, (CoroutineStart) null, new AnonymousClass1(animatable, j, null), 3, (Object) null);
                        return Unit.INSTANCE;
                    }
                    Object objSnapTo = animatable.snapTo(Offset.m4335boximpl(j), continuation);
                    return objSnapTo == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSnapTo : Unit.INSTANCE;
                }

                @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
                @DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionMagnifierKt$rememberAnimatedMagnifierPosition$1$1$2$1", f = "SelectionMagnifier.kt", i = {}, l = {100}, m = "invokeSuspend", n = {}, s = {})
                static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    final Animatable<Offset, AnimationVector2D> $animatable;
                    final long $targetValue;
                    int label;

                    AnonymousClass1(Animatable<Offset, AnimationVector2D> animatable, long j, Continuation<? super AnonymousClass1> continuation) {
                        super(2, continuation);
                        this.$animatable = animatable;
                        this.$targetValue = j;
                    }

                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new AnonymousClass1(this.$animatable, this.$targetValue, continuation);
                    }

                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
                    }

                    public final Object invokeSuspend(Object obj) {
                        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        int i = this.label;
                        if (i == 0) {
                            ResultKt.throwOnFailure(obj);
                            this.label = 1;
                            if (Animatable.animateTo$default(this.$animatable, Offset.m4335boximpl(this.$targetValue), SelectionMagnifierKt.getMagnifierSpringSpec(), null, null, (Continuation) this, 12, null) == coroutine_suspended) {
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
            }, (Continuation) this) == coroutine_suspended) {
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
