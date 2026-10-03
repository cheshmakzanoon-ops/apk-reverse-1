package zendesk.logger;

import android.util.Log;
import j$.util.DesugarTimeZone;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

public class Logger {
    private static final String ISO_8601_FORMAT = "yyyy-MM-dd'T'HH:mm:ss'Z'";
    private static LogReceiver platformLogger;
    private static final TimeZone UTC_TIMEZONE = DesugarTimeZone.getTimeZone("UTC");
    private static final List<LogReceiver> USER_DEFINED_RECEIVERS = new ArrayList();
    private static boolean loggable = false;

    public interface LogReceiver {
        void log(Priority priority, String str, String str2, Throwable th);
    }

    static {
        platformLogger = new Java();
        try {
            Class.forName("android.os.Build");
            platformLogger = new Android();
        } catch (ClassNotFoundException unused) {
        }
    }

    public enum Priority {
        VERBOSE(2),
        DEBUG(3),
        INFO(4),
        WARN(5),
        ERROR(6);

        private final int priority;

        Priority(int i) {
            this.priority = i;
        }
    }

    private Logger() {
    }

    public static boolean isLoggable() {
        return loggable;
    }

    public static void setLoggable(boolean z) {
        loggable = z;
    }

    public static void addLogReceiver(LogReceiver logReceiver) {
        if (logReceiver != null) {
            USER_DEFINED_RECEIVERS.add(logReceiver);
        }
    }

    public static void removeAllLogReceiver() {
        USER_DEFINED_RECEIVERS.clear();
    }

    public static void m225w(String str, String str2, Object... objArr) {
        logInternal(Priority.WARN, str, str2, null, objArr);
    }

    public static void m224w(String str, String str2, Throwable th, Object... objArr) {
        logInternal(Priority.WARN, str, str2, th, objArr);
    }

    public static void m219e(String str, String str2, Object... objArr) {
        logInternal(Priority.ERROR, str, str2, null, objArr);
    }

    public static void m218e(String str, String str2, Throwable th, Object... objArr) {
        logInternal(Priority.ERROR, str, str2, th, objArr);
    }

    public static void m223v(String str, String str2, Object... objArr) {
        logInternal(Priority.VERBOSE, str, str2, null, objArr);
    }

    public static void m222v(String str, String str2, Throwable th, Object... objArr) {
        logInternal(Priority.VERBOSE, str, str2, th, objArr);
    }

    public static void m221i(String str, String str2, Object... objArr) {
        logInternal(Priority.INFO, str, str2, null, objArr);
    }

    public static void m220i(String str, String str2, Throwable th, Object... objArr) {
        logInternal(Priority.INFO, str, str2, th, objArr);
    }

    public static void m217d(String str, String str2, Object... objArr) {
        logInternal(Priority.DEBUG, str, str2, null, objArr);
    }

    public static void m216d(String str, String str2, Throwable th, Object... objArr) {
        logInternal(Priority.DEBUG, str, str2, th, objArr);
    }

    private static void logInternal(Priority priority, String str, String str2, Throwable th, Object... objArr) {
        if (loggable) {
            if (str2 == null) {
                str2 = "";
            }
            if (objArr != null && objArr.length > 0) {
                str2 = String.format(Locale.US, str2, objArr);
            }
            platformLogger.log(priority, str, str2, th);
            Iterator<LogReceiver> it = USER_DEFINED_RECEIVERS.iterator();
            while (it.hasNext()) {
                it.next().log(priority, str, str2, th);
            }
        }
    }

    static class Java implements LogReceiver {
        Java() {
        }

        @Override
        public void log(Priority priority, String str, String str2, Throwable th) {
            StringBuilder sb = new StringBuilder(100);
            sb.append("[");
            sb.append(new SimpleDateFormat(Logger.ISO_8601_FORMAT, Locale.US).format(new Date()));
            sb.append("] ");
            sb.append(priority == null ? LoggerHelper.getLevelFromPriority(Priority.INFO.priority) : LoggerHelper.getLevelFromPriority(priority.priority));
            sb.append("/");
            if (!StringUtils.hasLength(str)) {
                str = "UNKNOWN";
            }
            sb.append(str);
            sb.append(": ");
            sb.append(str2);
            System.out.println(sb.toString());
            if (th != null) {
                th.printStackTrace(System.out);
            }
        }
    }

    static class Android implements LogReceiver {
        private static final int MAX_LINE_LENGTH = 4000;

        Android() {
        }

        @Override
        public void log(Priority priority, String str, String str2, Throwable th) {
            String androidTag = LoggerHelper.getAndroidTag(str);
            StringBuilder sb = new StringBuilder(str2.length());
            if (Priority.ERROR == priority) {
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat(Logger.ISO_8601_FORMAT, Locale.US);
                simpleDateFormat.setTimeZone(Logger.UTC_TIMEZONE);
                sb.append("[UTC ");
                sb.append(simpleDateFormat.format(new Date()));
                sb.append("] ");
            }
            sb.append(str2);
            if (th != null) {
                sb.append(StringUtils.LINE_SEPARATOR);
                sb.append(Log.getStackTraceString(th));
            }
            Iterator<String> it = LoggerHelper.splitLogMessage(sb.toString(), MAX_LINE_LENGTH).iterator();
            while (it.hasNext()) {
                Log.println(priority == null ? Priority.INFO.priority : priority.priority, androidTag, it.next());
            }
        }
    }
}
