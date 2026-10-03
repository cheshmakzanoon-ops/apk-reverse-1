package io.github.aakira.napier;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m16bv = {1, 0, 3}, m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010!\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\bÇ\u0002\u0018\u00002\u00020\u0001:\u0001\u001cB\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000e\u0010\u0006\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u0005J,\u0010\t\u001a\u00020\u00072\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ&\u0010\t\u001a\u00020\u00072\u0006\u0010\n\u001a\u00020\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ,\u0010\u0010\u001a\u00020\u00072\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ&\u0010\u0010\u001a\u00020\u00072\u0006\u0010\n\u001a\u00020\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ,\u0010\u0011\u001a\u00020\u00072\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ&\u0010\u0011\u001a\u00020\u00072\u0006\u0010\n\u001a\u00020\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ\u0018\u0010\u0012\u001a\u00020\u00132\u0006\u0010\u0014\u001a\u00020\u00152\b\u0010\u000f\u001a\u0004\u0018\u00010\fJ4\u0010\u0016\u001a\u00020\u00072\u0006\u0010\u0014\u001a\u00020\u00152\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000bJ.\u0010\u0016\u001a\u00020\u00072\u0006\u0010\u0014\u001a\u00020\u00152\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\u0006\u0010\n\u001a\u00020\fJ.\u0010\u0017\u001a\u00020\u00072\u0006\u0010\u0014\u001a\u00020\u00152\b\u0010\u000f\u001a\u0004\u0018\u00010\f2\b\u0010\r\u001a\u0004\u0018\u00010\u000e2\b\u0010\n\u001a\u0004\u0018\u00010\fH\u0001J\u0006\u0010\u0018\u001a\u00020\u0007J\u000e\u0010\u0018\u001a\u00020\u00072\u0006\u0010\b\u001a\u00020\u0005J,\u0010\u0019\u001a\u00020\u00072\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ&\u0010\u0019\u001a\u00020\u00072\u0006\u0010\n\u001a\u00020\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ,\u0010\u001a\u001a\u00020\u00072\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ&\u0010\u001a\u001a\u00020\u00072\u0006\u0010\n\u001a\u00020\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ,\u0010\u001b\u001a\u00020\u00072\f\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000b2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fJ&\u0010\u001b\u001a\u00020\u00072\u0006\u0010\n\u001a\u00020\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\fR\u0014\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001d"}, m18d2 = {"Lio/github/aakira/napier/Napier;", "", "()V", "baseArray", "", "Lio/github/aakira/napier/Antilog;", "base", "", "antilog", "d", "message", "Lkotlin/Function0;", "", "throwable", "", "tag", "e", "i", "isEnable", "", "priority", "Lio/github/aakira/napier/Napier$Level;", "log", "rawLog", "takeLogarithm", "v", "w", "wtf", "Level", "napier_release"}, m19k = 1, m20mv = {1, 4, 2})
public final class Napier {
    public static final Napier INSTANCE = new Napier();
    private static final List<Antilog> baseArray = new ArrayList();

    @Metadata(m16bv = {1, 0, 3}, m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0010\u0010\n\u0002\b\b\b\u0086\u0001\u0018\u00002\b\u0012\u0004\u0012\u00020\u00000\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002j\u0002\b\u0003j\u0002\b\u0004j\u0002\b\u0005j\u0002\b\u0006j\u0002\b\u0007j\u0002\b\b¨\u0006\t"}, m18d2 = {"Lio/github/aakira/napier/Napier$Level;", "", "(Ljava/lang/String;I)V", "VERBOSE", "DEBUG", "INFO", "WARNING", "ERROR", "ASSERT", "napier_release"}, m19k = 1, m20mv = {1, 4, 2})
    public enum Level {
        VERBOSE,
        DEBUG,
        INFO,
        WARNING,
        ERROR,
        ASSERT
    }

    private Napier() {
    }

    public final void base(Antilog antilog) {
        Intrinsics.checkNotNullParameter(antilog, "antilog");
        baseArray.add(antilog);
    }

    public final boolean isEnable(Level priority, String tag) {
        Intrinsics.checkNotNullParameter(priority, "priority");
        List<Antilog> list = baseArray;
        if ((list instanceof Collection) && list.isEmpty()) {
            return false;
        }
        Iterator<T> it = list.iterator();
        while (it.hasNext()) {
            if (((Antilog) it.next()).isEnable(priority, tag)) {
                return true;
            }
        }
        return false;
    }

    public final void rawLog(Level priority, String tag, Throwable throwable, String message) {
        Intrinsics.checkNotNullParameter(priority, "priority");
        Iterator<T> it = baseArray.iterator();
        while (it.hasNext()) {
            ((Antilog) it.next()).rawLog$napier_release(priority, tag, throwable, message);
        }
    }

    public static void v$default(Napier napier, String str, Throwable th, String str2, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str2 = null;
        }
        napier.m12v(str, th, str2);
    }

