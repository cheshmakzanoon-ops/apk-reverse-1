package io.github.aakira.napier;

import android.os.Build;
import android.util.Log;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.StringsKt;
import kotlin.text.Typography;

@Metadata(m16bv = {1, 0, 3}, m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\b\n\u0002\b\u0002\u0018\u0000 \u00192\u00020\u0001:\u0001\u0019B\u000f\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0015\u0010\f\u001a\u00020\u00032\u0006\u0010\r\u001a\u00020\u0003H\u0000¢\u0006\u0002\b\u000eJ.\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\b\u0010\u0013\u001a\u0004\u0018\u00010\u00032\b\u0010\u0014\u001a\u0004\u0018\u00010\t2\b\u0010\u0015\u001a\u0004\u0018\u00010\u0003H\u0014J\u0010\u0010\u0016\u001a\u00020\u00032\u0006\u0010\u0013\u001a\u00020\u0003H\u0002J\f\u0010\u0017\u001a\u00020\u0018*\u00020\u0012H\u0002R\u0016\u0010\u0005\u001a\n \u0007*\u0004\u0018\u00010\u00060\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0018\u0010\b\u001a\u00020\u0003*\u00020\t8BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\n\u0010\u000b¨\u0006\u001a"}, m18d2 = {"Lio/github/aakira/napier/DebugAntilog;", "Lio/github/aakira/napier/Antilog;", "defaultTag", "", "(Ljava/lang/String;)V", "anonymousClass", "Ljava/util/regex/Pattern;", "kotlin.jvm.PlatformType", "stackTraceString", "", "getStackTraceString", "(Ljava/lang/Throwable;)Ljava/lang/String;", "createStackElementTag", "className", "createStackElementTag$napier_release", "performLog", "", "priority", "Lio/github/aakira/napier/Napier$Level;", "tag", "throwable", "message", "performTag", "toValue", "", "Companion", "napier_release"}, m19k = 1, m20mv = {1, 4, 2})
public final class DebugAntilog extends Antilog {
    private static final int CALL_STACK_INDEX = 9;
    private static final int MAX_LOG_LENGTH = 4000;
    private static final int MAX_TAG_LENGTH = 23;
    private final Pattern anonymousClass;
    private final String defaultTag;

    @Metadata(m16bv = {1, 0, 3}, m19k = 3, m20mv = {1, 4, 2})
    public final class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;

        static {
            int[] iArr = new int[Napier.Level.values().length];
            $EnumSwitchMapping$0 = iArr;
            iArr[Napier.Level.VERBOSE.ordinal()] = 1;
            iArr[Napier.Level.DEBUG.ordinal()] = 2;
            iArr[Napier.Level.INFO.ordinal()] = 3;
            iArr[Napier.Level.WARNING.ordinal()] = 4;
            iArr[Napier.Level.ERROR.ordinal()] = 5;
            iArr[Napier.Level.ASSERT.ordinal()] = 6;
        }
    }

    public DebugAntilog() {
        this(null, 1, 0 == true ? 1 : 0);
    }

    public DebugAntilog(String defaultTag) {
        Intrinsics.checkNotNullParameter(defaultTag, "defaultTag");
        this.defaultTag = defaultTag;
        this.anonymousClass = Pattern.compile("(\\$\\d+)+$");
    }

    public DebugAntilog(String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? "app" : str);
    }

    @Override
    protected void performLog(Napier.Level priority, String tag, Throwable throwable, String message) {
        int iMin;
        Intrinsics.checkNotNullParameter(priority, "priority");
        if (tag == null) {
            tag = performTag(this.defaultTag);
        }
        if (message != null) {
            if (throwable != null) {
                message = message + '\n' + getStackTraceString(throwable);
            }
        } else if (throwable == null || (message = getStackTraceString(throwable)) == null) {
            return;
        }
        int length = message.length();
        if (length <= MAX_LOG_LENGTH) {
            if (priority == Napier.Level.ASSERT) {
                Log.wtf(tag, message);
                return;
            } else {
                Log.println(toValue(priority), tag, message);
                return;
            }
        }
        int i = 0;
        while (i < length) {
            int iIndexOf$default = StringsKt.indexOf$default((CharSequence) message, '\n', i, false, 4, (Object) null);
            if (iIndexOf$default == -1) {
                iIndexOf$default = length;
            }
            while (true) {
                iMin = Math.min(iIndexOf$default, i + MAX_LOG_LENGTH);
                if (message != null) {
                    String strSubstring = message.substring(i, iMin);
                    Intrinsics.checkNotNullExpressionValue(strSubstring, "(this as java.lang.Strin…ing(startIndex, endIndex)");
                    if (toValue(priority) == 7) {
                        Log.wtf(tag, strSubstring);
                    } else {
                        Log.println(toValue(priority), tag, strSubstring);
                    }
                    if (iMin >= iIndexOf$default) {
                        break;
                    } else {
                        i = iMin;
                    }
                } else {
                    throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
                }
            }
            i = iMin + 1;
        }
    }

    private final String performTag(String tag) {
        Thread threadCurrentThread = Thread.currentThread();
        Intrinsics.checkNotNullExpressionValue(threadCurrentThread, "Thread.currentThread()");
        StackTraceElement[] stackTrace = threadCurrentThread.getStackTrace();
        if (stackTrace == null || stackTrace.length < 9) {
            return tag;
        }
        StackTraceElement stackTraceElement = stackTrace[9];
        StringBuilder sb = new StringBuilder();
        String className = stackTraceElement.getClassName();
        Intrinsics.checkNotNullExpressionValue(className, "className");
        sb.append(createStackElementTag$napier_release(className));
        sb.append(Typography.dollar);
        sb.append(stackTraceElement.getMethodName());
        return sb.toString();
    }

    public final String createStackElementTag$napier_release(String className) {
        Intrinsics.checkNotNullParameter(className, "className");
        Matcher matcher = this.anonymousClass.matcher(className);
        if (matcher.find()) {
            className = matcher.replaceAll("");
            Intrinsics.checkNotNullExpressionValue(className, "m.replaceAll(\"\")");
        }
        int iLastIndexOf$default = StringsKt.lastIndexOf$default((CharSequence) className, '.', 0, false, 6, (Object) null) + 1;
        if (className == null) {
            throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
        }
        String strSubstring = className.substring(iLastIndexOf$default);
        Intrinsics.checkNotNullExpressionValue(strSubstring, "(this as java.lang.String).substring(startIndex)");
        if (strSubstring.length() <= MAX_TAG_LENGTH || Build.VERSION.SDK_INT >= 24) {
            return strSubstring;
        }
        if (strSubstring == null) {
            throw new NullPointerException("null cannot be cast to non-null type java.lang.String");
        }
        String strSubstring2 = strSubstring.substring(0, MAX_TAG_LENGTH);
        Intrinsics.checkNotNullExpressionValue(strSubstring2, "(this as java.lang.Strin…ing(startIndex, endIndex)");
        return strSubstring2;
    }

    private final String getStackTraceString(Throwable th) {
        StringWriter stringWriter = new StringWriter(256);
        PrintWriter printWriter = new PrintWriter((Writer) stringWriter, false);
        th.printStackTrace(printWriter);
        printWriter.flush();
        String string = stringWriter.toString();
        Intrinsics.checkNotNullExpressionValue(string, "sw.toString()");
        return string;
    }

    private final int toValue(Napier.Level level) {
        switch (WhenMappings.$EnumSwitchMapping$0[level.ordinal()]) {
            case 1:
                return 2;
            case 2:
                return 3;
            case 3:
                return 4;
            case 4:
                return 5;
            case 5:
                return 6;
            case 6:
                return 7;
            default:
                throw new NoWhenBranchMatchedException();
        }
    }
}
