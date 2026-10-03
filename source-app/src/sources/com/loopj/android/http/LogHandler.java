package com.loopj.android.http;

import android.os.Build;
import android.util.Log;

public class LogHandler implements LogInterface {
    boolean mLoggingEnabled = true;
    int mLoggingLevel = 2;

    @Override
    public boolean isLoggingEnabled() {
        return this.mLoggingEnabled;
    }

    @Override
    public void setLoggingEnabled(boolean z) {
        this.mLoggingEnabled = z;
    }

    @Override
    public int getLoggingLevel() {
        return this.mLoggingLevel;
    }

    @Override
    public void setLoggingLevel(int i) {
        this.mLoggingLevel = i;
    }

    @Override
    public boolean shouldLog(int i) {
        return i >= this.mLoggingLevel;
    }

    public void log(int i, String str, String str2) {
        logWithThrowable(i, str, str2, null);
    }

    public void logWithThrowable(int i, String str, String str2, Throwable th) {
        if (isLoggingEnabled() && shouldLog(i)) {
            if (i == 2) {
                Log.v(str, str2, th);
                return;
            }
            if (i == 3) {
                Log.d(str, str2, th);
                return;
            }
            if (i == 4) {
                Log.i(str, str2, th);
                return;
            }
            if (i == 5) {
                Log.w(str, str2, th);
                return;
            }
            if (i == 6) {
                Log.e(str, str2, th);
            } else {
                if (i != 8) {
                    return;
                }
                if (Integer.valueOf(Build.VERSION.SDK).intValue() > 8) {
                    checkedWtf(str, str2, th);
                } else {
                    Log.e(str, str2, th);
                }
            }
        }
    }

    private void checkedWtf(String str, String str2, Throwable th) {
        Log.wtf(str, str2, th);
    }

    @Override
    public void mo388v(String str, String str2) {
        log(2, str, str2);
    }

    @Override
    public void mo389v(String str, String str2, Throwable th) {
        logWithThrowable(2, str, str2, th);
    }

    @Override
    public void mo382d(String str, String str2) {
        log(2, str, str2);
    }

    @Override
    public void mo383d(String str, String str2, Throwable th) {
        logWithThrowable(3, str, str2, th);
    }

    @Override
    public void mo386i(String str, String str2) {
        log(4, str, str2);
    }

    @Override
    public void mo387i(String str, String str2, Throwable th) {
        logWithThrowable(4, str, str2, th);
    }

    @Override
    public void mo390w(String str, String str2) {
        log(5, str, str2);
    }

    @Override
    public void mo391w(String str, String str2, Throwable th) {
        logWithThrowable(5, str, str2, th);
    }

    @Override
    public void mo384e(String str, String str2) {
        log(6, str, str2);
    }

    @Override
    public void mo385e(String str, String str2, Throwable th) {
        logWithThrowable(6, str, str2, th);
    }

    @Override
    public void wtf(String str, String str2) {
        log(8, str, str2);
    }

    @Override
    public void wtf(String str, String str2, Throwable th) {
        logWithThrowable(8, str, str2, th);
    }
}
