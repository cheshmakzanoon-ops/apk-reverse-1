package kotlinx.coroutines;

import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\u001a\u0019\u0010\u0000\u001a\u00060\u0002j\u0002`\u00012\u0006\u0010\u0003\u001a\u00020\u0004H\u0007¢\u0006\u0002\u0010\u0005¨\u0006\u0006"}, m18d2 = {"newSingleThreadContext", "Lkotlinx/coroutines/CloseableCoroutineDispatcher;", "Lkotlinx/coroutines/ExecutorCoroutineDispatcher;", "name", "", "(Ljava/lang/String;)Lkotlinx/coroutines/ExecutorCoroutineDispatcher;", "kotlinx-coroutines-core"}, m19k = 5, m20mv = {2, 0, 0}, m22xi = 48, m23xs = "kotlinx/coroutines/ThreadPoolDispatcherKt")
final class ThreadPoolDispatcherKt__MultithreadedDispatchers_commonKt {
    public static final ExecutorCoroutineDispatcher newSingleThreadContext(String str) {
        return ThreadPoolDispatcherKt.newFixedThreadPoolContext(1, str);
    }
}
