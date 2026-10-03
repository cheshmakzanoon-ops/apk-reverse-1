package androidx.compose.foundation.text;

import androidx.compose.foundation.text.input.internal.selection.TextFieldSelectionState;
import androidx.compose.p002ui.input.pointer.PointerInputScope;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Landroidx/compose/ui/input/pointer/PointerInputScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.text.BasicTextFieldKt$TextFieldSelectionHandles$2$1", f = "BasicTextField.kt", i = {}, l = {458}, m = "invokeSuspend", n = {}, s = {})
final class BasicTextFieldKt$TextFieldSelectionHandles$2$1 extends SuspendLambda implements Function2<PointerInputScope, Continuation<? super Unit>, Object> {
    final TextFieldSelectionState $selectionState;
    private Object L$0;
    int label;

    BasicTextFieldKt$TextFieldSelectionHandles$2$1(TextFieldSelectionState textFieldSelectionState, Continuation<? super BasicTextFieldKt$TextFieldSelectionHandles$2$1> continuation) {
        super(2, continuation);
        this.$selectionState = textFieldSelectionState;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        Continuation<Unit> basicTextFieldKt$TextFieldSelectionHandles$2$1 = new BasicTextFieldKt$TextFieldSelectionHandles$2$1(this.$selectionState, continuation);
        basicTextFieldKt$TextFieldSelectionHandles$2$1.L$0 = obj;
        return basicTextFieldKt$TextFieldSelectionHandles$2$1;
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
            TextFieldSelectionState textFieldSelectionState = this.$selectionState;
            this.label = 1;
            if (textFieldSelectionState.selectionHandleGestures(pointerInputScope, true, this) == coroutine_suspended) {
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
