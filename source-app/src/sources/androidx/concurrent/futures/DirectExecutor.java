package androidx.concurrent.futures;

import java.util.concurrent.Executor;

public enum DirectExecutor implements Executor {
    INSTANCE;

    @Override
    public void execute(Runnable runnable) {
        runnable.run();
    }

    @Override
    public String toString() {
        return "DirectExecutor";
    }
}
