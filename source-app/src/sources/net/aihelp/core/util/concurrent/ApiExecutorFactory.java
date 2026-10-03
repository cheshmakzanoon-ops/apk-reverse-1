package net.aihelp.core.util.concurrent;

public class ApiExecutorFactory {
    public static ApiExecutor getHandlerExecutor() {
        return LazyHolder.HANDLER_EXECUTOR;
    }

    private static class LazyHolder {
        static final ApiExecutor HANDLER_EXECUTOR = new HandlerThreadExecutor("AIHelp-Worker-Thread");

        private LazyHolder() {
        }
    }
}
