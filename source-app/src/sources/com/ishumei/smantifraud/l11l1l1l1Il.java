package com.ishumei.smantifraud;

import android.content.Context;
import android.os.Build;
import android.text.TextUtils;
import java.io.BufferedInputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Locale;

public class l11l1l1l1Il {
    public static String l1111l111111Il() throws Throwable {
        int iIntValue;
        try {
            String strL1111l111111Il = l1111l111111Il("cat /proc/self/cgroup");
            if (TextUtils.isEmpty(strL1111l111111Il)) {
                iIntValue = 0;
            } else {
                int iLastIndexOf = strL1111l111111Il.lastIndexOf("uid");
                int iLastIndexOf2 = strL1111l111111Il.lastIndexOf("/pid");
                if (iLastIndexOf < 0) {
                    iIntValue = 0;
                } else {
                    if (iLastIndexOf2 <= 0) {
                        iLastIndexOf2 = strL1111l111111Il.length();
                    }
                    String strReplaceAll = strL1111l111111Il.substring(iLastIndexOf + 4, iLastIndexOf2).replaceAll("\n", "");
                    if (l111l11111lIl(strReplaceAll)) {
                        iIntValue = Integer.valueOf(strReplaceAll).intValue();
                    } else {
                        iIntValue = 0;
                    }
                }
            }
        } catch (Exception unused) {
        }
        if (iIntValue == 0) {
            try {
                Context context = l11l11l111Il.l1111l111111Il;
                if (context != null) {
                    iIntValue = context.getApplicationInfo().uid;
                }
            } catch (Exception unused2) {
            }
        }
        if (iIntValue == 0) {
            return null;
        }
        return l1111l111111Il(iIntValue);
    }

    public static String l1111l111111Il(int i) {
        Method method;
        if (Build.VERSION.SDK_INT > 27) {
            return String.format(Locale.US, "u0_a%d", Integer.valueOf(i - 10000));
        }
        try {
            Field declaredField = Class.forName("libcore.io.Libcore").getDeclaredField(l111l1111lI1l.l111l11111I1l);
            if (!declaredField.isAccessible()) {
                declaredField.setAccessible(true);
            }
            Object obj = declaredField.get(null);
            if (obj != null && (method = obj.getClass().getMethod("getpwuid", Integer.TYPE)) != null) {
                if (!method.isAccessible()) {
                    method.setAccessible(true);
                }
                Object objInvoke = method.invoke(obj, Integer.valueOf(i));
                if (objInvoke != null) {
                    Field declaredField2 = objInvoke.getClass().getDeclaredField("pw_name");
                    if (!declaredField2.isAccessible()) {
                        declaredField2.setAccessible(true);
                    }
                    return (String) declaredField2.get(objInvoke);
                }
            }
            return null;
        } catch (Exception unused) {
            return String.format(Locale.US, "u0_a%d", Integer.valueOf(i - 10000));
        }
    }

    public static String l1111l111111Il(BufferedInputStream bufferedInputStream) {
        int i;
        if (bufferedInputStream == null) {
            return "";
        }
        byte[] bArr = new byte[512];
        StringBuilder sb = new StringBuilder();
        do {
            try {
                i = bufferedInputStream.read(bArr);
                if (i > 0) {
                    sb.append(new String(bArr, 0, i));
                }
            } catch (Exception unused) {
            }
        } while (i >= 512);
        return sb.toString();
    }

    public static String l1111l111111Il(String str) throws Throwable {
        Throwable th;
        Process processExec;
        BufferedInputStream bufferedInputStream;
        BufferedInputStream bufferedInputStream2 = null;
        try {
            processExec = Runtime.getRuntime().exec(str);
            try {
                bufferedInputStream = new BufferedInputStream(processExec.getInputStream());
                try {
                    processExec.waitFor();
                    String strL1111l111111Il = l1111l111111Il(bufferedInputStream);
                    try {
                        bufferedInputStream.close();
                    } catch (IOException unused) {
                    }
                    processExec.destroy();
                    return strL1111l111111Il;
                } catch (Exception unused2) {
                    if (bufferedInputStream != null) {
                        try {
                            bufferedInputStream.close();
                        } catch (IOException unused3) {
                        }
                    }
                    if (processExec != null) {
                        processExec.destroy();
                    }
                    return null;
                } catch (Throwable th2) {
                    th = th2;
                    bufferedInputStream2 = bufferedInputStream;
                    if (bufferedInputStream2 != null) {
                        try {
                            bufferedInputStream2.close();
                        } catch (IOException unused4) {
                        }
                    }
                    if (processExec == null) {
                        throw th;
                    }
                    processExec.destroy();
                    throw th;
                }
            } catch (Exception unused5) {
                bufferedInputStream = null;
                if (bufferedInputStream != null) {
                    bufferedInputStream.close();
                }
                if (processExec != null) {
                    processExec.destroy();
                }
                return null;
            } catch (Throwable th3) {
                th = th3;
            }
        } catch (Exception unused6) {
            processExec = null;
        } catch (Throwable th4) {
            th = th4;
            processExec = null;
        }
    }

    public static void l1111l111111Il(l11l1111lIIl l11l1111liil) throws Throwable {
        try {
            String strL1111l111111Il = l1111l111111Il();
            if (TextUtils.isEmpty(strL1111l111111Il)) {
                return;
            }
            String strL1111l111111Il2 = l1111l111111Il("ps");
            if (!TextUtils.isEmpty(strL1111l111111Il2) && strL1111l111111Il2.split("\n").length > 0) {
                l11l1111liil.l11l11l1I11l(strL1111l111111Il);
            }
        } catch (Exception unused) {
        }
    }

    public static void l111l11111lIl(l11l1111lIIl l11l1111liil) throws Throwable {
        l1111l111111Il(l11l1111liil);
    }

    public static boolean l111l11111lIl(String str) {
        if (str == null || str.length() == 0) {
            return false;
        }
        for (int i = 0; i < str.length(); i++) {
            if (!Character.isDigit(str.charAt(i))) {
                return false;
            }
        }
        return true;
    }
}
