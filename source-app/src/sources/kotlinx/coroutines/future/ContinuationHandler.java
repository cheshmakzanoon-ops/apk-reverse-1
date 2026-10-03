package kotlinx.coroutines.future;

import java.util.concurrent.CompletionException;
import java.util.function.BiFunction;
import java.util.function.Function;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import okio.NioSystemFileSystem$$ExternalSyntheticApiModelOutline0;

@Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\b\u0002\u0018\u0000*\u0004\b\u0000\u0010\u00012\u0018\u0012\u0006\u0012\u0004\u0018\u0001H\u0001\u0012\u0006\u0012\u0004\u0018\u00010\u0003\u0012\u0004\u0012\u00020\u00040\u0002B\u0017\u0012\u000e\u0010\u0005\u001a\n\u0012\u0004\u0012\u00028\u0000\u0018\u00010\u0006¢\u0006\u0004\b\u0007\u0010\bJ!\u0010\t\u001a\u00020\u00042\b\u0010\n\u001a\u0004\u0018\u00018\u00002\b\u0010\u000b\u001a\u0004\u0018\u00010\u0003H\u0016¢\u0006\u0002\u0010\fR\u001a\u0010\u0005\u001a\n\u0012\u0004\u0012\u00028\u0000\u0018\u00010\u00068\u0006@\u0006X\u0087\u000e¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lkotlinx/coroutines/future/ContinuationHandler;", "T", "Ljava/util/function/BiFunction;", "", "", "cont", "Lkotlin/coroutines/Continuation;", "<init>", "(Lkotlin/coroutines/Continuation;)V", "apply", "result", "exception", "(Ljava/lang/Object;Ljava/lang/Throwable;)V", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
final class ContinuationHandler<T> implements BiFunction<T, Throwable, Unit> {
    public volatile Continuation<? super T> cont;

    @Override
    public BiFunction andThen(Function function) {
        return j$.util.function.BiFunction.-CC.$default$andThen(this, function);
    }

    public ContinuationHandler(Continuation<? super T> continuation) {
        this.cont = continuation;
    }

    @Override
    public Unit apply(Object obj, Throwable th) {
        apply2(obj, th);
        return Unit.INSTANCE;
    }

    public void apply2(T result, Throwable exception) {
        Throwable cause;
        Continuation<? super T> continuation = this.cont;
        if (continuation == null) {
            return;
        }
        if (exception == null) {
            Result.Companion companion = Result.INSTANCE;
            continuation.resumeWith(Result.m296constructorimpl(result));
            return;
        }
        CompletionException completionExceptionM170m = NioSystemFileSystem$$ExternalSyntheticApiModelOutline0.m177m((Object) exception) ? NioSystemFileSystem$$ExternalSyntheticApiModelOutline0.m170m((Object) exception) : null;
        if (completionExceptionM170m != null && (cause = completionExceptionM170m.getCause()) != null) {
            exception = cause;
        }
        Result.Companion companion2 = Result.INSTANCE;
        continuation.resumeWith(Result.m296constructorimpl(ResultKt.createFailure(exception)));
    }
}
