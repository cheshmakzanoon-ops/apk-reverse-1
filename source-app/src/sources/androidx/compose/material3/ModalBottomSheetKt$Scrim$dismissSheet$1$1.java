package androidx.compose.material3;

import androidx.compose.foundation.gestures.TapGestureDetectorKt;
import androidx.compose.p002ui.geometry.Offset;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
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

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.ModalBottomSheetKt$Scrim$dismissSheet$1$1", f = "ModalBottomSheet.kt", i = {}, l = {415}, m = "invokeSuspend", n = {}, s = {})
final class ModalBottomSheetKt$Scrim$dismissSheet$1$1 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
    final Function0<Unit> $onDismissRequest;
    private Object L$0;
    int label;

    ModalBottomSheetKt$Scrim$dismissSheet$1$1(Function0<Unit> function0, Continuation<? super ModalBottomSheetKt$Scrim$dismissSheet$1$1> continuation) {
        super(2, continuation);
        this.$onDismissRequest = function0;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> modalBottomSheetKt$Scrim$dismissSheet$1$1 = new ModalBottomSheetKt$Scrim$dismissSheet$1$1(this.$onDismissRequest, continuation);
        modalBottomSheetKt$Scrim$dismissSheet$1$1.L$0 = obj;
        return modalBottomSheetKt$Scrim$dismissSheet$1$1;
    }

    public final Object invoke(PointerInputScope pointerInputScope, Continuation<? super Unit> continuation) {
        return create(pointerInputScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            PointerInputScope pointerInputScope = (PointerInputScope) this.L$0;
            final Function0<Unit> function0 = this.$onDismissRequest;
            this.label = 1;
            if (TapGestureDetectorKt.detectTapGestures$default(pointerInputScope, null, null, null, new Function1<Offset, Unit>() {
                {
                    super(1);
                }

                public Object invoke(Object obj2) {
                    m2538invokek4lQ0M(((Offset) obj2).getPackedValue());
                    return Unit.INSTANCE;
                }

                public final void m2538invokek4lQ0M(long j) {
                    function0.invoke();
                }
            }, (Continuation) this, 7, null) == coroutine_suspended) {
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
