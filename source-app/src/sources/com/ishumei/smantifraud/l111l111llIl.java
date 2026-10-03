package com.ishumei.smantifraud;

import android.app.ActivityManager;
import android.content.Context;
import android.text.TextUtils;
import java.io.BufferedReader;
import java.io.Closeable;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Iterator;

public class l111l111llIl {
    public static final int l1111l111111Il = -1;
    public static final FileFilter l111l11111lIl = new l1111l111111Il();

    public class l1111l111111Il implements FileFilter {
        @Override
        public boolean accept(File file) {
            String name = file.getName();
            try {
                if (name.startsWith("cpu")) {
                    for (int i = 3; i < name.length(); i++) {
                        if (!Character.isDigit(name.charAt(i))) {
                            return false;
                        }
                    }
                    return true;
                }
            } catch (Exception unused) {
            }
            return false;
        }
    }

    public static class l111l11111lIl {
        public String l1111l111111Il = "";
        public String l111l11111lIl = "";
    }

    public static int l1111l111111Il() throws Throwable {
        Throwable th;
        FileInputStream fileInputStream;
        try {
            int iL111l11111I1l = l111l11111I1l();
            int i = -1;
            for (int i2 = 0; i2 < iL111l11111I1l; i2++) {
                File file = new File("/sys/devices/system/cpu/cpu" + i2 + "/cpufreq/cpuinfo_max_freq");
                if (file.exists()) {
                    byte[] bArr = new byte[128];
                    FileInputStream fileInputStream2 = new FileInputStream(file);
                    try {
                        fileInputStream2.read(bArr);
                        int i3 = 0;
                        while (i3 < 128 && Character.isDigit(bArr[i3])) {
                            i3++;
                        }
                        int i4 = Integer.parseInt(new String(bArr, 0, i3));
                        Integer numValueOf = Integer.valueOf(i4);
                        numValueOf.getClass();
                        if (i4 > i) {
                            numValueOf.getClass();
                            i = i4;
                        }
                    } catch (NumberFormatException unused) {
                    } catch (Throwable th2) {
                        l1l1l11Ill.l1111l111111Il((Closeable) fileInputStream2);
                        throw th2;
                    }
                    l1l1l11Ill.l1111l111111Il((Closeable) fileInputStream2);
                }
            }
            if (i == -1) {
                try {
                    fileInputStream = new FileInputStream("/proc/cpuinfo");
                    try {
                        int iL1111l111111Il = l1111l111111Il("cpu MHz", fileInputStream) * 1000;
                        if (iL1111l111111Il > i) {
                            i = iL1111l111111Il;
                        }
                        l1l1l11Ill.l1111l111111Il((Closeable) fileInputStream);
                    } catch (Throwable th3) {
                        th = th3;
                        l1l1l11Ill.l1111l111111Il((Closeable) fileInputStream);
                        throw th;
                    }
                } catch (Throwable th4) {
                    th = th4;
                    fileInputStream = null;
                }
            }
            return i;
        } catch (Exception unused2) {
            return -1;
        }
    }

    public static int l1111l111111Il(String str) throws Throwable {
        Throwable th;
        BufferedReader bufferedReader;
        FileInputStream fileInputStream = null;
        try {
            FileInputStream fileInputStream2 = new FileInputStream(str);
            try {
                bufferedReader = new BufferedReader(new InputStreamReader(fileInputStream2));
                try {
                    int iL111l11111lIl = l111l11111lIl(bufferedReader.readLine());
                    l1l1l11Ill.l1111l111111Il((Closeable) bufferedReader);
                    l1l1l11Ill.l1111l111111Il((Closeable) fileInputStream2);
                    return iL111l11111lIl;
                } catch (IOException unused) {
                    fileInputStream = fileInputStream2;
                    l1l1l11Ill.l1111l111111Il((Closeable) bufferedReader);
                    l1l1l11Ill.l1111l111111Il((Closeable) fileInputStream);
                    return -1;
                } catch (Throwable th2) {
                    th = th2;
                    fileInputStream = fileInputStream2;
                    l1l1l11Ill.l1111l111111Il((Closeable) bufferedReader);
                    l1l1l11Ill.l1111l111111Il((Closeable) fileInputStream);
                    throw th;
                }
            } catch (IOException unused2) {
                bufferedReader = null;
            } catch (Throwable th3) {
                th = th3;
                bufferedReader = null;
            }
        } catch (IOException unused3) {
            bufferedReader = null;
        } catch (Throwable th4) {
            th = th4;
            bufferedReader = null;
        }
    }

