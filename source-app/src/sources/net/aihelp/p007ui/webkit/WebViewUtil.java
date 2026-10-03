package net.aihelp.p007ui.webkit;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Build;
import android.os.Process;
import android.text.TextUtils;
import androidx.tracing.Trace$;
import cn.thinkingdata.android.j$;
import java.io.File;
import java.io.RandomAccessFile;
import java.nio.channels.FileLock;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import net.aihelp.utils.RomUtil;

public class WebViewUtil {
    public static void prepareDataDirectorySuffix(Context context) {
        if (Build.VERSION.SDK_INT < 28) {
            return;
        }
        try {
            HashSet hashSet = new HashSet();
            String absolutePath = Trace$.ExternalSyntheticApiModelOutline0.m(context).getAbsolutePath();
            String curProcessName = getCurProcessName(context);
            if (TextUtils.equals(context.getPackageName(), curProcessName)) {
                String str = "_" + curProcessName;
                hashSet.add(absolutePath + "/app_webview/webview_data.lock");
                hashSet.add(absolutePath + "/app_webview" + str + "/webview_data.lock");
                if (RomUtil.isEmui()) {
                    hashSet.add(absolutePath + "/app_hws_webview/webview_data.lock");
                    hashSet.add(absolutePath + "/app_hws_webview" + str + "/webview_data.lock");
                }
            } else {
                if (TextUtils.isEmpty(curProcessName)) {
                    curProcessName = context.getPackageName();
                }
                j$.ExternalSyntheticApiModelOutline0.m(curProcessName);
                String str2 = "_" + curProcessName;
                hashSet.add(absolutePath + "/app_webview" + str2 + "/webview_data.lock");
                if (RomUtil.isEmui()) {
                    hashSet.add(absolutePath + "/app_hws_webview" + str2 + "/webview_data.lock");
                }
            }
            Iterator it = hashSet.iterator();
            while (it.hasNext()) {
                File file = new File((String) it.next());
                if (file.exists()) {
                    tryLockOrRecreateFile(file);
                    return;
                }
            }
        } catch (Exception unused) {
        }
    }

    private static void tryLockOrRecreateFile(File file) {
        try {
            FileLock fileLockTryLock = new RandomAccessFile(file, "rw").getChannel().tryLock();
            if (fileLockTryLock != null) {
                fileLockTryLock.close();
            } else {
                createFile(file, file.delete());
            }
        } catch (Exception unused) {
            createFile(file, file.exists() ? file.delete() : false);
        }
    }

    private static void createFile(File file, boolean z) {
        if (z) {
            try {
                if (file.exists()) {
                    return;
                }
                file.createNewFile();
            } catch (Exception unused) {
            }
        }
    }

    public static String getCurProcessName(Context context) {
        int iMyPid = Process.myPid();
        List<ActivityManager.RunningAppProcessInfo> runningAppProcesses = ((ActivityManager) context.getSystemService("activity")).getRunningAppProcesses();
        if (runningAppProcesses == null) {
            return null;
        }
        for (ActivityManager.RunningAppProcessInfo runningAppProcessInfo : runningAppProcesses) {
            if (runningAppProcessInfo != null && runningAppProcessInfo.pid == iMyPid) {
                return runningAppProcessInfo.processName;
            }
        }
        return null;
    }
}
