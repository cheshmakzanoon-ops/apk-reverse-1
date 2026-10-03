package zendesk.core.android.internal.p016di;

import dagger.Module;
import dagger.Provides;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.Dispatchers;
import kotlinx.coroutines.ExecutorsKt;
import zendesk.core.android.internal.InternalZendeskApi;

@InternalZendeskApi
@Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0007\u0018\u0000 \b2\u00020\u0001:\u0001\bB\u0005¢\u0006\u0002\u0010\u0002J\b\u0010\u0003\u001a\u00020\u0004H\u0007J\b\u0010\u0005\u001a\u00020\u0004H\u0007J\b\u0010\u0006\u001a\u00020\u0004H\u0007J\b\u0010\u0007\u001a\u00020\u0004H\u0007¨\u0006\t"}, m18d2 = {"Lzendesk/core/android/internal/di/CoroutineDispatchersModule;", "", "()V", "defaultDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "ioDispatcher", "mainDispatcher", "persistenceDispatcher", "Companion", "zendesk.core_core-utilities"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class CoroutineDispatchersModule {
    public static final String DEFAULT_DISPATCHER = "DEFAULT_DISPATCHER";
    public static final String IO_DISPATCHER = "IO_DISPATCHER";
    public static final String MAIN_DISPATCHER = "MAIN_DISPATCHER";
    public static final String PERSISTENCE_DISPATCHER = "PERSISTENCE_DISPATCHER";

    @Provides
    @Named(MAIN_DISPATCHER)
    public final CoroutineDispatcher mainDispatcher() {
        return Dispatchers.getMain();
    }

    @Provides
    @Named(DEFAULT_DISPATCHER)
    public final CoroutineDispatcher defaultDispatcher() {
        return Dispatchers.getDefault();
    }

    @Provides
    @Named(IO_DISPATCHER)
    public final CoroutineDispatcher ioDispatcher() {
        return Dispatchers.getIO();
    }

    @Provides
    @Named(PERSISTENCE_DISPATCHER)
    public final CoroutineDispatcher persistenceDispatcher() {
        ExecutorService executorServiceNewSingleThreadExecutor = Executors.newSingleThreadExecutor();
        Intrinsics.checkNotNullExpressionValue(executorServiceNewSingleThreadExecutor, "newSingleThreadExecutor(...)");
        return ExecutorsKt.from(executorServiceNewSingleThreadExecutor);
    }
}