    public static int l1111l111111Il(String str, FileInputStream fileInputStream) {
        byte[] bArr = new byte[1024];
        try {
            int i = fileInputStream.read(bArr);
            int i2 = 0;
            while (i2 < i) {
                byte b = bArr[i2];
                if (b == 10 || i2 == 0) {
                    if (b == 10) {
                        i2++;
                    }
                    for (int i3 = i2; i3 < i; i3++) {
                        int i4 = i3 - i2;
                        if (bArr[i3] != str.charAt(i4)) {
                            break;
                        }
                        if (i4 == str.length() - 1) {
                            return l1111l111111Il(bArr, i3);
                        }
                    }
                }
                i2++;
            }
            return -1;
        } catch (IOException | NumberFormatException unused) {
            return -1;
        }
    }

    public static int l1111l111111Il(byte[] bArr, int i) {
        byte b;
        while (i < bArr.length && (b = bArr[i]) != 10) {
            if (Character.isDigit(b)) {
                int i2 = i + 1;
                while (i2 < bArr.length && Character.isDigit(bArr[i2])) {
                    i2++;
                }
                return Integer.parseInt(new String(bArr, 0, i, i2 - i));
            }
            i++;
        }
        return -1;
    }

    public static int l111l11111I1l() {
        try {
            int iL1111l111111Il = l1111l111111Il("/sys/devices/system/cpu/possible");
            if (iL1111l111111Il == -1) {
                iL1111l111111Il = l1111l111111Il("/sys/devices/system/cpu/present");
            }
            return iL1111l111111Il == -1 ? l111l11111lIl() : iL1111l111111Il;
        } catch (SecurityException | Exception unused) {
            return -1;
        }
    }

    public static long l111l11111Il() {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return 0L;
        }
        try {
            ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();
            ((ActivityManager) context.getSystemService("activity")).getMemoryInfo(memoryInfo);
            return memoryInfo.totalMem;
        } catch (Exception unused) {
            return 0L;
        }
    }

    public static int l111l11111lIl() {
        try {
            return new File("/sys/devices/system/cpu/possible").listFiles(l111l11111lIl).length;
        } catch (Exception unused) {
            return 0;
        }
    }

    public static int l111l11111lIl(String str) {
        if (str == null || !str.matches("0-[\\d]+$")) {
            return -1;
        }
        return Integer.parseInt(str.substring(2)) + 1;
    }

    public static l111l11111lIl l111l1111l1Il() {
        l111l11111lIl l111l11111lil = new l111l11111lIl();
        try {
            Iterator<String> it = l1l1l11Ill.l11l1111I1l("/proc/cpuinfo").iterator();
            while (it.hasNext()) {
                String[] strArrSplit = it.next().split(":");
                if (2 == strArrSplit.length) {
                    String strTrim = strArrSplit[0].trim();
                    String strTrim2 = strArrSplit[1].trim();
                    if ("Hardware".equals(strTrim)) {
                        l111l11111lil.l111l11111lIl = strTrim2;
                    }
                    if (TextUtils.equals("Processor", strTrim) || TextUtils.equals("model name", strTrim)) {
                        l111l11111lil.l1111l111111Il = strTrim2;
                    }
                }
            }
        } catch (Throwable unused) {
        }
        return l111l11111lil;
    }
}
