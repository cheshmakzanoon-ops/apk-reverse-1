package zendesk.conversationkit.android.internal.extension;

import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CancellableContinuation;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0000\u001a \u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0000¨\u0006\u0006"}, m18d2 = {"safeResumeWithException", "", "T", "Lkotlinx/coroutines/CancellableContinuation;", "exception", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class SafeResumeWithExceptionKt {
    public static final <T> void safeResumeWithException(CancellableContinuation<? super T> cancellableContinuation, Throwable exception) {
        Intrinsics.checkNotNullParameter(cancellableContinuation, "<this>");
        Intrinsics.checkNotNullParameter(exception, "exception");
        if (cancellableContinuation.isActive()) {
            Result.Companion companion = Result.INSTANCE;
            cancellableContinuation.resumeWith(Result.m296constructorimpl(ResultKt.createFailure(exception)));
        }
    }
}
