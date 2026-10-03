package net.aihelp.core.net.mqtt.hawtdispatch.internal;

public class HawtThreadGroup extends ThreadGroup {
    private final HawtDispatcher dispatcher;

    public HawtThreadGroup(HawtDispatcher hawtDispatcher, String str) {
        super(str);
        this.dispatcher = hawtDispatcher;
    }

    @Override
    public void uncaughtException(Thread thread, Throwable th) {
        Thread.UncaughtExceptionHandler uncaughtExceptionHandler = this.dispatcher.uncaughtExceptionHandler;
        if (uncaughtExceptionHandler != null) {
            uncaughtExceptionHandler.uncaughtException(thread, th);
        } else {
            super.uncaughtException(thread, th);
        }
    }
}
