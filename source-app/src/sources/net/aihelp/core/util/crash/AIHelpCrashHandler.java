package net.aihelp.core.util.crash;

import android.content.Context;
import android.os.Looper;
import android.util.Log;
import net.aihelp.BuildConfig;
import net.aihelp.core.util.logger.AIHelpLogger;

public enum AIHelpCrashHandler implements OnExceptionCaughtListener {
    INSTANCE;

    private static final CharSequence AIHELP_PACKAGE_NAME = BuildConfig.LIBRARY_PACKAGE_NAME;
    private static boolean sInstalled = false;

    public void init(final Context context) {
        if (sInstalled) {
            return;
        }
        final Thread.UncaughtExceptionHandler defaultUncaughtExceptionHandler = Thread.getDefaultUncaughtExceptionHandler();
        Thread.setDefaultUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {
            @Override
            public void uncaughtException(Thread thread, Throwable th) {
                if (AIHelpCrashHandler.isCrashedByAIHelp(th)) {
                    AIHelpCrashHandler.this.onExceptionCaught(context, th);
                    return;
                }
                Thread.UncaughtExceptionHandler uncaughtExceptionHandler = defaultUncaughtExceptionHandler;
                if (uncaughtExceptionHandler != null) {
                    uncaughtExceptionHandler.uncaughtException(thread, th);
                }
            }
        });
        sInstalled = true;
    }

    @Override
    public void onExceptionCaught(Context context, Throwable th) {
        AIHelpLogger.fatal(th.getMessage(), th);
        if (Thread.currentThread() != Looper.getMainLooper().getThread()) {
            return;
        }
        while (true) {
            try {
                Looper.loop();
            } catch (Exception e) {
                e.printStackTrace();
                if (throwChoreographerException(e)) {
                    return;
                } else {
                    AIHelpLogger.fatal(e.getMessage(), e);
                }
            }
        }
    }

    public static boolean isCrashedByAIHelp(Throwable th) {
        if (th == null) {
            return false;
        }
        return Log.getStackTraceString(th).contains(AIHELP_PACKAGE_NAME);
    }

    private boolean throwChoreographerException(Throwable th) {
        if (th == null) {
            return false;
        }
        StackTraceElement[] stackTrace = th.getStackTrace();
        for (int length = stackTrace.length - 1; length > -1 && stackTrace.length - length <= 20; length--) {
            StackTraceElement stackTraceElement = stackTrace[length];
            if ("android.view.Choreographer".equals(stackTraceElement.getClassName()) && "Choreographer.java".equals(stackTraceElement.getFileName()) && "doFrame".equals(stackTraceElement.getMethodName())) {
                return true;
            }
        }
        return false;
    }
}