    public final void m12v(String message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.VERBOSE, tag, throwable, message);
    }

    public static void v$default(Napier napier, Function0 function0, Throwable th, String str, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str = null;
        }
        napier.m13v((Function0<String>) function0, th, str);
    }

    public final void m13v(Function0<String> message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.VERBOSE, tag, throwable, message);
    }

    public static void i$default(Napier napier, String str, Throwable th, String str2, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str2 = null;
        }
        napier.m10i(str, th, str2);
    }

    public final void m10i(String message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.INFO, tag, throwable, message);
    }

    public static void i$default(Napier napier, Function0 function0, Throwable th, String str, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str = null;
        }
        napier.m11i((Function0<String>) function0, th, str);
    }

    public final void m11i(Function0<String> message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.INFO, tag, throwable, message);
    }

    public static void d$default(Napier napier, String str, Throwable th, String str2, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str2 = null;
        }
        napier.m6d(str, th, str2);
    }

    public final void m6d(String message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.DEBUG, tag, throwable, message);
    }

    public static void d$default(Napier napier, Function0 function0, Throwable th, String str, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str = null;
        }
        napier.m7d((Function0<String>) function0, th, str);
    }

    public final void m7d(Function0<String> message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.DEBUG, tag, throwable, message);
    }

    public static void w$default(Napier napier, String str, Throwable th, String str2, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str2 = null;
        }
        napier.m14w(str, th, str2);
    }

    public final void m14w(String message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.WARNING, tag, throwable, message);
    }

    public static void w$default(Napier napier, Function0 function0, Throwable th, String str, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str = null;
        }
        napier.m15w((Function0<String>) function0, th, str);
    }

    public final void m15w(Function0<String> message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.WARNING, tag, throwable, message);
    }

    public static void e$default(Napier napier, String str, Throwable th, String str2, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str2 = null;
        }
        napier.m8e(str, th, str2);
    }

    public final void m8e(String message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.ERROR, tag, throwable, message);
    }

    public static void e$default(Napier napier, Function0 function0, Throwable th, String str, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str = null;
        }
        napier.m9e((Function0<String>) function0, th, str);
    }

    public final void m9e(Function0<String> message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.ERROR, tag, throwable, message);
    }

    public static void wtf$default(Napier napier, String str, Throwable th, String str2, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str2 = null;
        }
        napier.wtf(str, th, str2);
    }

    public final void wtf(String message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.ASSERT, tag, throwable, message);
    }

    public static void wtf$default(Napier napier, Function0 function0, Throwable th, String str, int i, Object obj) {
        if ((i & 2) != 0) {
            th = null;
        }
        if ((i & 4) != 0) {
            str = null;
        }
        napier.wtf((Function0<String>) function0, th, str);
    }

    public final void wtf(Function0<String> message, Throwable throwable, String tag) {
        Intrinsics.checkNotNullParameter(message, "message");
        log(Level.ASSERT, tag, throwable, message);
    }

    public static void log$default(Napier napier, Level level, String str, Throwable th, String str2, int i, Object obj) {
        if ((i & 2) != 0) {
            str = null;
        }
        if ((i & 4) != 0) {
            th = null;
        }
        napier.log(level, str, th, str2);
    }

    public final void log(Level priority, String tag, Throwable throwable, String message) {
        Intrinsics.checkNotNullParameter(priority, "priority");
        Intrinsics.checkNotNullParameter(message, "message");
        if (isEnable(priority, tag)) {
            rawLog(priority, tag, throwable, message);
        }
    }

    public static void log$default(Napier napier, Level level, String str, Throwable th, Function0 function0, int i, Object obj) {
        if ((i & 2) != 0) {
            str = null;
        }
        if ((i & 4) != 0) {
            th = null;
        }
        napier.log(level, str, th, (Function0<String>) function0);
    }

    public final void log(Level priority, String tag, Throwable throwable, Function0<String> message) {
        Intrinsics.checkNotNullParameter(priority, "priority");
        Intrinsics.checkNotNullParameter(message, "message");
        if (isEnable(priority, tag)) {
            rawLog(priority, tag, throwable, message.invoke());
        }
    }

    public final void takeLogarithm(Antilog antilog) {
        Intrinsics.checkNotNullParameter(antilog, "antilog");
        baseArray.remove(antilog);
    }

    public final void takeLogarithm() {
        baseArray.clear();
    }
}
