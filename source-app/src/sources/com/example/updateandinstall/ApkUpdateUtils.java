package com.example.updateandinstall;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import androidx.core.content.FileProvider;
import com.sdkmanager.utils.Udid$;
import java.io.File;

public class ApkUpdateUtils {
    private static final String KEY_APK_VERSION = "curapkversion";
    private static final String KEY_DOWNLOAD_ID = "downloadId";
    public static final String TAG = "ApkUpdateUtils";

    public static void download(Context context, String str, String str2) {
        long j = SpUtils.getInstance(context).getLong(KEY_DOWNLOAD_ID, -1L);
        if (j != -1) {
            FileDownloadManager fileDownloadManager = FileDownloadManager.getInstance(context);
            int downloadStatus = fileDownloadManager.getDownloadStatus(j);
            if (downloadStatus != 8) {
                if (downloadStatus == 16 || downloadStatus == -1) {
                    start(context, str, str2);
                    return;
                } else {
                    Log.d(TAG, "apk is already downloading");
                    return;
                }
            }
            String downloadPath = fileDownloadManager.getDownloadPath(j);
            if (downloadPath != null) {
                if (compare(getApkInfo(context, downloadPath), context)) {
                    startInstall(context, downloadPath);
                    return;
                } else {
                    fileDownloadManager.getDm().remove(j);
                    start(context, str, str2);
                    return;
                }
            }
            start(context, str, str2);
            return;
        }
        start(context, str, str2);
    }

    private static void start(Context context, String str, String str2) {
        long jStartDownload = FileDownloadManager.getInstance(context).startDownload(str, str2, "Open when the download completes.");
        SpUtils.getInstance(context).putLong(KEY_DOWNLOAD_ID, jStartDownload);
        Log.d(TAG, "apk start download " + jStartDownload);
    }

    public static void startInstall(Context context, String str) {
        File file = !TextUtils.isEmpty(str) ? new File(Uri.parse(str).getPath()) : null;
        if (file == null) {
            return;
        }
        try {
            Intent intent = new Intent("android.intent.action.VIEW");
            intent.setFlags(268435456);
            if (Build.VERSION.SDK_INT >= 24) {
                intent.setFlags(1);
                intent.setDataAndType(FileProvider.getUriForFile(context, context.getPackageName() + ".provider", file), "application/vnd.android.package-archive");
                if (Build.VERSION.SDK_INT >= 26 && !Udid$.ExternalSyntheticApiModelOutline0.m(context.getPackageManager())) {
                    showDownloadDialog(context);
                    return;
                }
            } else {
                intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive");
            }
            if (context.getPackageManager().queryIntentActivities(intent, 0).size() > 0) {
                ((Activity) context).startActivityForResult(intent, 2);
            }
        } catch (Throwable th) {
            th.printStackTrace();
        }
    }

    private static void showDownloadDialog(final Context context) {
        ((Activity) context).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                AlertDialog.Builder builder = new AlertDialog.Builder(context);
                builder.setTitle("Download Complete");
                builder.setMessage("The installation package is downloaded. Please click Allow Install Unknown Source to continue installation");
                builder.setPositiveButton("Confirm", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        ((Activity) context).startActivityForResult(new Intent("android.settings.MANAGE_UNKNOWN_APP_SOURCES", Uri.parse("package:" + context.getPackageName())), 10086);
                    }
                });
                builder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialogInterface, int i) {
                        dialogInterface.dismiss();
                    }
                });
                builder.create().show();
            }
        });
    }

    public static PackageInfo getApkInfo(Context context, String str) {
        PackageInfo packageArchiveInfo = context.getPackageManager().getPackageArchiveInfo(str, 1);
        if (packageArchiveInfo != null) {
            return packageArchiveInfo;
        }
        return null;
    }

    public static boolean compare(PackageInfo packageInfo, Context context) {
        if (packageInfo == null) {
            return false;
        }
        String packageName = context.getPackageName();
        if (packageInfo.packageName.equals(packageName)) {
            try {
                if (packageInfo.versionCode > context.getPackageManager().getPackageInfo(packageName, 0).versionCode) {
                    return true;
                }
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public static void safeInstall(final long j, final Context context) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                final String downloadPath;
                if (j != -1) {
                    FileDownloadManager fileDownloadManager = FileDownloadManager.getInstance(context);
                    if (fileDownloadManager.getDownloadStatus(j) == 8 && (downloadPath = fileDownloadManager.getDownloadPath(j)) != null && ApkUpdateUtils.compare(ApkUpdateUtils.getApkInfo(context, downloadPath), context)) {
                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                ApkUpdateUtils.startInstall(context, downloadPath);
                            }
                        });
                    }
                }
            }
        }).start();
    }
}
