package androidx.compose.material3;

import androidx.compose.p002ui.focus.FocusManager;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.DelayKt;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.material3.SearchBarDefaults$InputField$5$1", f = "SearchBar.android.kt", i = {}, l = {571}, m = "invokeSuspend", n = {}, s = {})
final class SearchBarDefaults$InputField$5$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final FocusManager $focusManager;
    final boolean $shouldClearFocus;
    int label;

    SearchBarDefaults$InputField$5$1(boolean z, FocusManager focusManager, Continuation<? super SearchBarDefaults$InputField$5$1> continuation) {
        super(2, continuation);
        this.$shouldClearFocus = z;
        this.$focusManager = focusManager;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new SearchBarDefaults$InputField$5$1(this.$shouldClearFocus, this.$focusManager, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (this.$shouldClearFocus) {
                this.label = 1;
                if (DelayKt.delay(100L, (Continuation) this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            return Unit.INSTANCE;
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        FocusManager.CC.clearFocus$default(this.$focusManager, false, 1, null);
        return Unit.INSTANCE;
    }
}
