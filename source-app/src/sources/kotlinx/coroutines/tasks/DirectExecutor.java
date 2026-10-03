package kotlinx.coroutines.tasks;

import java.util.concurrent.Executor;
import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\bÂ\u0002\u0018\u00002\u00020\u0001B\t\b\u0002¢\u0006\u0004\b\u0002\u0010\u0003J\u0010\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H\u0016¨\u0006\b"}, m18d2 = {"Lkotlinx/coroutines/tasks/DirectExecutor;", "Ljava/util/concurrent/Executor;", "<init>", "()V", "execute", "", "r", "Ljava/lang/Runnable;", "kotlinx-coroutines-play-services"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
final class DirectExecutor implements Executor {
    public static final DirectExecutor INSTANCE = new DirectExecutor();

    private DirectExecutor() {
    }

    @Override
    public void execute(Runnable r) {
        r.run();
    }
}
