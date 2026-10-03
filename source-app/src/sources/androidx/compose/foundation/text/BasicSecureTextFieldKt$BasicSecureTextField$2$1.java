package androidx.compose.foundation.text;

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
@DebugMetadata(c = "androidx.compose.foundation.text.BasicSecureTextFieldKt$BasicSecureTextField$2$1", f = "BasicSecureTextField.kt", i = {}, l = {}, m = "invokeSuspend", n = {}, s = {})
final class BasicSecureTextFieldKt$BasicSecureTextField$2$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final boolean $revealLastTypedEnabled;
    final SecureTextFieldController $secureTextFieldController;
    int label;

    BasicSecureTextFieldKt$BasicSecureTextField$2$1(boolean z, SecureTextFieldController secureTextFieldController, Continuation<? super BasicSecureTextFieldKt$BasicSecureTextField$2$1> continuation) {
        super(2, continuation);
        this.$revealLastTypedEnabled = z;
        this.$secureTextFieldController = secureTextFieldController;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new BasicSecureTextFieldKt$BasicSecureTextField$2$1(this.$revealLastTypedEnabled, this.$secureTextFieldController, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        IntrinsicsKt.getCOROUTINE_SUSPENDED();
        if (this.label != 0) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        if (!this.$revealLastTypedEnabled) {
            this.$secureTextFieldController.getPasswordInputTransformation().hide();
        }
        return Unit.INSTANCE;
    }
}
