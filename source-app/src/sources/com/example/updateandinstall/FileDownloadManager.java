package com.example.updateandinstall;

import android.app.DownloadManager;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Environment;

public class FileDownloadManager {
    private static FileDownloadManager instance;
    private Context context;

    private DownloadManager f507dm;

    private FileDownloadManager(Context context) {
        this.f507dm = (DownloadManager) context.getSystemService("download");
        this.context = context.getApplicationContext();
    }

    public static FileDownloadManager getInstance(Context context) {
        if (instance == null) {
            instance = new FileDownloadManager(context);
        }
        return instance;
    }

    public long startDownload(String str, String str2, String str3) {
        DownloadManager.Request request = new DownloadManager.Request(Uri.parse(str));
        request.setAllowedNetworkTypes(3);
        request.setNotificationVisibility(1);
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, "City On Mars.apk");
        request.setTitle(str2);
        request.setDescription(str3);
        return this.f507dm.enqueue(request);
    }

    public String getDownloadPath(long j) {
        Cursor cursorQuery = this.f507dm.query(new DownloadManager.Query().setFilterById(j));
        if (cursorQuery == null) {
            return null;
        }
        try {
            if (cursorQuery.moveToFirst()) {
                return Uri.parse(cursorQuery.getString(cursorQuery.getColumnIndexOrThrow("local_uri"))).getPath();
            }
            return null;
        } finally {
            cursorQuery.close();
        }
    }

    public Uri getDownloadUri(long j) {
        return this.f507dm.getUriForDownloadedFile(j);
    }

    public DownloadManager getDm() {
        return this.f507dm;
    }

    public int getDownloadStatus(long j) {
        Cursor cursorQuery = this.f507dm.query(new DownloadManager.Query().setFilterById(j));
        if (cursorQuery == null) {
            return -1;
        }
        try {
            if (cursorQuery.moveToFirst()) {
                return cursorQuery.getInt(cursorQuery.getColumnIndexOrThrow("status"));
            }
            return -1;
        } finally {
            cursorQuery.close();
        }
    }
}
