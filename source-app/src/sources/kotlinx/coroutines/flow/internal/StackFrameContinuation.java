package kotlinx.coroutines.flow.internal;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.CoroutineContext;
import kotlin.coroutines.jvm.internal.CoroutineStackFrame;

@Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0002\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u00022\u00060\u0004j\u0002`\u0003B\u001d\u0012\f\u0010\u0005\u001a\b\u0012\u0004\u0012\u00028\u00000\u0002\u0012\u0006\u0010\u0006\u001a\u00020\u0007¢\u0006\u0004\b\b\u0010\tJ\u001b\u0010\u000f\u001a\u00020\u00102\f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u00000\u0012H\u0016¢\u0006\u0002\u0010\u0013J\u0015\u0010\u0014\u001a\n\u0018\u00010\u0016j\u0004\u0018\u0001`\u0015H\u0016¢\u0006\u0002\u0010\u0017R\u0014\u0010\u0005\u001a\b\u0012\u0004\u0012\u00028\u00000\u0002X\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u001c\u0010\f\u001a\n\u0018\u00010\u0004j\u0004\u0018\u0001`\u00038VX\u0096\u0004¢\u0006\u0006\u001a\u0004\b\r\u0010\u000e¨\u0006\u0018"}, m18d2 = {"Lkotlinx/coroutines/flow/internal/StackFrameContinuation;", "T", "Lkotlin/coroutines/Continuation;", "Lkotlinx/coroutines/internal/CoroutineStackFrame;", "Lkotlin/coroutines/jvm/internal/CoroutineStackFrame;", "uCont", "context", "Lkotlin/coroutines/CoroutineContext;", "<init>", "(Lkotlin/coroutines/Continuation;Lkotlin/coroutines/CoroutineContext;)V", "getContext", "()Lkotlin/coroutines/CoroutineContext;", "callerFrame", "getCallerFrame", "()Lkotlin/coroutines/jvm/internal/CoroutineStackFrame;", "resumeWith", "", "result", "Lkotlin/Result;", "(Ljava/lang/Object;)V", "getStackTraceElement", "Lkotlinx/coroutines/internal/StackTraceElement;", "Ljava/lang/StackTraceElement;", "()Ljava/lang/StackTraceElement;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
final class StackFrameContinuation<T> implements Continuation<T>, CoroutineStackFrame {
    private final CoroutineContext context;
    private final Continuation<T> uCont;

    @Override
    public StackTraceElement getStackTraceElement() {
        return null;
    }

    public StackFrameContinuation(Continuation<? super T> continuation, CoroutineContext coroutineContext) {
        this.uCont = continuation;
        this.context = coroutineContext;
    }

    @Override
    public CoroutineContext getContext() {
        return this.context;
    }

    @Override
    public CoroutineStackFrame getCallerFrame() {
        Continuation<T> continuation = this.uCont;
        if (continuation instanceof CoroutineStackFrame) {
            return (CoroutineStackFrame) continuation;
        }
        return null;
    }

    @Override
    public void resumeWith(Object result) {
        this.uCont.resumeWith(result);
    }
}
