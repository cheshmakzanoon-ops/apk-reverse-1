package androidx.compose.foundation.text.input.internal;

import androidx.compose.runtime.MonotonicFrameClockKt;
import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.MutableSharedFlow;

@Metadata(d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, k = 3, mv = {1, 8, 0}, xi = 48)
@DebugMetadata(c = "androidx.compose.foundation.text.input.internal.AndroidTextInputSession_androidKt$platformSpecificTextInputSession$3$2$1", f = "AndroidTextInputSession.android.kt", i = {}, l = {115, 116}, m = "invokeSuspend", n = {}, s = {})
final class C0874x2b7eadeb extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final ComposeInputMethodManager $composeImm;
    final MutableSharedFlow<Unit> $it;
    int label;

    C0874x2b7eadeb(MutableSharedFlow<Unit> mutableSharedFlow, ComposeInputMethodManager composeInputMethodManager, Continuation<? super C0874x2b7eadeb> continuation) {
        super(2, continuation);
        this.$it = mutableSharedFlow;
        this.$composeImm = composeInputMethodManager;
    }

    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new C0874x2b7eadeb(this.$it, this.$composeImm, continuation);
    }

    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return create(coroutineScope, continuation).invokeSuspend(Unit.INSTANCE);
    }

    public final Object invokeSuspend(Object obj) throws KotlinNothingValueException {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i != 0) {
            if (i == 1) {
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            throw new KotlinNothingValueException();
        }
        ResultKt.throwOnFailure(obj);
        this.label = 1;
        if (MonotonicFrameClockKt.withFrameMillis(new Function1<Long, Unit>() {
            public final void invoke(long j) {
            }

            public Object invoke(Object obj2) {
                invoke(((Number) obj2).longValue());
                return Unit.INSTANCE;
            }
        }, (Continuation) this) == coroutine_suspended) {
            return coroutine_suspended;
        }
        MutableSharedFlow<Unit> mutableSharedFlow = this.$it;
        final ComposeInputMethodManager composeInputMethodManager = this.$composeImm;
        this.label = 2;
        if (mutableSharedFlow.collect(new FlowCollector() {
            public Object emit(Object obj2, Continuation continuation) {
                return emit((Unit) obj2, (Continuation<? super Unit>) continuation);
            }

            public final Object emit(Unit unit, Continuation<? super Unit> continuation) {
                composeInputMethodManager.startStylusHandwriting();
                return Unit.INSTANCE;
            }
        }, (Continuation) this) == coroutine_suspended) {
            return coroutine_suspended;
        }
        throw new KotlinNothingValueException();
    }
}
