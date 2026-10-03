package kotlinx.coroutines;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.CoroutineStackFrame;
import kotlinx.coroutines.internal.StackTraceRecoveryKt;

@Metadata(m17d1 = {"\u0000 \n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a\u001f\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u0003H\u0000¢\u0006\u0002\u0010\u0004\u001a+\u0010\u0000\u001a\u0004\u0018\u00010\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00032\n\u0010\u0005\u001a\u0006\u0012\u0002\b\u00030\u0006H\u0000¢\u0006\u0002\u0010\u0007\u001a1\u0010\b\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0003\"\u0004\b\u0000\u0010\u00022\b\u0010\t\u001a\u0004\u0018\u00010\u00012\f\u0010\n\u001a\b\u0012\u0004\u0012\u0002H\u00020\u000bH\u0000¢\u0006\u0002\u0010\f¨\u0006\r"}, m18d2 = {"toState", "", "T", "Lkotlin/Result;", "(Ljava/lang/Object;)Ljava/lang/Object;", "caller", "Lkotlinx/coroutines/CancellableContinuation;", "(Ljava/lang/Object;Lkotlinx/coroutines/CancellableContinuation;)Ljava/lang/Object;", "recoverResult", "state", "uCont", "Lkotlin/coroutines/Continuation;", "(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 2, m20mv = {2, 0, 0}, m22xi = 48)
public final class CompletionStateKt {
    public static final <T> Object toState(Object obj) {
        Throwable thM299exceptionOrNullimpl = Result.m299exceptionOrNullimpl(obj);
        return thM299exceptionOrNullimpl == null ? obj : new CompletedExceptionally(thM299exceptionOrNullimpl, false, 2, null);
    }

    public static final <T> Object toState(Object obj, CancellableContinuation<?> cancellableContinuation) {
        Throwable thM299exceptionOrNullimpl = Result.m299exceptionOrNullimpl(obj);
        if (thM299exceptionOrNullimpl != null) {
            if (DebugKt.getRECOVER_STACK_TRACES()) {
                CancellableContinuation<?> cancellableContinuation2 = cancellableContinuation;
                if (cancellableContinuation2 instanceof CoroutineStackFrame) {
                    thM299exceptionOrNullimpl = StackTraceRecoveryKt.recoverFromStackFrame(thM299exceptionOrNullimpl, (CoroutineStackFrame) cancellableContinuation2);
                }
            }
            obj = new CompletedExceptionally(thM299exceptionOrNullimpl, false, 2, null);
        }
        return obj;
    }

    public static final <T> Object recoverResult(Object obj, Continuation<? super T> continuation) {
        if (obj instanceof CompletedExceptionally) {
            Result.Companion companion = Result.INSTANCE;
            Throwable thRecoverFromStackFrame = ((CompletedExceptionally) obj).cause;
            if (DebugKt.getRECOVER_STACK_TRACES() && (continuation instanceof CoroutineStackFrame)) {
                thRecoverFromStackFrame = StackTraceRecoveryKt.recoverFromStackFrame(thRecoverFromStackFrame, (CoroutineStackFrame) continuation);
            }
            return Result.m296constructorimpl(ResultKt.createFailure(thRecoverFromStackFrame));
        }
        Result.Companion companion2 = Result.INSTANCE;
        return Result.m296constructorimpl(obj);
    }
}
