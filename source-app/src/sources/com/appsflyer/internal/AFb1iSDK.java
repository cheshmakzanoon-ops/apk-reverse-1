package com.appsflyer.internal;

import android.util.Base64;
import com.appsflyer.AFLogger;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

public final class AFb1iSDK implements AFb1rSDK {
    private final AFd1lSDK AFKeystoreWrapper;

    public AFb1iSDK(AFd1lSDK aFd1lSDK) {
        this.AFKeystoreWrapper = aFd1lSDK;
    }

    @Override
    public final void values() {
        try {
            if (new File(this.AFKeystoreWrapper.AFInAppEventParameterName.getFilesDir(), "AFRequestCache").exists()) {
                return;
            }
            new File(this.AFKeystoreWrapper.AFInAppEventParameterName.getFilesDir(), "AFRequestCache").mkdir();
        } catch (Exception e) {
            AFLogger.afErrorLog("CACHE: Could not create cache directory", e);
        }
    }

    @Override
    public final String AFInAppEventType(AFb1kSDK aFb1kSDK) throws Throwable {
        OutputStreamWriter outputStreamWriter;
        StringWriter stringWriter = 0;
        try {
            try {
                File file = new File(this.AFKeystoreWrapper.AFInAppEventParameterName.getFilesDir(), "AFRequestCache");
                if (!file.exists()) {
                    file.mkdir();
                    return null;
                }
                File[] fileArrListFiles = file.listFiles();
                if (fileArrListFiles != null && fileArrListFiles.length > 40) {
                    AFLogger.INSTANCE.m802i(AFg1hSDK.CACHE, "reached cache limit, not caching request");
                    return null;
                }
                AFLogger aFLogger = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK = AFg1hSDK.CACHE;
                StringBuilder sb = new StringBuilder("caching request with URL: ");
                sb.append(aFb1kSDK.valueOf);
                aFLogger.m802i(aFg1hSDK, sb.toString());
                String string = Long.toString(System.currentTimeMillis());
                File file2 = new File(new File(this.AFKeystoreWrapper.AFInAppEventParameterName.getFilesDir(), "AFRequestCache"), string);
                file2.createNewFile();
                outputStreamWriter = new OutputStreamWriter(new FileOutputStream(file2.getPath(), true), Charset.defaultCharset());
                try {
                    outputStreamWriter.write("version=");
                    outputStreamWriter.write(aFb1kSDK.AFInAppEventType);
                    outputStreamWriter.write(10);
                    outputStreamWriter.write("url=");
                    outputStreamWriter.write(aFb1kSDK.valueOf);
                    outputStreamWriter.write(10);
                    outputStreamWriter.write("data=");
                    outputStreamWriter.write(Base64.encodeToString(aFb1kSDK.AFInAppEventType(), 2));
                    outputStreamWriter.write(10);
                    AFe1bSDK aFe1bSDK = aFb1kSDK.AFKeystoreWrapper;
                    if (aFe1bSDK != null) {
                        outputStreamWriter.write("type=");
                        outputStreamWriter.write(aFe1bSDK.name());
                        outputStreamWriter.write(10);
                    }
                    outputStreamWriter.flush();
                    AFLogger.INSTANCE.m802i(AFg1hSDK.CACHE, "done, cacheKey: ".concat(String.valueOf(string)));
                    try {
                        outputStreamWriter.close();
                    } catch (IOException e) {
                        AFLogger.afErrorLogForExcManagerOnly("could not close cache writer", e);
                    }
                    return string;
                } catch (Exception e2) {
                    e = e2;
                    AFLogger.afErrorLog("CACHE: Could not cache request", e);
                    if (outputStreamWriter != null) {
                        try {
                            outputStreamWriter.close();
                        } catch (IOException e3) {
                            AFLogger.afErrorLogForExcManagerOnly("could not close cache writer", e3);
                        }
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                stringWriter = "AFRequestCache";
                if (stringWriter != 0) {
                    try {
                        stringWriter.close();
                    } catch (IOException e4) {
                        AFLogger.afErrorLogForExcManagerOnly("could not close cache writer", e4);
                    }
                }
                throw th;
            }
        } catch (Exception e5) {
            e = e5;
            outputStreamWriter = null;
        } catch (Throwable th2) {
            th = th2;
            if (stringWriter != 0) {
                stringWriter.close();
            }
            throw th;
        }
    }

    @Override
    public final List<AFb1kSDK> valueOf() {
        ArrayList arrayList = new ArrayList();
        try {
            File file = new File(this.AFKeystoreWrapper.AFInAppEventParameterName.getFilesDir(), "AFRequestCache");
            if (!file.exists()) {
                file.mkdir();
            }
            File[] fileArrListFiles = file.listFiles();
            if (fileArrListFiles == null) {
                return arrayList;
            }
            for (File file2 : fileArrListFiles) {
                AFLogger aFLogger = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK = AFg1hSDK.CACHE;
                StringBuilder sb = new StringBuilder("Found cached request");
                sb.append(file2.getName());
                aFLogger.m802i(aFg1hSDK, sb.toString());
                arrayList.add(valueOf(file2));
            }
        } catch (Exception e) {
            AFLogger.afErrorLog("CACHE: Could not get cached requests", e);
        }
        return arrayList;
    }

    private static AFb1kSDK valueOf(File file) throws Throwable {
        InputStreamReader inputStreamReader;
        InputStreamReader inputStreamReader2 = null;
        try {
            inputStreamReader = new InputStreamReader(new FileInputStream(file), Charset.defaultCharset());
            try {
                try {
                    char[] cArr = new char[(int) file.length()];
                    inputStreamReader.read(cArr);
                    AFb1kSDK aFb1kSDK = new AFb1kSDK(cArr);
                    aFb1kSDK.AFInAppEventParameterName = file.getName();
                    try {
                        inputStreamReader.close();
                    } catch (IOException e) {
                        AFLogger.afErrorLogForExcManagerOnly("could not close load reader", e);
                    }
                    return aFb1kSDK;
                } catch (Exception e2) {
                    e = e2;
                    AFLogger.afErrorLogForExcManagerOnly("error while loading request from cache", e);
                    if (inputStreamReader != null) {
                        try {
                            inputStreamReader.close();
                        } catch (IOException e3) {
                            AFLogger.afErrorLogForExcManagerOnly("could not close load reader", e3);
                        }
                    }
                    return null;
                }
            } catch (Throwable th) {
                th = th;
                inputStreamReader2 = inputStreamReader;
                if (inputStreamReader2 != null) {
                    try {
                        inputStreamReader2.close();
                    } catch (IOException e4) {
                        AFLogger.afErrorLogForExcManagerOnly("could not close load reader", e4);
                    }
                }
                throw th;
            }
        } catch (Exception e5) {
            e = e5;
            inputStreamReader = null;
        } catch (Throwable th2) {
            th = th2;
            if (inputStreamReader2 != null) {
                inputStreamReader2.close();
            }
            throw th;
        }
    }

    @Override
    public final boolean valueOf(String str) {
        File file = new File(new File(this.AFKeystoreWrapper.AFInAppEventParameterName.getFilesDir(), "AFRequestCache"), str);
        AFLogger aFLogger = AFLogger.INSTANCE;
        AFg1hSDK aFg1hSDK = AFg1hSDK.CACHE;
        StringBuilder sb = new StringBuilder("Deleting ");
        sb.append(str);
        sb.append(" from cache");
        aFLogger.m802i(aFg1hSDK, sb.toString());
        if (!file.exists()) {
            return true;
        }
        try {
            return file.delete();
        } catch (Exception e) {
            StringBuilder sb2 = new StringBuilder("CACHE: Could not delete ");
            sb2.append(str);
            sb2.append(" from cache");
            AFLogger.afErrorLog(sb2.toString(), e);
            return false;
        }
    }

    @Override
    public final void AFInAppEventParameterName() {
        try {
            File file = new File(this.AFKeystoreWrapper.AFInAppEventParameterName.getFilesDir(), "AFRequestCache");
            if (!file.exists()) {
                file.mkdir();
                return;
            }
            File[] fileArrListFiles = file.listFiles();
            if (fileArrListFiles == null) {
                return;
            }
            for (File file2 : fileArrListFiles) {
                AFLogger aFLogger = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK = AFg1hSDK.CACHE;
                StringBuilder sb = new StringBuilder("Found cached request");
                sb.append(file2.getName());
                aFLogger.m802i(aFg1hSDK, sb.toString());
                AFLogger aFLogger2 = AFLogger.INSTANCE;
                AFg1hSDK aFg1hSDK2 = AFg1hSDK.CACHE;
                StringBuilder sb2 = new StringBuilder("Deleting ");
                sb2.append(file2.getName());
                sb2.append(" from cache");
                aFLogger2.m802i(aFg1hSDK2, sb2.toString());
                file2.delete();
            }
        } catch (Exception e) {
            AFLogger.afErrorLog("CACHE: Could not cache request", e);
        }
    }
}
