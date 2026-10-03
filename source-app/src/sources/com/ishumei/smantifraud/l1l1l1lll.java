package com.ishumei.smantifraud;

import android.os.SystemClock;
import android.util.Log;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class l1l1l1lll {
    public static String l1111l111111Il = "Volley";
    public static final String l111l11111I1l = "com.ishumei.smantifraud.l1l1l1lll";
    public static boolean l111l11111lIl;

    public static class l1111l111111Il {
        public static final boolean l111l11111I1l = l1l1l1lll.l111l11111lIl;
        public static final long l111l11111Il = 0;
        public final List<C1181l1111l111111Il> l1111l111111Il = new ArrayList();
        public boolean l111l11111lIl = false;

        public static class C1181l1111l111111Il {
            public final String l1111l111111Il;
            public final long l111l11111I1l;
            public final long l111l11111lIl;

            public C1181l1111l111111Il(String str, long j, long j2) {
                this.l1111l111111Il = str;
                this.l111l11111lIl = j;
                this.l111l11111I1l = j2;
            }
        }

        public void finalize() throws Throwable {
            if (this.l111l11111lIl) {
                return;
            }
            l1111l111111Il("Request on the loose");
            l1l1l1lll.l111l11111I1l("Marker log finalized without finish() - uncaught exit point for request", new Object[0]);
        }

        public final long l1111l111111Il() {
            if (this.l1111l111111Il.size() == 0) {
                return 0L;
            }
            long j = this.l1111l111111Il.get(0).l111l11111I1l;
            List<C1181l1111l111111Il> list = this.l1111l111111Il;
            return list.get(list.size() - 1).l111l11111I1l - j;
        }

        public synchronized void l1111l111111Il(String str) {
            this.l111l11111lIl = true;
            long jL1111l111111Il = l1111l111111Il();
            if (jL1111l111111Il <= 0) {
                return;
            }
            long j = this.l1111l111111Il.get(0).l111l11111I1l;
            l1l1l1lll.l111l11111lIl("(%-4d ms) %s", Long.valueOf(jL1111l111111Il), str);
            for (C1181l1111l111111Il c1181l1111l111111Il : this.l1111l111111Il) {
                long j2 = c1181l1111l111111Il.l111l11111I1l;
                l1l1l1lll.l111l11111lIl("(+%-4d) [%2d] %s", Long.valueOf(j2 - j), Long.valueOf(c1181l1111l111111Il.l111l11111lIl), c1181l1111l111111Il.l1111l111111Il);
                j = j2;
            }
        }

        public synchronized void l1111l111111Il(String str, long j) {
            if (this.l111l11111lIl) {
                throw new IllegalStateException("Marker added to finished log");
            }
            this.l1111l111111Il.add(new C1181l1111l111111Il(str, j, SystemClock.elapsedRealtime()));
        }
    }

    public static String l1111l111111Il(String str, Object... objArr) {
        String str2;
        if (objArr != null) {
            str = String.format(Locale.US, str, objArr);
        }
        StackTraceElement[] stackTrace = new Throwable().fillInStackTrace().getStackTrace();
        for (int i = 2; i < stackTrace.length; i++) {
            if (!stackTrace[i].getClassName().equals(l111l11111I1l)) {
                String className = stackTrace[i].getClassName();
                String strSubstring = className.substring(className.lastIndexOf(46) + 1);
                str2 = strSubstring.substring(strSubstring.lastIndexOf(36) + 1) + "." + stackTrace[i].getMethodName();
                return String.format(Locale.US, "[%d] %s: %s", Long.valueOf(Thread.currentThread().getId()), str2, str);
            }
        }
        str2 = "<unknown>";
        return String.format(Locale.US, "[%d] %s: %s", Long.valueOf(Thread.currentThread().getId()), str2, str);
    }

    public static void l1111l111111Il(String str) {
        l111l11111lIl("Changing log tag to %s", str);
        l1111l111111Il = str;
        l111l11111lIl = Log.isLoggable(str, 2);
    }

    public static void l1111l111111Il(Throwable th, String str, Object... objArr) {
        Log.e(l1111l111111Il, l1111l111111Il(str, objArr), th);
    }

    public static void l111l11111I1l(String str, Object... objArr) {
        Log.e(l1111l111111Il, l1111l111111Il(str, objArr));
    }

    public static void l111l11111Il(String str, Object... objArr) {
        if (l111l11111lIl) {
            Log.v(l1111l111111Il, l1111l111111Il(str, objArr));
        }
    }

    public static void l111l11111lIl(String str, Object... objArr) {
        Log.d(l1111l111111Il, l1111l111111Il(str, objArr));
    }

    public static void l111l11111lIl(Throwable th, String str, Object... objArr) {
        Log.wtf(l1111l111111Il, l1111l111111Il(str, objArr), th);
    }

    public static void l111l1111l1Il(String str, Object... objArr) {
        Log.wtf(l1111l111111Il, l1111l111111Il(str, objArr));
    }
}
