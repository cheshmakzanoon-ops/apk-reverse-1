package net.aihelp.utils;

import android.text.TextUtils;
import android.util.Log;

public class TLog {
    private static boolean DEBUG = false;
    private static final int MAX_LENGTH = 3072;

    public static void initLog(boolean z) {
        DEBUG = z;
    }

    private static synchronized String getTAG(String... strArr) {
        StringBuilder sb = new StringBuilder();
        for (StackTraceElement stackTraceElement : Thread.currentThread().getStackTrace()) {
            if (!stackTraceElement.isNativeMethod() && !stackTraceElement.getClassName().equals(Thread.class.getName()) && !stackTraceElement.getClassName().equals(TLog.class.getName())) {
                String str = "AIHelp ";
                if (strArr != null && strArr.length > 0) {
                    str = String.format("%s ", strArr[0]);
                }
                sb.append(str);
                sb.append(">> (");
                sb.append(stackTraceElement.getFileName());
                sb.append(":");
                sb.append(stackTraceElement.getLineNumber());
                sb.append(")");
                return sb.toString();
            }
        }
        return "";
    }

    public static synchronized void m138d(String str) {
        m139d("", str);
    }

    public static synchronized void m139d(String str, String str2) {
        if (DEBUG && !TextUtils.isEmpty(str2)) {
            for (String str3 : splitStr(str2)) {
                Log.d(getTAG(str), str3);
            }
        }
    }

    public static synchronized void json(String str, String str2) {
        if (DEBUG && !TextUtils.isEmpty(str2)) {
            String tag = getTAG(new String[0]);
            try {
                for (String str3 : splitStr(formatJson(str, str2))) {
                    Log.d(getTAG(new String[0]), str3);
                }
            } catch (Exception e) {
                e.printStackTrace();
                Log.d(tag, e.toString());
            }
        }
    }

    private static String[] splitStr(String str) {
        try {
            int length = str.length();
            int i = (length / MAX_LENGTH) + 1;
            String[] strArr = new String[i];
            int i2 = 0;
            for (int i3 = 0; i3 < i; i3++) {
                int i4 = i2 + MAX_LENGTH;
                if (i4 < length) {
                    strArr[i3] = str.substring(i2, i4);
                    i2 = i4;
                } else {
                    strArr[i3] = str.substring(i2, length);
                    i2 = length;
                }
            }
            return strArr;
        } catch (Exception e) {
            e.printStackTrace();
            return new String[0];
        }
    }

    private static String formatJson(String str, String str2) {
        if (str2 == null || "".equals(str2)) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        int i = 0;
        char c = 0;
        boolean z = false;
        int i2 = 0;
        while (i < str2.length()) {
            char cCharAt = str2.charAt(i);
            if (cCharAt == '\"') {
                if (c != '\\') {
                    z = !z;
                }
                sb.append(cCharAt);
            } else if (cCharAt == ',') {
                sb.append(cCharAt);
                if (c != '\\' && !z) {
                    sb.append('\n');
                    addIndentBlank(sb, i2);
                }
            } else if (cCharAt == '[') {
                if (i == 0) {
                    sb.append("\t\n");
                    sb.append(str);
                    sb.append(": \n\n");
                }
                sb.append(cCharAt);
                if (!z) {
                    sb.append('\n');
                    i2++;
                    addIndentBlank(sb, i2);
                }
            } else if (cCharAt == ']') {
                if (!z) {
                    sb.append('\n');
                    i2--;
                    addIndentBlank(sb, i2);
                }
                sb.append(cCharAt);
                if (i == str2.length() - 1) {
                    sb.append("\n\t");
                }
            } else if (cCharAt == '{') {
                if (i == 0) {
                    sb.append("\t\n");
                    sb.append(str);
                    sb.append(": \n\n");
                }
                sb.append(cCharAt);
                if (!z) {
                    sb.append('\n');
                    i2++;
                    addIndentBlank(sb, i2);
                }
            } else if (cCharAt == '}') {
                if (!z) {
                    sb.append('\n');
                    i2--;
                    addIndentBlank(sb, i2);
                }
                sb.append(cCharAt);
                if (i == str2.length() - 1) {
                    sb.append("\n\t");
                }
            } else {
                sb.append(cCharAt);
            }
            i++;
            c = cCharAt;
        }
        return sb.toString();
    }

    private static void addIndentBlank(StringBuilder sb, int i) {
        for (int i2 = 0; i2 < i; i2++) {
            sb.append('\t');
        }
    }

    public static void m140l(String str, boolean z) {
        if (DEBUG) {
            getTAG(new String[0]);
        }
    }
}
