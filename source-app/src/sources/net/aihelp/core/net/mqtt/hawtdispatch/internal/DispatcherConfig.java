package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import net.aihelp.core.net.mqtt.hawtdispatch.Dispatcher;

public class DispatcherConfig {
    private static HawtDispatcher defaultDispatcher;
    private String label = "hawtdispatch";
    private int threads = Integer.getInteger("hawtdispatch.threads", Runtime.getRuntime().availableProcessors()).intValue();
    private boolean profile = Boolean.getBoolean("hawtdispatch.profile");
    private int drains = Integer.getInteger("hawtdispatch.drains", 1000).intValue();
    private boolean jmx = "true".equals(System.getProperty("hawtdispatch.jmx", "true").toLowerCase());

    public static synchronized HawtDispatcher getDefaultDispatcher() {
        if (defaultDispatcher == null) {
            defaultDispatcher = new DispatcherConfig().createDispatcher();
        }
        return defaultDispatcher;
    }

    public static Dispatcher create(String str, int i) {
        DispatcherConfig dispatcherConfig = new DispatcherConfig();
        dispatcherConfig.label = str;
        dispatcherConfig.threads = i;
        return dispatcherConfig.createDispatcher();
    }

    public HawtDispatcher createDispatcher() {
        return new HawtDispatcher(this);
    }

    public String getLabel() {
        return this.label;
    }

    public void setLabel(String str) {
        this.label = str;
    }

    public int getThreads() {
        return this.threads;
    }

    public void setThreads(int i) {
        this.threads = i;
    }

    public boolean isProfile() {
        return this.profile;
    }

    public void setProfile(boolean z) {
        this.profile = z;
    }

    public int getDrains() {
        return this.drains;
    }

    public void setDrains(int i) {
        this.drains = i;
    }

    public boolean isJmx() {
        return this.jmx;
    }

    public void setJmx(boolean z) {
        this.jmx = z;
    }
}
