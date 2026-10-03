package net.aihelp.core.net.mqtt.hawtdispatch;

public abstract class Task implements Runnable {
    @Override
    public abstract void run();
}
