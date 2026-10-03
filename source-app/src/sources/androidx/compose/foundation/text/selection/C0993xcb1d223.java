package androidx.compose.foundation.text.selection;

import androidx.compose.foundation.gestures.DragGestureDetectorKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.geometry.OffsetKt;
import androidx.compose.p002ui.input.pointer.AwaitPointerEventScope;
import androidx.compose.p002ui.input.pointer.PointerEventKt;
import androidx.compose.p002ui.input.pointer.PointerInputChange;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.RestrictedSuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "Landroidx/compose/foundation/text/selection/DownResolution;", "Landroidx/compose/ui/input/pointer/AwaitPointerEventScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.text.selection.SelectionGesturesKt$touchSelectionSubsequentPress$downResolution$1", f = "SelectionGestures.kt", i = {0}, l = {277}, m = "invokeSuspend", n = {"$this$withTimeoutOrNull"}, s = {"L$0"})
final class C0993xcb1d223 extends RestrictedSuspendLambda implements Function2<AwaitPointerEventScope, Continuation<? super DownResolution>, Object> {
    final Ref.LongRef $overSlop;
    final long $pointerId;
    private Object L$0;
    int label;

    C0993xcb1d223(long j, Ref.LongRef longRef, Continuation<? super C0993xcb1d223> continuation) {
        super(2, continuation);
        this.$pointerId = j;
        this.$overSlop = longRef;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> c0993xcb1d223 = new C0993xcb1d223(this.$pointerId, this.$overSlop, continuation);
        c0993xcb1d223.L$0 = obj;
        return c0993xcb1d223;
    }

    public final Object invoke(AwaitPointerEventScope awaitPointerEventScope, Continuation<? super DownResolution> continuation) {
        return create(awaitPointerEventScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        AwaitPointerEventScope awaitPointerEventScope;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            AwaitPointerEventScope awaitPointerEventScope2 = (AwaitPointerEventScope) this.L$0;
            long j = this.$pointerId;
            final Ref.LongRef longRef = this.$overSlop;
            this.L$0 = awaitPointerEventScope2;
            this.label = 1;
            Object objM727awaitTouchSlopOrCancellationjO51t88 = DragGestureDetectorKt.m727awaitTouchSlopOrCancellationjO51t88(awaitPointerEventScope2, j, new Function2<PointerInputChange, Offset, Unit>() {
                {
                    super(2);
                }

                public Object invoke(Object obj2, Object obj3) {
                    m1870invokeUv8p0NA((PointerInputChange) obj2, ((Offset) obj3).getPackedValue());
                    return Unit.INSTANCE;
                }

                public final void m1870invokeUv8p0NA(PointerInputChange pointerInputChange, long j2) {
                    pointerInputChange.consume();
                    longRef.element = j2;
                }
            }, (Continuation) this);
            if (objM727awaitTouchSlopOrCancellationjO51t88 == coroutine_suspended) {
                return coroutine_suspended;
            }
            awaitPointerEventScope = awaitPointerEventScope2;
            obj = objM727awaitTouchSlopOrCancellationjO51t88;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            awaitPointerEventScope = (AwaitPointerEventScope) this.L$0;
            ResultKt.throwOnFailure(obj);
        }
        if (((PointerInputChange) obj) != null && OffsetKt.m4365isSpecifiedk4lQ0M(this.$overSlop.element)) {
            return DownResolution.Drag;
        }
        PointerInputChange pointerInputChange = (PointerInputChange) CollectionsKt.first(awaitPointerEventScope.getCurrentEvent().getChanges());
        if (PointerEventKt.changedToUpIgnoreConsumed(pointerInputChange)) {
            pointerInputChange.consume();
            return DownResolution.Up;
        }
        return DownResolution.Cancel;
    }
}
