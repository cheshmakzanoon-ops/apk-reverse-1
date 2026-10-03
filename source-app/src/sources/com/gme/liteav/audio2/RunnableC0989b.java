package com.gme.liteav.audio2;

final class RunnableC0989b implements Runnable {

    private final AndroidInterruptedStateListener f574a;

    private RunnableC0989b(AndroidInterruptedStateListener androidInterruptedStateListener) {
        this.f574a = androidInterruptedStateListener;
    }

    public static Runnable m921a(AndroidInterruptedStateListener androidInterruptedStateListener) {
        return new RunnableC0989b(androidInterruptedStateListener);
    }

    @Override
    public final void run() {
        AndroidInterruptedStateListener.lambda$unregisterAudioRecordingCallback$1(this.f574a);
    }
}
