package com.soundcloud.android.crop;

import android.app.AlertDialog;
import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Handler;
import android.text.TextUtils;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;
import com.ishumei.smantifraud.l111l11l11Ill;
import java.io.Closeable;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

class CropUtil {
    private static final String SCHEME_CONTENT = "content";
    private static final String SCHEME_FILE = "file";

    CropUtil() {
    }

    public static void closeSilently(Closeable closeable) {
        if (closeable == null) {
            return;
        }
        try {
            closeable.close();
        } catch (Throwable unused) {
        }
    }

    public static int getExifRotation(File file) {
        if (file == null) {
            return 0;
        }
        try {
            int attributeInt = new ExifInterface(file.getAbsolutePath()).getAttributeInt("Orientation", 0);
            if (attributeInt == 3) {
                return 180;
            }
            if (attributeInt != 6) {
                return attributeInt != 8 ? 0 : 270;
            }
            return 90;
        } catch (IOException e) {
            Log.m440e("Error getting Exif data", e);
            return 0;
        }
    }

    public static boolean copyExifRotation(File file, File file2) {
        if (file != null && file2 != null) {
            try {
                ExifInterface exifInterface = new ExifInterface(file.getAbsolutePath());
                ExifInterface exifInterface2 = new ExifInterface(file2.getAbsolutePath());
                exifInterface2.setAttribute("Orientation", exifInterface.getAttribute("Orientation"));
                exifInterface2.saveAttributes();
                return true;
            } catch (IOException e) {
                Log.m440e("Error copying Exif data", e);
            }
        }
        return false;
    }

