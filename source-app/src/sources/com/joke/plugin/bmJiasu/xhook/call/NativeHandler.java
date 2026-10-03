package com.joke.plugin.bmJiasu.xhook.call;

public final class NativeHandler {
    private static final NativeHandler INSTANCE = new NativeHandler();

    public native void allStart();

    public native void setSpeed(float f);

    public native void start();

    public native void stop();

    public static NativeHandler getInstance() {
        return INSTANCE;
    }

    private NativeHandler() {
    }
}
