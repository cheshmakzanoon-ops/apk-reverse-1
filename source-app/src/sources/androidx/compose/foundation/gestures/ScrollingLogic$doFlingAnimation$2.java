package androidx.compose.foundation.gestures;

import androidx.compose.p002ui.input.nestedscroll.NestedScrollSource;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/foundation/gestures/NestedScrollScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.gestures.ScrollingLogic$doFlingAnimation$2", f = "Scrollable.kt", i = {}, l = {782}, m = "invokeSuspend", n = {}, s = {})
final class ScrollingLogic$doFlingAnimation$2 extends SuspendLambda implements Function2<NestedScrollScope, Continuation<? super Unit>, Object> {
    final long $available;
    final Ref.LongRef $result;
    long J$0;
    private Object L$0;
    Object L$1;
    Object L$2;
    int label;
    final ScrollingLogic this$0;

    ScrollingLogic$doFlingAnimation$2(ScrollingLogic scrollingLogic, Ref.LongRef longRef, long j, Continuation<? super ScrollingLogic$doFlingAnimation$2> continuation) {
        super(2, continuation);
        this.this$0 = scrollingLogic;
        this.$result = longRef;
        this.$available = j;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> scrollingLogic$doFlingAnimation$2 = new ScrollingLogic$doFlingAnimation$2(this.this$0, this.$result, this.$available, continuation);
        scrollingLogic$doFlingAnimation$2.L$0 = obj;
        return scrollingLogic$doFlingAnimation$2;
    }

    public final Object invoke(NestedScrollScope nestedScrollScope, Continuation<? super Unit> continuation) {
        return create(nestedScrollScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        ScrollingLogic scrollingLogic;
        Ref.LongRef longRef;
        ScrollingLogic scrollingLogic2;
        long j;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            final NestedScrollScope nestedScrollScope = (NestedScrollScope) this.L$0;
            final ScrollingLogic scrollingLogic3 = this.this$0;
            ScrollScope scrollScope = new ScrollScope() {
                @Override
                public float scrollBy(float pixels) {
                    ScrollingLogic scrollingLogic4 = scrollingLogic3;
                    return scrollingLogic4.reverseIfNeeded(scrollingLogic4.m847toFloatk4lQ0M(nestedScrollScope.mo777scrollByWithOverscrollOzD1aCk(scrollingLogic4.m845reverseIfNeededMKHz9U(scrollingLogic4.m848toOffsettuRUvjQ(pixels)), NestedScrollSource.INSTANCE.m5739getSideEffectWNlRxjI())));
                }
            };
            scrollingLogic = this.this$0;
            Ref.LongRef longRef2 = this.$result;
            long j2 = this.$available;
            FlingBehavior flingBehavior = scrollingLogic.flingBehavior;
            long j3 = longRef2.element;
            float fReverseIfNeeded = scrollingLogic.reverseIfNeeded(scrollingLogic.m840toFloatTH1AsA0(j2));
            this.L$0 = scrollingLogic;
            this.L$1 = scrollingLogic;
            this.L$2 = longRef2;
            this.J$0 = j3;
            this.label = 1;
            Object objPerformFling = flingBehavior.performFling(scrollScope, fReverseIfNeeded, this);
            if (objPerformFling == coroutine_suspended) {
                return coroutine_suspended;
            }
            longRef = longRef2;
            obj = objPerformFling;
            scrollingLogic2 = scrollingLogic;
            j = j3;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            j = this.J$0;
            longRef = (Ref.LongRef) this.L$2;
            scrollingLogic = (ScrollingLogic) this.L$1;
            scrollingLogic2 = (ScrollingLogic) this.L$0;
            ResultKt.throwOnFailure(obj);
        }
        longRef.element = scrollingLogic.m841updateQWom1Mo(j, scrollingLogic2.reverseIfNeeded(((Number) obj).floatValue()));
        return Unit.INSTANCE;
    }
}
