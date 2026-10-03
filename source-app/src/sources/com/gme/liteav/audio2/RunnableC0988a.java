package com.gme.liteav.audio2;

final class RunnableC0988a implements Runnable {

    private final AndroidInterruptedStateListener f573a;

    private RunnableC0988a(AndroidInterruptedStateListener androidInterruptedStateListener) {
        this.f573a = androidInterruptedStateListener;
    }

    public static Runnable m920a(AndroidInterruptedStateListener androidInterruptedStateListener) {
        return new RunnableC0988a(androidInterruptedStateListener);
    }

    @Override
    public final void run() {
        AndroidInterruptedStateListener.lambda$registerAudioRecordingCallback$0(this.f573a);
    }
}
