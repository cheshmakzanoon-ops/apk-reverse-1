package com.gme.liteav.base.util;

import android.os.Handler;
import android.os.Looper;
import android.os.MessageQueue;
import com.gme.liteav.base.annotations.JNINamespace;
import com.gme.liteav.base.system.LiteavSystemInfo;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

@JNINamespace("liteav")
public class CustomHandler extends Handler {
    private static final long TIMEOUT_QUIT_LOOPER = TimeUnit.SECONDS.toMillis(30);
    private Runnable mQuitLooperTimeoutRunnable;
    private final String mTAG;
    private final Handler mUIHandler;

    public CustomHandler(Looper looper) {
        this(looper, null);
    }

    public CustomHandler(Looper looper, Handler.Callback callback) {
        super(looper, callback);
        this.mUIHandler = new Handler(Looper.getMainLooper());
        this.mQuitLooperTimeoutRunnable = new Runnable() {
            @Override
            public final void run() {
                LiteavLog.m994e(CustomHandler.this.mTAG, "quit looper failed.");
            }
        };
        String str = "TXCHandler";
        try {
            str = "TXCHandler_" + hashCode();
            LiteavLog.m998i(str, "[" + Thread.currentThread().getName() + "]");
        } catch (Throwable th) {
            LiteavLog.m995e("CustomHandler", "init failed.", th);
        }
        this.mTAG = str;
    }

    public boolean runAndWaitDone(Runnable runnable) {
        CountDownLatch countDownLatch = new CountDownLatch(1);
        boolean zPost = post(RunnableC1049a.m1007a(runnable, countDownLatch));
        if (zPost) {
            try {
                countDownLatch.await();
            } catch (InterruptedException unused) {
                Thread.currentThread().interrupt();
            }
        }
        return zPost;
    }

    static void lambda$runAndWaitDone$0(Runnable runnable, CountDownLatch countDownLatch) {
        runnable.run();
        countDownLatch.countDown();
    }

    public boolean runAndWaitDone(Runnable runnable, long j) {
        CountDownLatch countDownLatch = new CountDownLatch(1);
        boolean zPost = post(RunnableC1050b.m1008a(runnable, countDownLatch));
        if (zPost) {
            try {
                countDownLatch.await(j, TimeUnit.MILLISECONDS);
            } catch (InterruptedException unused) {
                Thread.currentThread().interrupt();
            }
        }
        return zPost;
    }

    static void lambda$runAndWaitDone$1(Runnable runnable, CountDownLatch countDownLatch) {
        runnable.run();
        countDownLatch.countDown();
    }

    public boolean runOrPost(Runnable runnable) {
        return runOrPost(runnable, 0);
    }

    public boolean postTask(Runnable runnable) {
        try {
            return post(runnable);
        } catch (Throwable th) {
            LiteavLog.m995e("CustomHandler", "postTask failed.", th);
            return false;
        }
    }

    public boolean postDelayedTask(Runnable runnable, long j) {
        try {
            return postDelayed(runnable, j);
        } catch (Throwable th) {
            LiteavLog.m995e("CustomHandler", "postDelayedTask failed.", th);
            return false;
        }
    }

    public boolean runOrPost(Runnable runnable, int i) {
        if (!getLooper().getThread().isAlive()) {
            return false;
        }
        if (Looper.myLooper() == getLooper() && i == 0) {
            runnable.run();
            return true;
        }
        if (i == 0) {
            return post(runnable);
        }
        return postDelayed(runnable, i);
    }

    public void quitLooper() {
        try {
            post(RunnableC1052d.m1010a(this, C1051c.m1009a(this)));
            this.mUIHandler.postDelayed(this.mQuitLooperTimeoutRunnable, TIMEOUT_QUIT_LOOPER);
        } catch (Throwable th) {
            LiteavLog.m995e("CustomHandler", "quitLooper failed.", th);
        }
    }

    static boolean lambda$quitLooper$2(CustomHandler customHandler) {
        LiteavLog.m998i(customHandler.mTAG, "queue idle handle.");
        if (LiteavSystemInfo.getSystemOSVersionInt() >= 18) {
            customHandler.getLooper().quitSafely();
        } else {
            customHandler.getLooper().quit();
        }
        customHandler.mUIHandler.removeCallbacks(customHandler.mQuitLooperTimeoutRunnable);
        return false;
    }

    static void lambda$quitLooper$3(CustomHandler customHandler, MessageQueue.IdleHandler idleHandler) {
        if (customHandler.getLooper() == Looper.getMainLooper()) {
            LiteavLog.m994e(customHandler.mTAG, "try to quitLooper main looper!");
        } else {
            LiteavLog.m998i(customHandler.mTAG, "add idle handle.");
            Looper.myQueue().addIdleHandler(idleHandler);
        }
    }

    public void quitLooperAndWaitDone() {
        quitLooper();
        try {
            getLooper().getThread().join();
        } catch (InterruptedException unused) {
        }
    }

    public boolean isCurrentThread() {
        try {
            return Looper.myLooper() != null && Looper.myLooper() == getLooper();
        } catch (Throwable th) {
            LiteavLog.m995e("CustomHandler", "isCurrentThread failed.", th);
            return false;
        }
    }
}
