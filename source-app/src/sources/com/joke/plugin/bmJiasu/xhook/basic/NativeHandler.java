package com.joke.plugin.bmJiasu.xhook.basic;

public final class NativeHandler {
    private static final NativeHandler INSTANCE = new NativeHandler();

    public native int refresh(boolean z);

    public static NativeHandler getInstance() {
        return INSTANCE;
    }

    private NativeHandler() {
    }
}
