package net.aihelp.core.net.mqtt.hawtdispatch;

public interface DispatchSource extends DispatchObject {
    void cancel();

    boolean isCanceled();

    void setCancelHandler(Runnable runnable);

    void setCancelHandler(Task task);

    void setEventHandler(Runnable runnable);

    void setEventHandler(Task task);
}
