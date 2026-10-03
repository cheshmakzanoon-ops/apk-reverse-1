package com.head;

import android.content.ContentResolver;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.util.Log;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.sessions.settings.RemoteSettings;
import com.sdkmanager.SdkManager;
import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class CommonUtil {
    public static boolean isEmpty(String str) {
        return str == null || str.equals("");
    }

    public static boolean isSDcardAvaiable() {
        try {
            return "mounted".equals(Environment.getExternalStorageState());
        } catch (Exception unused) {
            return false;
        }
    }

    public static String getSDCardPath(Context context, String str) {
        try {
            File externalFilesDir = context.getExternalFilesDir(null);
            if (externalFilesDir != null) {
                return externalFilesDir.getAbsolutePath() + str;
            }
        } catch (Exception unused) {
        }
        return context.getFilesDir().getAbsolutePath() + str;
    }

    public static String getSDCardPath() {
        return getSDCardPath(SdkManager.getInstance().GetContext().getApplicationContext(), "");
    }

    public static String getDataColumn(Context context, Uri uri, String str, String[] strArr) {
        Cursor cursorQuery = null;
        try {
            cursorQuery = context.getContentResolver().query(uri, new String[]{"_data"}, str, strArr, null);
            int columnIndexOrThrow = cursorQuery.getColumnIndexOrThrow("_data");
            cursorQuery.moveToFirst();
            return cursorQuery.getString(columnIndexOrThrow);
        } finally {
            if (cursorQuery != null) {
                cursorQuery.close();
            }
        }
    }

    public static String getPath(Context context, Uri uri) {
        Uri uri2;
        try {
            if (DocumentsContract.isDocumentUri(context, uri)) {
                if (isExternalStorageDocument(uri)) {
                    String[] strArrSplit = DocumentsContract.getDocumentId(uri).split(":");
                    if ("primary".equalsIgnoreCase(strArrSplit[0])) {
                        return "file:///" + getSDCardPath() + RemoteSettings.FORWARD_SLASH_STRING + strArrSplit[1];
                    }
                } else {
                    if (isDownloadsDocument(uri)) {
                        return "file:///" + getDataColumn(context, ContentUris.withAppendedId(Uri.parse("content://downloads/public_downloads"), Long.valueOf(DocumentsContract.getDocumentId(uri)).longValue()), null, null);
                    }
                    if (isMediaDocument(uri)) {
                        String[] strArrSplit2 = DocumentsContract.getDocumentId(uri).split(":");
                        String str = strArrSplit2[0];
                        if ("image".equals(str)) {
                            uri2 = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                        } else if ("video".equals(str)) {
                            uri2 = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                        } else {
                            uri2 = "audio".equals(str) ? MediaStore.Audio.Media.EXTERNAL_CONTENT_URI : null;
                        }
                        return "file:///" + getDataColumn(context, uri2, "_id=?", new String[]{strArrSplit2[1]});
                    }
                }
            } else {
                if (FirebaseAnalytics.Param.CONTENT.equalsIgnoreCase(uri.getScheme())) {
                    String lastPathSegment = "";
                    if (Build.VERSION.SDK_INT >= 29) {
                        ContentResolver contentResolver = context.getContentResolver();
                        Cursor cursorQuery = contentResolver.query(uri, null, null, null, null);
                        if (cursorQuery != null && cursorQuery.moveToFirst()) {
                            String string = cursorQuery.getString(cursorQuery.getColumnIndex("_display_name"));
                            try {
                                InputStream inputStreamOpenInputStream = contentResolver.openInputStream(uri);
                                File file = new File(context.getExternalCacheDir().getAbsolutePath(), string);
                                FileOutputStream fileOutputStream = new FileOutputStream(file);
                                byte[] bArr = new byte[1024];
                                while (true) {
                                    int i = inputStreamOpenInputStream.read(bArr);
                                    if (i == -1) {
                                        break;
                                    }
                                    fileOutputStream.write(bArr, 0, i);
                                }
                                inputStreamOpenInputStream.close();
                                fileOutputStream.flush();
                                fileOutputStream.close();
                                lastPathSegment = file.getAbsolutePath();
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                        }
                    } else {
                        lastPathSegment = isGooglePhotosUri(uri) ? uri.getLastPathSegment() : getDataColumn(context, uri, null, null);
                    }
                    Log.d("ABTEST", lastPathSegment);
                    return lastPathSegment;
                }
                if ("file".equalsIgnoreCase(uri.getScheme())) {
                    return "file:///" + uri.getPath();
                }
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        }
        return null;
    }

    public static String getFileAbsolutePath(Context context, Uri uri) throws Throwable {
        Uri uri2 = null;
        if (context != null && uri != null) {
            if (Build.VERSION.SDK_INT < 29 && DocumentsContract.isDocumentUri(context, uri)) {
                if (isExternalStorageDocument(uri)) {
                    String[] strArrSplit = DocumentsContract.getDocumentId(uri).split(":");
                    if ("primary".equalsIgnoreCase(strArrSplit[0])) {
                        return Environment.getExternalStorageDirectory() + RemoteSettings.FORWARD_SLASH_STRING + strArrSplit[1];
                    }
                } else {
                    if (isDownloadsDocument(uri)) {
                        String dataColumnNew = getDataColumnNew(context, ContentUris.withAppendedId(Uri.parse("content://downloads/public_downloads"), Long.valueOf(DocumentsContract.getDocumentId(uri)).longValue()), null, null);
                        if (isEmpty(dataColumnNew)) {
                            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::getFileAbsolutePath(), isDownloadsDocument 的判断中 finalPath 为空");
                        }
                        return dataColumnNew;
                    }
                    if (isMediaDocument(uri)) {
                        String[] strArrSplit2 = DocumentsContract.getDocumentId(uri).split(":");
                        String str = strArrSplit2[0];
                        if ("image".equals(str)) {
                            uri2 = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                        } else if ("video".equals(str)) {
                            uri2 = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                        } else if ("audio".equals(str)) {
                            uri2 = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                        }
                        String dataColumnNew2 = getDataColumnNew(context, uri2, "_id=?", new String[]{strArrSplit2[1]});
                        if (isEmpty(dataColumnNew2)) {
                            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::getFileAbsolutePath(), isMediaDocument 的判断中 finalPath 为空");
                        }
                        return dataColumnNew2;
                    }
                }
            }
            if (Build.VERSION.SDK_INT >= 29) {
                return uriToFileApiQ(context, uri);
            }
            if (FirebaseAnalytics.Param.CONTENT.equalsIgnoreCase(uri.getScheme())) {
                if (isGooglePhotosUri(uri)) {
                    return uri.getLastPathSegment();
                }
                String dataColumnNew3 = getDataColumnNew(context, uri, null, null);
                if (isEmpty(dataColumnNew3)) {
                    SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::getFileAbsolutePath(), content开头的uri 的判断中 finalPath 为空");
                }
                return dataColumnNew3;
            }
            if ("file".equalsIgnoreCase(uri.getScheme())) {
                return uri.getPath();
            }
        }
        return null;
    }

    private static String getDataColumnNew(Context context, Uri uri, String str, String[] strArr) throws Throwable {
        Cursor cursor = null;
        try {
            Cursor cursorQuery = context.getContentResolver().query(uri, new String[]{"_data"}, str, strArr, null);
            if (cursorQuery != null) {
                try {
                    if (cursorQuery.moveToFirst()) {
                        String string = cursorQuery.getString(cursorQuery.getColumnIndexOrThrow("_data"));
                        if (cursorQuery != null) {
                            cursorQuery.close();
                        }
                        return string;
                    }
                } catch (Throwable th) {
                    th = th;
                    cursor = cursorQuery;
                    if (cursor != null) {
                        cursor.close();
                    }
                    throw th;
                }
            }
            if (cursorQuery != null) {
                cursorQuery.close();
            }
            return null;
        } catch (Throwable th2) {
            th = th2;
        }
    }

    private static String getRealFilePath(Context context, Uri uri) {
        int columnIndex;
        String string = null;
        if (uri == null) {
            return null;
        }
        String scheme = uri.getScheme();
        if (scheme == null) {
            return uri.getPath();
        }
        if ("file".equals(scheme)) {
            return uri.getPath();
        }
        if (!FirebaseAnalytics.Param.CONTENT.equals(scheme)) {
            return null;
        }
        Cursor cursorQuery = context.getContentResolver().query(uri, new String[]{"_data"}, null, null, null);
        if (cursorQuery == null) {
            return null;
        }
        if (cursorQuery.moveToFirst() && (columnIndex = cursorQuery.getColumnIndex("_data")) > -1) {
            string = cursorQuery.getString(columnIndex);
        }
        cursorQuery.close();
        return string;
    }

    private static String uriToFileApiQ(Context context, Uri uri) {
        File file;
        String string;
        if (uri.getScheme().equals("file")) {
            file = new File(uri.getPath());
        } else {
            File file2 = null;
            if (uri.getScheme().equals(FirebaseAnalytics.Param.CONTENT)) {
                ContentResolver contentResolver = context.getContentResolver();
                Cursor cursorQuery = contentResolver.query(uri, null, null, null, null);
                if (cursorQuery.moveToFirst()) {
                    int columnIndex = cursorQuery.getColumnIndex("_display_name");
                    if (columnIndex <= -1) {
                        string = "";
                    } else {
                        string = cursorQuery.getString(columnIndex);
                    }
                    try {
                        InputStream inputStreamOpenInputStream = contentResolver.openInputStream(uri);
                        File file3 = new File(context.getExternalCacheDir().getAbsolutePath(), Math.round((Math.random() + 1.0d) * 1000.0d) + string);
                        FileOutputStream fileOutputStream = new FileOutputStream(file3);
                        copyStream(inputStreamOpenInputStream, fileOutputStream);
                        try {
                            fileOutputStream.close();
                            inputStreamOpenInputStream.close();
                            file = file3;
                        } catch (IOException e) {
                            e = e;
                            file2 = file3;
                            e.printStackTrace();
                            file = file2;
                        } catch (Exception e2) {
                            e = e2;
                            file2 = file3;
                            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::uriToFileApiQ()，android10以上将文件内容拷贝到沙盒路径报错：" + e.getMessage());
                            file = file2;
                        }
                    } catch (IOException e3) {
                        e = e3;
                    } catch (Exception e4) {
                        e = e4;
                    }
                } else {
                    file = file2;
                }
            } else {
                file = file2;
            }
        }
        return file.getAbsolutePath();
    }

    private static boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    private static boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    private static boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    private static boolean isGooglePhotosUri(Uri uri) {
        return "com.google.android.apps.photos.content".equals(uri.getAuthority());
    }

    public static int copyStream(InputStream inputStream, OutputStream outputStream) throws Exception {
        byte[] bArr = new byte[2048];
        BufferedInputStream bufferedInputStream = new BufferedInputStream(inputStream, 2048);
        BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(outputStream, 2048);
        int i = 0;
        while (true) {
            try {
                int i2 = bufferedInputStream.read(bArr, 0, 2048);
                if (i2 == -1) {
                    break;
                }
                bufferedOutputStream.write(bArr, 0, i2);
                i += i2;
            } catch (Throwable th) {
                try {
                    bufferedOutputStream.close();
                } catch (IOException unused) {
                }
                try {
                    bufferedInputStream.close();
                    throw th;
                } catch (IOException unused2) {
                    throw th;
                }
            }
        }
        bufferedOutputStream.flush();
        try {
            bufferedOutputStream.close();
        } catch (IOException unused3) {
        }
        try {
            bufferedInputStream.close();
        } catch (IOException unused4) {
        }
        return i;
    }
}
