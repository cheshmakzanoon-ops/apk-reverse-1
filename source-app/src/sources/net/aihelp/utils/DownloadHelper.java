package net.aihelp.utils;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.webkit.MimeTypeMap;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.OutputStream;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.net.http.AIHelpRequest;
import net.aihelp.core.net.http.callback.ReqCallback;

public class DownloadHelper {

    public interface OnDownloadProgressChangedListener {
        void onProgressChanged(int i);
    }

    public static void save(final Context context, String str, final OnDownloadProgressChangedListener onDownloadProgressChangedListener) {
        final String splitFileName = getSplitFileName(str);
        final String targetSavePath = getTargetSavePath(str, splitFileName);
        AIHelpRequest.getInstance().requestDownloadFile(str, targetSavePath, new ReqCallback<String>() {
            @Override
            public void onReqProgress(long j, long j2, int i) {
                OnDownloadProgressChangedListener onDownloadProgressChangedListener2 = onDownloadProgressChangedListener;
                if (onDownloadProgressChangedListener2 != null) {
                    onDownloadProgressChangedListener2.onProgressChanged(i);
                }
            }

            @Override
            public void onReqSuccess(String str2) {
                try {
                    if (RegexDefinition.isVideoFile(targetSavePath)) {
                        DownloadHelper.insertVideo(context, targetSavePath);
                    } else if (RegexDefinition.isGifFile(targetSavePath)) {
                        DownloadHelper.insertGif(context, targetSavePath);
                    } else {
                        DownloadHelper.insertImage(context, targetSavePath, splitFileName);
                    }
                    if (RegexDefinition.isVideoFile(targetSavePath)) {
                        return;
                    }
                    ToastUtil.INSTANCE.makeTextWithIcon(context, ResResolver.getString("aihelp_save_seccessfully"), false);
                } catch (Exception unused) {
                    ToastUtil.INSTANCE.makeRawToast(context, String.format("%s: %s", ResResolver.getString("aihelp_save_seccessfully"), targetSavePath));
                }
            }
        });
    }

    public static void insertVideo(Context context, String str) {
        Uri contentUri;
        ContentResolver contentResolver = context.getContentResolver();
        if (Build.VERSION.SDK_INT >= 29) {
            contentUri = MediaStore.Video.Media.getContentUri("external_primary");
        } else {
            contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
        }
        ContentValues contentValues = new ContentValues();
        contentValues.put("_display_name", getSplitFileName(str));
        contentValues.put("mime_type", getMIMEType(str));
        contentValues.put("date_added", Long.valueOf(System.currentTimeMillis()));
        contentValues.put("datetaken", Long.valueOf(System.currentTimeMillis()));
        Uri uriInsert = contentResolver.insert(contentUri, contentValues);
        try {
            FileInputStream fileInputStream = new FileInputStream(str);
            try {
                OutputStream outputStreamOpenOutputStream = contentResolver.openOutputStream(uriInsert);
                try {
                    byte[] bArr = new byte[8192];
                    while (true) {
                        int i = fileInputStream.read(bArr);
                        if (i <= 0) {
                            break;
                        } else {
                            outputStreamOpenOutputStream.write(bArr, 0, i);
                        }
                        try {
                            fileInputStream.close();
                        } catch (Throwable th) {
                            th.addSuppressed(th);
                        }
                        throw th;
                    }
                    if (outputStreamOpenOutputStream != null) {
                        outputStreamOpenOutputStream.close();
                    }
                    fileInputStream.close();
                } catch (Throwable th2) {
                    if (outputStreamOpenOutputStream != null) {
                        try {
                            outputStreamOpenOutputStream.close();
                        } catch (Throwable th3) {
                            th2.addSuppressed(th3);
                        }
                    }
                    throw th2;
                }
            } catch (Throwable th4) {
                fileInputStream.close();
                throw th4;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void insertGif(Context context, String str) {
        Uri contentUri;
        ContentResolver contentResolver = context.getContentResolver();
        if (Build.VERSION.SDK_INT >= 29) {
            contentUri = MediaStore.Images.Media.getContentUri("external_primary");
        } else {
            contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        }
        ContentValues contentValues = new ContentValues();
        contentValues.put("_display_name", getSplitFileName(str));
        contentValues.put("mime_type", "image/gif");
        contentValues.put("date_added", Long.valueOf(System.currentTimeMillis()));
        contentValues.put("datetaken", Long.valueOf(System.currentTimeMillis()));
        Uri uriInsert = contentResolver.insert(contentUri, contentValues);
        try {
            FileInputStream fileInputStream = new FileInputStream(str);
            try {
                OutputStream outputStreamOpenOutputStream = contentResolver.openOutputStream(uriInsert);
                try {
                    byte[] bArr = new byte[8192];
                    while (true) {
                        int i = fileInputStream.read(bArr);
                        if (i <= 0) {
                            break;
                        } else {
                            outputStreamOpenOutputStream.write(bArr, 0, i);
                        }
                        try {
                            fileInputStream.close();
                        } catch (Throwable th) {
                            th.addSuppressed(th);
                        }
                        throw th;
                    }
                    if (outputStreamOpenOutputStream != null) {
                        outputStreamOpenOutputStream.close();
                    }
                    fileInputStream.close();
                } catch (Throwable th2) {
                    if (outputStreamOpenOutputStream != null) {
                        try {
                            outputStreamOpenOutputStream.close();
                        } catch (Throwable th3) {
                            th2.addSuppressed(th3);
                        }
                    }
                    throw th2;
                }
            } catch (Throwable th4) {
                fileInputStream.close();
                throw th4;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void insertImage(Context context, String str, String str2) throws FileNotFoundException {
        File file = new File(str);
        MediaStore.Images.Media.insertImage(context.getContentResolver(), str, str2, (String) null);
        Intent intent = new Intent("android.intent.action.MEDIA_SCANNER_SCAN_FILE", Uri.fromFile(file));
        intent.addFlags(2);
        context.sendBroadcast(intent);
    }

    private static String getMIMEType(String str) {
        try {
            String strSubstring = "mp4";
            int iLastIndexOf = str.lastIndexOf(46);
            if (iLastIndexOf > 0) {
                strSubstring = str.substring(iLastIndexOf + 1);
            }
            return MimeTypeMap.getSingleton().getMimeTypeFromExtension(strSubstring);
        } catch (Exception unused) {
            return "video/mp4";
        }
    }

    private static String getSplitFileName(String str) {
        if (!TextUtils.isEmpty(str)) {
            String[] strArrSplit = str.split("/");
            if (strArrSplit.length > 0) {
                return "AIHelp-" + strArrSplit[strArrSplit.length - 1];
            }
            return "UnknownFile";
        }
        return "UnknownFile";
    }

    public static String getTargetSavePath(String str, String str2) {
        String str3;
        File externalFilesDir = AIHelpContext.getInstance().getContext().getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS);
        if (externalFilesDir == null) {
            str3 = "";
        } else {
            str3 = externalFilesDir.getAbsolutePath() + "/AIHelp";
            File file = new File(str3);
            if (!file.exists() && file.mkdirs()) {
                return file.getAbsolutePath() + File.separator + str2;
            }
        }
        return str3 + File.separator + str2;
    }
}
