package com.ishumei.smantifraud;

import android.os.Handler;
import android.os.HandlerThread;

public abstract class AbsDetector extends l1l1l11I1l {
    protected static final int DEFAULT_INTERVAL = 5000;
    protected static final int MIN_INTERVAL = 1000;
    protected boolean isEmergency;
    private Handler mHandler;
    private HandlerThread mHandlerThread;
    protected int mIntervalMs = DEFAULT_INTERVAL;
    private final Runnable mTimeTask = new l1111l111111Il();
    private int mCurrentSerial = l1l11I11l.l111l11111Il().l1111l111111Il(getEventId());

    public class l1111l111111Il implements Runnable {
        public l1111l111111Il() {
        }

        @Override
        public void run() {
            AbsDetector.this.detect();
            AbsDetector.this.mHandler.postDelayed(AbsDetector.this.mTimeTask, AbsDetector.this.mIntervalMs);
        }
    }

    public boolean detect() {
        return false;
    }

    public synchronized int getAndIncrementSerial() {
        int i;
        i = this.mCurrentSerial;
        if (i >= Integer.MAX_VALUE) {
            this.mCurrentSerial = 0;
        } else {
            this.mCurrentSerial = i + 1;
        }
        l1l11I11l.l111l11111Il().l1111l111111Il(getEventId(), this.mCurrentSerial);
        return i;
    }

    public abstract String getEventId();

    public VDataListener getListener() {
        return this.mListener;
    }

    public int getVersionCode() {
        return 0;
    }

    public synchronized void start() {
    }

    public synchronized void startTimer() {
        if (this.mHandlerThread != null) {
            return;
        }
        HandlerThread handlerThread = new HandlerThread("sm-thread-dht");
        this.mHandlerThread = handlerThread;
        handlerThread.start();
        Handler handler = new Handler(this.mHandlerThread.getLooper());
        this.mHandler = handler;
        handler.postDelayed(this.mTimeTask, this.mIntervalMs);
    }

    public synchronized void stop() {
    }

    public synchronized void stopTimer() {
        try {
            if (this.mHandlerThread == null) {
                return;
            }
            Handler handler = this.mHandler;
            if (handler != null) {
                handler.removeCallbacksAndMessages(null);
            }
            this.mHandlerThread.quitSafely();
            this.mHandlerThread = null;
        } catch (Throwable unused) {
        }
    }
}
