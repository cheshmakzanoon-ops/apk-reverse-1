package com.ishumei.smantifraud;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;

public class l1l1l1ll extends l1l11lI11l {
    public final Context l111l11111lIl;

    public l1l1l1ll(Context context) {
        this.l111l11111lIl = context;
    }

    public static boolean l1111l111111Il(Context context) {
        Cursor cursorQuery;
        try {
            Uri uri = Uri.parse("content://com.vivo.vms.IdProvider/IdentifierId/OAID");
            ContentResolver contentResolver = context.getContentResolver();
            if (contentResolver == null || (cursorQuery = contentResolver.query(uri, null, null, null, null)) == null) {
                return false;
            }
            cursorQuery.close();
            return true;
        } catch (Throwable unused) {
            return false;
        }
    }

    @Override
    public String l1111l111111Il() {
        Uri uri = Uri.parse("content://com.vivo.vms.IdProvider/IdentifierId/OAID");
        ContentResolver contentResolver = this.l111l11111lIl.getContentResolver();
        String string = "";
        if (contentResolver == null) {
            return "";
        }
        Cursor cursorQuery = contentResolver.query(uri, null, null, null, null);
        if (cursorQuery != null) {
            cursorQuery.moveToNext();
            int columnIndex = cursorQuery.getColumnIndex("value");
            string = columnIndex >= 0 ? cursorQuery.getString(columnIndex) : "";
            cursorQuery.close();
        }
        return string;
    }
}
