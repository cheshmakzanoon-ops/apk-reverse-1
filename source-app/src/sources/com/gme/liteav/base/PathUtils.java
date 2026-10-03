package com.gme.liteav.base;

import android.content.Context;
import android.system.Os;
import java.io.File;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.FutureTask;
import java.util.concurrent.atomic.AtomicBoolean;

public abstract class PathUtils {
    static final boolean $assertionsDisabled = false;
    private static final int APP_FILES_DIRECTORY = 5;
    private static final int CACHE_DIRECTORY = 2;
    private static final int DATA_DIRECTORY = 0;
    private static final int EXTERNAL_FILES_DIRECTORY = 4;
    private static final int LOG_DIRECTORY = 3;
    private static final int NUM_DIRECTORIES = 6;
    private static final String TAG = "PathUtils";
    private static final int THUMBNAIL_DIRECTORY = 1;
    private static final String THUMBNAIL_DIRECTORY_NAME = "textures";
    private static String sCacheSubDirectory;
    private static String sDataDirectorySuffix;
    private static FutureTask<String[]> sDirPathFetchTask;
    private static final AtomicBoolean sInitializationStarted = new AtomicBoolean();

    private PathUtils() {
    }

    static class C1001a {

        private static final String[] f602a = PathUtils.getOrComputeDirectoryPaths();
    }

    public static String[] getOrComputeDirectoryPaths() {
        try {
            if (sDirPathFetchTask.cancel(false)) {
                C1004b c1004bM955a = C1004b.m955a();
                try {
                    String[] privateDataDirectorySuffixInternal = setPrivateDataDirectorySuffixInternal();
                    c1004bM955a.close();
                    return privateDataDirectorySuffixInternal;
                } catch (Throwable th) {
                    try {
                        throw th;
                    } catch (Throwable th2) {
                        try {
                            c1004bM955a.close();
                        } catch (Throwable unused) {
                        }
                        throw th2;
                    }
                }
            }
            return sDirPathFetchTask.get();
        } catch (InterruptedException | ExecutionException unused2) {
            return null;
        }
    }

    private static void chmod(String str, int i) {
        try {
            Os.chmod(str, i);
        } catch (Exception unused) {
            Log.m948e(TAG, "Failed to set permissions for path \"" + str + "\"", new Object[0]);
        }
    }

    public static String[] setPrivateDataDirectorySuffixInternal() {
        String[] strArr = new String[6];
        Context applicationContext = ContextUtils.getApplicationContext();
        String path = applicationContext.getDir(sDataDirectorySuffix, 0).getPath();
        strArr[0] = path;
        chmod(path, 448);
        strArr[1] = applicationContext.getDir(THUMBNAIL_DIRECTORY_NAME, 0).getPath();
        if (applicationContext.getCacheDir() != null) {
            if (sCacheSubDirectory == null) {
                strArr[2] = applicationContext.getCacheDir().getPath();
            } else {
                strArr[2] = new File(applicationContext.getCacheDir(), sCacheSubDirectory).getPath();
            }
        }
        strArr[5] = applicationContext.getFilesDir().getAbsolutePath();
        File externalFilesDir = applicationContext.getExternalFilesDir(null);
        if (externalFilesDir != null) {
            strArr[3] = externalFilesDir.getAbsolutePath() + "/log/liteav";
            strArr[4] = externalFilesDir.getAbsolutePath();
        }
        return strArr;
    }

    public static synchronized void setPrivateDataDirectorySuffix(String str, String str2) {
        if (!sInitializationStarted.getAndSet(true)) {
            sDataDirectorySuffix = str;
            sCacheSubDirectory = str2;
            sDirPathFetchTask = new FutureTask<>(CallableC1002a.m953a());
        }
    }

    public static void setPrivateDataDirectorySuffix(String str) {
        setPrivateDataDirectorySuffix(str, null);
    }

    private static String getDirectoryPath(int i) {
        try {
            return C1001a.f602a[i];
        } catch (Throwable th) {
            Log.m948e(TAG, "Failed to get directory path:".concat(String.valueOf(i)), th);
            return null;
        }
    }

    public static String getDataDirectory() {
        return getDirectoryPath(0);
    }

    public static String getCacheDirectory() {
        return getDirectoryPath(2);
    }

    public static String getThumbnailCacheDirectory() {
        return getDirectoryPath(1);
    }

    public static String getLogDirectory() {
        return getDirectoryPath(3);
    }

    public static String getExternalFilesDirectory() {
        return getDirectoryPath(4);
    }

    public static String getAppFilesDirectory() {
        return getDirectoryPath(5);
    }
}
