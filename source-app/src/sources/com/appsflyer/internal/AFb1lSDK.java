package com.appsflyer.internal;

import com.appsflyer.AFLogger;
import com.appsflyer.AppsFlyerProperties;
import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.charset.Charset;
import java.security.SecureRandom;

public final class AFb1lSDK {
    private static String AFInAppEventParameterName;

    private static String valueOf(File file) throws Throwable {
        byte[] bArr;
        RandomAccessFile randomAccessFile = null;
        byte[] bArr2 = null;
        randomAccessFile = null;
        try {
            try {
                RandomAccessFile randomAccessFile2 = new RandomAccessFile(file, "r");
                try {
                    bArr2 = new byte[(int) randomAccessFile2.length()];
                    randomAccessFile2.readFully(bArr2);
                    randomAccessFile2.close();
                    try {
                        randomAccessFile2.close();
                    } catch (IOException e) {
                        AFLogger.afErrorLog("Exception while trying to close the InstallationFile", e);
                    }
                } catch (IOException e2) {
                    e = e2;
                    bArr = bArr2;
                    randomAccessFile = randomAccessFile2;
                    AFLogger.afErrorLog("Exception while reading InstallationFile: ", e);
                    if (randomAccessFile != null) {
                        try {
                            randomAccessFile.close();
                        } catch (IOException e3) {
                            AFLogger.afErrorLog("Exception while trying to close the InstallationFile", e3);
                        }
                    }
                    bArr2 = bArr;
                } catch (Throwable th) {
                    th = th;
                    randomAccessFile = randomAccessFile2;
                    if (randomAccessFile != null) {
                        try {
                            randomAccessFile.close();
                        } catch (IOException e4) {
                            AFLogger.afErrorLog("Exception while trying to close the InstallationFile", e4);
                        }
                    }
                    throw th;
                }
            } catch (IOException e5) {
                e = e5;
                bArr = null;
            }
            if (bArr2 == null) {
                bArr2 = new byte[0];
            }
            return new String(bArr2, Charset.defaultCharset());
        } catch (Throwable th2) {
            th = th2;
        }
    }

    public static synchronized String values(AFd1lSDK aFd1lSDK, AFd1xSDK aFd1xSDK) {
        if (aFd1lSDK.AFInAppEventParameterName == null) {
            return AFInAppEventParameterName;
        }
        if (AFInAppEventParameterName == null) {
            String strValueOf = aFd1xSDK.valueOf("AF_INSTALLATION", (String) null);
            if (strValueOf != null) {
                AFInAppEventParameterName = strValueOf;
            } else {
                try {
                    File file = new File(aFd1lSDK.AFInAppEventParameterName.getFilesDir(), "AF_INSTALLATION");
                    if (file.exists()) {
                        AFInAppEventParameterName = valueOf(file);
                        file.delete();
                    } else {
                        long jCurrentTimeMillis = System.currentTimeMillis();
                        StringBuilder sb = new StringBuilder();
                        sb.append(jCurrentTimeMillis);
                        sb.append("-");
                        sb.append(Math.abs(new SecureRandom().nextLong()));
                        AFInAppEventParameterName = sb.toString();
                    }
                    aFd1xSDK.values("AF_INSTALLATION", AFInAppEventParameterName);
                } catch (Exception e) {
                    AFLogger.afErrorLog("Error getting AF unique ID", e);
                }
            }
            if (AFInAppEventParameterName != null) {
                AppsFlyerProperties.getInstance().set("uid", AFInAppEventParameterName);
            }
        }
        return AFInAppEventParameterName;
    }
}
