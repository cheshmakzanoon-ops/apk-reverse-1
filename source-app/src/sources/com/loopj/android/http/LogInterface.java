package com.loopj.android.http;

public interface LogInterface {
    public static final int DEBUG = 3;
    public static final int ERROR = 6;
    public static final int INFO = 4;
    public static final int VERBOSE = 2;
    public static final int WARN = 5;
    public static final int WTF = 8;

    void mo382d(String str, String str2);

    void mo383d(String str, String str2, Throwable th);

    void mo384e(String str, String str2);

    void mo385e(String str, String str2, Throwable th);

    int getLoggingLevel();

    void mo386i(String str, String str2);

    void mo387i(String str, String str2, Throwable th);

    boolean isLoggingEnabled();

    void setLoggingEnabled(boolean z);

    void setLoggingLevel(int i);

    boolean shouldLog(int i);

    void mo388v(String str, String str2);

    void mo389v(String str, String str2, Throwable th);

    void mo390w(String str, String str2);

    void mo391w(String str, String str2, Throwable th);

    void wtf(String str, String str2);

    void wtf(String str, String str2, Throwable th);
}
