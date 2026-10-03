package androidx.compose.foundation.gestures;

import androidx.compose.foundation.MutatePriority;
import androidx.compose.p002ui.input.nestedscroll.NestedScrollSource;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollableNode$processMouseWheelEvent$2$1", f = "Scrollable.kt", i = {}, l = {549}, m = "invokeSuspend", n = {}, s = {})
final class ScrollableNode$processMouseWheelEvent$2$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final long $scrollAmount;
    int label;
    final ScrollableNode this$0;

    ScrollableNode$processMouseWheelEvent$2$1(ScrollableNode scrollableNode, long j, Continuation<? super ScrollableNode$processMouseWheelEvent$2$1> continuation) {
        super(2, continuation);
        this.this$0 = scrollableNode;
        this.$scrollAmount = j;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ScrollableNode$processMouseWheelEvent$2$1(this.this$0, this.$scrollAmount, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    @Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/NestedScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
    @DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollableNode$processMouseWheelEvent$2$1$1", f = "Scrollable.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
    static final class C04881 extends SuspendLambda implements Function2<NestedScrollScope, Continuation<? super Unit>, Object> {
        final long $scrollAmount;
        private Object L$0;
        int label;

        C04881(long j, Continuation<? super C04881> continuation) {
            super(2, continuation);
            this.$scrollAmount = j;
        }

        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            Continuation<Unit> c04881 = new C04881(this.$scrollAmount, continuation);
            c04881.L$0 = obj;
            return c04881;
        }

        public final Object invoke(NestedScrollScope nestedScrollScope, Continuation<? super Unit> continuation) {
            return create(nestedScrollScope, continuation).invokeSuspend(Unit.INSTANCE);
        }

        public final Object invokeSuspend(Object obj) {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            ((NestedScrollScope) this.L$0).mo776scrollByOzD1aCk(this.$scrollAmount, NestedScrollSource.INSTANCE.m5740getUserInputWNlRxjI());
            return Unit.INSTANCE;
        }
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            if (this.this$0.scrollingLogic.scroll(MutatePriority.UserInput, new C04881(this.$scrollAmount, null), (Continuation) this) == coroutine_suspended) {
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