    public static File getFromMediaUri(Context context, ContentResolver contentResolver, Uri uri) throws Throwable {
        Cursor cursorQuery;
        int columnIndex;
        Cursor cursor = null;
        if (uri == null) {
            return null;
        }
        if (SCHEME_FILE.equals(uri.getScheme())) {
            return new File(uri.getPath());
        }
        if ("content".equals(uri.getScheme())) {
            try {
                try {
                    cursorQuery = contentResolver.query(uri, new String[]{"_data", "_display_name"}, null, null, null);
                    if (cursorQuery != null) {
                        try {
                            if (cursorQuery.moveToFirst()) {
                                if (uri.toString().startsWith("content://com.google.android.gallery3d")) {
                                    columnIndex = cursorQuery.getColumnIndex("_display_name");
                                } else {
                                    columnIndex = cursorQuery.getColumnIndex("_data");
                                }
                                if (columnIndex != -1) {
                                    String string = cursorQuery.getString(columnIndex);
                                    if (!TextUtils.isEmpty(string)) {
                                        File file = new File(string);
                                        if (cursorQuery != null) {
                                            cursorQuery.close();
                                        }
                                        return file;
                                    }
                                }
                            }
                        } catch (IllegalArgumentException unused) {
                            cursor = cursorQuery;
                            File fromMediaUriPfd = getFromMediaUriPfd(context, contentResolver, uri);
                            if (cursor != null) {
                                cursor.close();
                            }
                            return fromMediaUriPfd;
                        } catch (SecurityException unused2) {
                            if (cursorQuery != null) {
                            }
                            return null;
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
                } catch (Throwable th2) {
                    th = th2;
                }
            } catch (IllegalArgumentException unused3) {
            } catch (SecurityException unused4) {
                cursorQuery = null;
            }
        }
        return null;
    }

    private static String getTempFilename(Context context) throws IOException {
        return File.createTempFile("image", "tmp", context.getCacheDir()).getAbsolutePath();
    }

    private static File getFromMediaUriPfd(Context context, ContentResolver contentResolver, Uri uri) throws Throwable {
        FileOutputStream fileOutputStream;
        FileInputStream fileInputStream;
        FileInputStream fileInputStream2 = null;
        if (uri == null) {
            return null;
        }
        try {
            fileInputStream = new FileInputStream(contentResolver.openFileDescriptor(uri, "r").getFileDescriptor());
            try {
                String tempFilename = getTempFilename(context);
                fileOutputStream = new FileOutputStream(tempFilename);
                try {
                    byte[] bArr = new byte[l111l11l11Ill.l111l11111lIl];
                    while (true) {
                        int i = fileInputStream.read(bArr);
                        if (i != -1) {
                            fileOutputStream.write(bArr, 0, i);
                        } else {
                            File file = new File(tempFilename);
                            closeSilently(fileInputStream);
                            closeSilently(fileOutputStream);
                            return file;
                        }
                    }
                } catch (IOException unused) {
                    closeSilently(fileInputStream);
                    closeSilently(fileOutputStream);
                    return null;
                } catch (Throwable th) {
                    th = th;
                    fileInputStream2 = fileInputStream;
                    closeSilently(fileInputStream2);
                    closeSilently(fileOutputStream);
                    throw th;
                }
            } catch (IOException unused2) {
                fileOutputStream = null;
            } catch (Throwable th2) {
                th = th2;
                fileOutputStream = null;
            }
        } catch (IOException unused3) {
            fileOutputStream = null;
            fileInputStream = null;
        } catch (Throwable th3) {
            th = th3;
            fileOutputStream = null;
        }
    }

    public static void startBackgroundJob(MonitoredActivity monitoredActivity, String str, String str2, Runnable runnable, Handler handler) {
        LinearLayout linearLayout = new LinearLayout(monitoredActivity);
        linearLayout.setOrientation(0);
        linearLayout.setPadding(40, 40, 40, 40);
        linearLayout.setGravity(17);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(-2, -2);
        layoutParams.gravity = 17;
        linearLayout.setLayoutParams(layoutParams);
        linearLayout.addView(new ProgressBar(monitoredActivity));
        if (!TextUtils.isEmpty(str2)) {
            TextView textView = new TextView(monitoredActivity);
            textView.setText(str2);
            textView.setPadding(20, 0, 0, 0);
            linearLayout.addView(textView);
        }
        AlertDialog.Builder builder = new AlertDialog.Builder(monitoredActivity);
        builder.setTitle(str);
        builder.setCancelable(false);
        builder.setView(linearLayout);
        AlertDialog alertDialogCreate = builder.create();
        alertDialogCreate.show();
        new Thread(new BackgroundJob(monitoredActivity, runnable, alertDialogCreate, handler)).start();
    }

    private static class BackgroundJob extends MonitoredActivity.LifeCycleAdapter implements Runnable {
        private final MonitoredActivity activity;
        private final Runnable cleanupRunner = new Runnable() {
            @Override
            public void run() {
                BackgroundJob.this.activity.removeLifeCycleListener(BackgroundJob.this);
                if (BackgroundJob.this.dialog.getWindow() != null) {
                    BackgroundJob.this.dialog.dismiss();
                }
            }
        };
        private final AlertDialog dialog;
        private final Handler handler;
        private final Runnable job;

        public BackgroundJob(MonitoredActivity monitoredActivity, Runnable runnable, AlertDialog alertDialog, Handler handler) {
            this.activity = monitoredActivity;
            this.dialog = alertDialog;
            this.job = runnable;
            monitoredActivity.addLifeCycleListener(this);
            this.handler = handler;
        }

        @Override
        public void run() {
            try {
                this.job.run();
            } finally {
                this.handler.post(this.cleanupRunner);
            }
        }

        @Override
        public void onActivityDestroyed(MonitoredActivity monitoredActivity) {
            this.cleanupRunner.run();
            this.handler.removeCallbacks(this.cleanupRunner);
        }

        @Override
        public void onActivityStopped(MonitoredActivity monitoredActivity) {
            this.dialog.hide();
        }

        @Override
        public void onActivityStarted(MonitoredActivity monitoredActivity) {
            this.dialog.show();
        }
    }
}
