package net.aihelp.core.net.mqtt.hawtdispatch;

public class ShutdownException extends IllegalStateException {
    public ShutdownException() {
    }

    public ShutdownException(Throwable th) {
        super(th);
    }

    public ShutdownException(String str, Throwable th) {
        super(str, th);
    }

    public ShutdownException(String str) {
        super(str);
    }
}
